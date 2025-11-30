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

# Backup a conflicting file before stowing
backup_conflict_file() {
	local target="$1"
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		local rel="${target#$HOME/}"
		local timestamp
		timestamp=$(date +%Y%m%d%H%M%S)
		local backup_dir="$HOME/.dotfiles/.stow-backups/$timestamp/$(dirname "$rel")"
		local backup_path="$backup_dir/$(basename "$target")"

		mkdir -p "$backup_dir"
		warn "Found existing file at $target (not a symlink). Backing it up to $backup_path"
		mv "$target" "$backup_path"
	fi
}

# Remove macOS metadata files that can block stow
cleanup_stow_metadata() {
	if [ -d "$HOME/.config" ]; then
		find "$HOME/.config" -name '.DS_Store' -delete 2>/dev/null || true
	fi
}

# Run stow with a bit of preflight cleanup
perform_stow() {
	cd "$HOME/.dotfiles"

	info "Cleaning up metadata before stowing..."
	cleanup_stow_metadata

	# Known conflict: Cursor may have created its own config before dotfiles were stowed
	backup_conflict_file "$HOME/.config/cursor/cli-config.json"

	info "Stowing files from home_files/ directory..."
	# Use --restow (-R) to first unstow existing symlinks and then stow again.
	# Ignore macOS metadata files.
	stow -v -R --ignore='\\.DS_Store' home_files

	success "Symlinks created successfully."
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
	perform_stow
else
	error "GNU Stow is not installed. Trying to install it now..."
	brew install stow
	if command_exists stow; then
		perform_stow
	else
		error "Failed to install GNU Stow. Please install it manually with 'brew install stow'"
		exit 1
	fi
fi

# Download and build bat themes
info "Setting up bat themes..."
if command_exists bat; then
	# Create themes directory if it doesn't exist
	mkdir -p "$HOME/.dotfiles/home_files/.config/bat/themes"

	# Download latest Catppuccin Mocha theme
	info "Downloading latest Catppuccin Mocha theme..."
	curl -s -o "$HOME/.dotfiles/home_files/.config/bat/themes/Catppuccin Mocha.tmTheme" \
		"https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"

	if [ $? -eq 0 ]; then
		success "Catppuccin Mocha theme downloaded successfully."
	else
		warn "Failed to download theme, using existing version if available."
	fi

	# Build bat cache for themes
	info "Building bat cache..."
	bat cache --build
	success "Bat cache built successfully."
else
	warn "Bat is not installed yet. Run 'bat cache --build' after installing bat to enable custom themes."
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

# Setup 1Password Git configuration (optional)
if [ -f "$HOME/.dotfiles/scripts/setup-1password.sh" ]; then
	read -p "Would you like to set up 1Password for Git? (y/n) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		"$HOME/.dotfiles/scripts/setup-1password.sh"
	else
		info "Skipping 1Password setup. Run later with: ~/.dotfiles/scripts/setup-1password.sh"
	fi
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
