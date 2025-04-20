#!/bin/bash

# Dotfiles Setup Script
#
# This script sets up a new macOS system with dotfiles configuration
# It handles installation of Homebrew, packages, and symlinking dotfiles

# Exit on error
set -e

# Color definitions
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Log functions
info() { printf "${BLUE}➜ %s${NC}\n" "$*"; }
success() { printf "${GREEN}✓ %s${NC}\n" "$*"; }
error() { printf "${RED}✗ %s${NC}\n" "$*" >&2; }
warn() { printf "${YELLOW}! %s${NC}\n" "$*"; }

# Check if a command exists
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# Clone the repository
info "Checking dotfiles repository..."
if [ ! -d "$HOME/.dotfiles" ]; then
	info "Cloning dotfiles repository..."
	git clone https://github.com/lukebennett88/dotfiles ~/.dotfiles
	success "Dotfiles repository cloned successfully."
else
	info "Dotfiles repository already exists. Checking for updates..."
	cd "$HOME/.dotfiles"
	git pull
	success "Dotfiles repository updated successfully."
fi

# Install Homebrew if not installed
info "Checking for Homebrew installation..."
if ! command_exists brew; then
	info "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	# Add Homebrew to PATH based on chip architecture
	if [[ $(uname -m) == "arm64" ]]; then
		# For Apple Silicon Macs
		info "Adding Homebrew to PATH for Apple Silicon Mac..."
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		# For Intel Macs
		info "Adding Homebrew to PATH for Intel Mac..."
		echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
		eval "$(/usr/local/bin/brew shellenv)"
	fi

	success "Homebrew installed and configured successfully."
else
	info "Homebrew is already installed."
	brew --version
	info "Updating Homebrew..."
	brew update
	success "Homebrew updated successfully."
fi

# Install Brewfile dependencies
info "Installing Brewfile dependencies..."
if [ -f "$HOME/.dotfiles/Brewfile" ]; then
	brew bundle --file="$HOME/.dotfiles/Brewfile"
	success "Brewfile dependencies installed successfully."
else
	error "Brewfile not found at $HOME/.dotfiles/Brewfile"
	exit 1
fi

# Symlink dotfiles using GNU Stow
info "Creating symlinks with Stow..."
if command_exists stow; then
	cd "$HOME/.dotfiles"

	# Stow the 'home_files' package, targeting the parent directory ($HOME)
	info "Stowing files from home_files/ directory..."
	# Use --restow (-R) to first unstow existing symlinks and then stow again.
	# This ensures changes (adds/removes/renames) in home_files are correctly reflected.
	stow -v -R home_files

	success "Symlinks created successfully."
else
	error "GNU Stow is not installed. Trying to install it now..."
	brew install stow
	if command_exists stow; then
		cd "$HOME/.dotfiles"
		info "Stowing files from home_files/ directory..."
		# Use --restow (-R) after installing stow as well.
		stow -v -R home_files # Run stow again after installing
		success "Stow installed and symlinks created successfully."
	else
		error "Failed to install GNU Stow. Please install it manually with 'brew install stow'"
		exit 1
	fi
fi

# Check for terminal and other recommended tools
info "Checking additional configurations..."

# Check for Ghostty
if command_exists ghostty; then
	success "Ghostty terminal is installed"
else
	warn "Ghostty terminal is not installed. Consider installing it with 'brew install --cask ghostty'"
fi

# Check for mise (modern Python/Ruby/Node version manager)
if command_exists mise; then
	success "mise is installed ($(mise --version))"
else
	warn "mise is not installed. It's recommended for managing runtime versions."
fi

# Check for starship prompt
if command_exists starship; then
	success "Starship prompt is installed ($(starship --version))"
else
	warn "Starship prompt is not installed. Consider installing it with 'brew install starship'"
fi

# Final setup
success "Dotfiles setup complete!"
info "Please restart your terminal or run 'exec zsh' to apply all changes."

# Offer to reload the shell
read -p "Would you like to reload the shell now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	info "Reloading the shell..."
	exec zsh
else
	info "Please restart your terminal or run 'exec zsh' to apply all changes."
fi
