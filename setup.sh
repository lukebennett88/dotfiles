#!/bin/bash

# Dotfiles Setup Script
#
# This script sets up a new macOS system with dotfiles configuration.
# It handles installation of Homebrew, packages, and symlinking dotfiles.
#
# Packages are auto-discovered: any top-level directory (except scripts, .git,
# .stow-backups) is treated as a stow package. To add config for a new tool:
#
#   mkdir -p newtool/.config/newtool
#   echo "my config" > newtool/.config/newtool/config.toml
#   stow -t ~ newtool
#   # then commit

set -e

# -- Logging -------------------------------------------------------------------

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

info()    { printf "${BLUE}➜ %s${NC}\n" "$*"; }
success() { printf "${GREEN}✓ %s${NC}\n" "$*"; }
error()   { printf "${RED}✗ %s${NC}\n" "$*" >&2; }
warn()    { printf "${YELLOW}! %s${NC}\n" "$*"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

DOTFILES="$HOME/.dotfiles"

# -- Detect stow packages automatically ---------------------------------------
# Any top-level directory that isn't hidden, "scripts", or other non-package
# dirs is treated as a stow package.

stow_packages() {
	local packages=()
	for dir in "$DOTFILES"/*/; do
		dir="${dir%/}"
		name="$(basename "$dir")"
		case "$name" in
			scripts|.git|.stow-backups) continue ;;
		esac
		packages+=("$name")
	done
	echo "${packages[@]}"
}

# -- Stow ----------------------------------------------------------------------

perform_stow() {
	cd "$DOTFILES"

	# Clean up .DS_Store files that can block stow
	find "$HOME/.config" -name '.DS_Store' -delete 2>/dev/null || true

	local packages
	packages=$(stow_packages)
	info "Stowing packages: $packages"
	# shellcheck disable=SC2086
	stow -v -R --ignore='\.DS_Store' -t "$HOME" $packages

	success "Symlinks created successfully."
}

# -- Clone / update repo -------------------------------------------------------

info "Checking dotfiles repository..."
if [ ! -d "$DOTFILES" ]; then
	info "Cloning dotfiles repository..."
	git clone https://github.com/lukebennett88/dotfiles "$DOTFILES"
	success "Dotfiles repository cloned."
else
	info "Dotfiles repository already exists. Pulling latest..."
	git -C "$DOTFILES" pull
	success "Dotfiles repository updated."
fi

# -- Homebrew ------------------------------------------------------------------

info "Checking for Homebrew..."
if ! command_exists brew; then
	info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Make brew available for the rest of this script. The dotfiles-managed
	# .zprofile handles this for future shells, so we don't write to any file.
	if [[ $(uname -m) == "arm64" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		eval "$(/usr/local/bin/brew shellenv)"
	fi

	success "Homebrew installed."
else
	info "Homebrew is already installed."
	info "Updating Homebrew..."
	brew update
	success "Homebrew updated."
fi

# -- Brewfile ------------------------------------------------------------------

info "Installing Brewfile dependencies..."
if [ -f "$DOTFILES/Brewfile" ]; then
	brew bundle --file="$DOTFILES/Brewfile"
	success "Brewfile dependencies installed."
else
	error "Brewfile not found at $DOTFILES/Brewfile"
	exit 1
fi

# -- Stow packages -------------------------------------------------------------

info "Creating symlinks with Stow..."
if command_exists stow; then
	perform_stow
else
	error "GNU Stow is not installed. It should have been installed via Brewfile."
	exit 1
fi

# -- Bat themes ----------------------------------------------------------------

if command_exists bat; then
	info "Setting up bat themes..."
	mkdir -p "$DOTFILES/bat/.config/bat/themes"

	if curl -sf -o "$DOTFILES/bat/.config/bat/themes/Catppuccin Mocha.tmTheme" \
		"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"; then
		success "Catppuccin Mocha theme downloaded."
	else
		warn "Failed to download bat theme, using existing version if available."
	fi

	bat cache --build
	success "Bat cache built."
fi

# -- 1Password (optional) -----------------------------------------------------

if [ -f "$DOTFILES/scripts/setup-1password.sh" ]; then
	read -p "Would you like to set up 1Password for Git? (y/n) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		"$DOTFILES/scripts/setup-1password.sh"
	else
		info "Skipping 1Password setup. Run later with: ~/.dotfiles/scripts/setup-1password.sh"
	fi
fi

# -- Done ----------------------------------------------------------------------

success "Dotfiles setup complete!"
info "Please restart your terminal or run 'exec zsh' to apply all changes."
