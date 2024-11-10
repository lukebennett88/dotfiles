#!/bin/bash

# Dotfiles Setup Script

# Step 1: Clone the repository
if [ ! -d "$HOME/.dotfiles" ]; then
	echo "Cloning dotfiles repository..."
	git clone https://github.com/lukebennett88/dotfiles ~/.dotfiles
else
	echo "Dotfiles repository already exists. Skipping clone."
fi

# Step 2: Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew is already installed. Skipping."
fi

# Step 3: Install Brewfile dependencies
echo "Installing Brewfile dependencies..."
brew bundle --file="$HOME/.dotfiles/Brewfile"

# Step 4: Symlink dotfiles using GNU Stow
if command -v stow &> /dev/null; then
	echo "Creating symlinks with Stow..."
	cd "$HOME/.dotfiles" && stow .
else
	echo "GNU Stow is not installed. Please install it with Homebrew."
fi

# Step 5: Set iTerm2 preferences
echo "Setting iTerm2 preferences..."
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$HOME/.dotfiles"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

# Step 6: Reload the shell
echo "Reloading the shell..."
exec zsh

echo "Dotfiles setup complete. Please restart your terminal."
