#!/bin/bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

info "Checking for Homebrew..."
if ! command_exists brew; then
	info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Make brew available for the current shell. The dotfiles-managed
	# .zprofile handles this for future shells, so we don't write to any file.
	if [[ $(uname -m) == "arm64" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		eval "$(/usr/local/bin/brew shellenv)"
	fi

	success "Homebrew installed."
else
	info "Homebrew is already installed. Updating..."
	brew update
	success "Homebrew updated."
fi
