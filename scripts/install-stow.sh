#!/bin/bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

DOTFILES="$(dotfiles_root)"

if ! command_exists stow; then
	error "GNU Stow is not installed. It should have been installed via Brewfile."
	exit 1
fi

# -- Detect stow packages automatically ---------------------------------------
# Any top-level directory that isn't hidden, "scripts", or other non-package
# dirs is treated as a stow package.

stow_packages() {
	local packages=()
	local dir name
	# nullglob: an unmatched glob expands to nothing rather than the literal pattern
	shopt -s nullglob
	for dir in "$DOTFILES"/*/; do
		dir="${dir%/}"
		name="$(basename "$dir")"
		case "$name" in
			scripts|.git|.stow-backups) continue ;;
		esac
		packages+=("$name")
	done
	shopt -u nullglob
	# bash 3.2 (macOS default) treats "${arr[@]}" on an empty array as unset under `set -u`.
	if [ "${#packages[@]}" -gt 0 ]; then
		echo "${packages[@]}"
	fi
}

info "Creating symlinks with Stow..."
cd "$DOTFILES"

# Clean up .DS_Store files that can block stow
find "$HOME/.config" -name '.DS_Store' -delete 2>/dev/null || true

packages=$(stow_packages)
if [ -z "$packages" ]; then
	warn "No stow packages found in $DOTFILES."
	exit 0
fi

# Stow only manages relative symlinks. Any pre-existing *absolute* symlink in
# $HOME that points back into $DOTFILES blocks restow ("existing target is
# not owned by stow"). They're safe to delete — stow will recreate them as
# relative symlinks on the next pass.
clean_absolute_symlinks() {
	local pkg src_file rel dest target
	for pkg in $packages; do
		[ -d "$DOTFILES/$pkg" ] || continue
		while IFS= read -r src_file; do
			rel="${src_file#"$DOTFILES/$pkg/"}"
			dest="$HOME/$rel"
			[ -L "$dest" ] || continue
			target="$(readlink "$dest")"
			case "$target" in
				"$DOTFILES"/*)
					info "Replacing absolute symlink: $dest"
					rm "$dest"
					;;
			esac
		done < <(find "$DOTFILES/$pkg" -type f -not -name '.DS_Store' 2>/dev/null)
	done
}
clean_absolute_symlinks

info "Stowing packages: $packages"
# shellcheck disable=SC2086
stow -v -R --ignore='\.DS_Store' -t "$HOME" $packages

success "Symlinks created successfully."
