#!/bin/bash
set -euo pipefail

# Dotfiles orchestrator.
#
# Runs each phase as a separate script under scripts/. Any phase can be
# re-run in isolation (e.g. ./scripts/install-brewfile.sh).
#
# Packages are auto-discovered: any top-level directory (except scripts, .git,
# .stow-backups) is treated as a stow package. To add config for a new tool:
#
#   mkdir -p newtool/.config/newtool
#   echo "my config" > newtool/.config/newtool/config.toml
#   stow -t ~ newtool
#   # then commit

DOTFILES="$HOME/.dotfiles"

# Make sure prompts work even if invoked through a pipe.
[ -t 0 ] || exec < /dev/tty

# -- Clone / update repo -------------------------------------------------------
# Must run BEFORE we open a log file under $DOTFILES — git refuses to clone
# into a non-empty directory.

if [ ! -d "$DOTFILES/.git" ]; then
	echo "➜ Cloning dotfiles repository..."
	git clone https://github.com/lukebennett88/dotfiles "$DOTFILES"
else
	echo "➜ Dotfiles repository exists. Pulling latest..."
	git -C "$DOTFILES" pull
fi

# -- Logging -------------------------------------------------------------------
# Stream output to a timestamped log file. On clean exit the log is deleted —
# successful runs leave no trace. On failure the log is kept and its path is
# echoed so you have something to grep.

LOG_FILE="$DOTFILES/setup-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

cleanup_log() {
	local code=$?
	# Let tee finish draining before we touch the file.
	sync 2>/dev/null || true
	if [ "$code" -eq 0 ]; then
		rm -f "$LOG_FILE"
	else
		echo "" >&2
		echo "✗ Setup failed (exit $code)." >&2
		echo "  Log preserved at: $LOG_FILE" >&2
	fi
}
trap cleanup_log EXIT

# Load shared helpers now that the repo is on disk.
# shellcheck source=scripts/lib.sh
source "$DOTFILES/scripts/lib.sh"

# -- Phases --------------------------------------------------------------------

# Phase 1 (Homebrew) is mandatory — everything else depends on the tools it
# installs. Every other phase is optional: hit Enter to accept (the default) or
# answer "n" to skip, which is handy when re-running setup for just one phase.

step "Phase 1 — Homebrew"
"$DOTFILES/scripts/install-homebrew.sh"

step "Phase 2 — Brewfile (required + optional picker)"
optional_phase "Install Homebrew packages (required Brewfile + optional picker)?" \
	"$DOTFILES/scripts/install-brewfile.sh" \
	"Skipping Brewfile. Run later: ~/.dotfiles/scripts/install-brewfile.sh"

step "Phase 3 — Stow symlinks"
optional_phase "Symlink dotfiles into \$HOME with stow?" \
	"$DOTFILES/scripts/install-stow.sh" \
	"Skipping stow. Run later: ~/.dotfiles/scripts/install-stow.sh"

step "Phase 4 — Bat themes"
optional_phase "Install bat themes?" \
	"$DOTFILES/scripts/install-bat-themes.sh" \
	"Skipping bat themes. Run later: ~/.dotfiles/scripts/install-bat-themes.sh"

step "Phase 5 — Skills"
optional_phase "Restore Claude skills?" \
	"$DOTFILES/scripts/install-skills.sh" \
	"Skipping skills. Run later: ~/.dotfiles/scripts/install-skills.sh"

step "Phase 6 — macOS defaults"
optional_phase "Apply macOS defaults (Dock, Finder, keyboard)?" \
	"$DOTFILES/scripts/setup-macos-defaults.sh" \
	"Skipping macOS defaults. Run later: ~/.dotfiles/scripts/setup-macos-defaults.sh"

step "Phase 7 — 1Password for Git"
optional_phase "Set up 1Password for Git?" \
	"$DOTFILES/scripts/setup-1password.sh" \
	"Skipping 1Password setup. Run later: ~/.dotfiles/scripts/setup-1password.sh"

# -- Done ----------------------------------------------------------------------

step "Done"
success "Dotfiles setup complete."
echo ""
info "Manual steps remaining:"
cat <<'EOF'
  1. Sign into the Mac App Store (mas requires it for paid apps)
  2. Sign into 1Password app and enable CLI integration
       Settings → Developer → "Integrate with 1Password CLI"
  3. Sign into Setapp (for apps you chose to install from there)
  4. Sign into Slack, Zoom, Obsidian, Raycast, etc.
  5. Import GPG keys from backup if applicable
  6. Configure Tailscale: tailscale up
  7. Open a new terminal (or `exec zsh`) to load the shell config
EOF
