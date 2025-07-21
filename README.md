# Dotfiles Setup

This repository contains the dotfiles for my macOS system. It includes configurations for terminal, shell, and various development tools.

## Installation

### Remote Installation

You can run the setup script directly from this repository using `curl`. This will:

- Clone the dotfiles repository if not already cloned
- Install Homebrew if it is not already installed
- Install dependencies from the Brewfile
- Symlink dotfiles to their correct locations using GNU Stow

To execute the script remotely:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukebennett88/dotfiles/main/setup.sh)"
```

### Local Installation

If you've already cloned the repository, you can run the setup script locally:

```bash
# Make the script executable first
chmod +x ~/.dotfiles/setup.sh

# Run the script
~/.dotfiles/setup.sh
```

### Manual Steps

If any issues occur while running the script, or if you prefer a manual setup, follow these steps:

#### Install Homebrew (if not already installed):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install Brewfile dependencies:

```bash
# Navigate to the dotfiles directory
cd ~/.dotfiles

# Install dependencies from the Brewfile (using the specific file path)
brew bundle --file=~/.dotfiles/Brewfile
```

#### Symlink the dotfiles using GNU Stow:

```bash
cd ~/.dotfiles
stow home_files
```

### Updating Brewfile

To update the Brewfile with any new dependencies, run:

```bash
brew bundle dump --force --file=~/.dotfiles/Brewfile
```

To remove any installed packages not listed in the Brewfile, run:

```bash
brew bundle cleanup --force --file=~/.dotfiles/Brewfile
```

This command will uninstall all packages, casks, or taps not defined in the `Brewfile`, keeping your system aligned with the `Brewfile` contents.

## 1Password Setup

Optional setup for using 1Password as your SSH agent and for Git commit signing.

### Automatic Setup

Run the setup script:

```bash
~/.dotfiles/scripts/setup-1password.sh
```

This will:

- Configure SSH to use 1Password agent
- Set up Git commit signing (requires 1Password CLI)

### Requirements

- 1Password app with SSH agent enabled
- For Git signing: 1Password CLI (`brew install --cask 1password/tap/1password-cli`)
- SSH key stored in 1Password (customize script if item name isn't "GitHub key")
