#!/bin/bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

DOTFILES="$(dotfiles_root)"

if ! command_exists bat; then
	warn "bat not installed. Skipping theme setup."
	exit 0
fi

info "Setting up bat themes..."
mkdir -p "$DOTFILES/bat/.config/bat/themes"

if curl -sf -o "$DOTFILES/bat/.config/bat/themes/Catppuccin Mocha.tmTheme" \
	"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"; then
	success "Catppuccin Mocha theme downloaded."
else
	warn "Failed to download bat theme, using existing version if available."
fi

if bat cache --build; then
	success "Bat cache built."
else
	warn "bat cache build failed."
fi
