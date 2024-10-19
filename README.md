# Dotfiles Setup

This repository contains the dotfiles for my system.

## Requirements

### Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installation

1. **Clone the repository**

	 First, clone this repository into your home directory:

	 ```bash
	 git clone https://github.com/lukebennett88/dotfiles ~/.dotfiles
	 ```
2. **Install Homebrew and packages**
	 Navigate to the `.dotfiles` directory and install the packages from the `Brewfile`:

	 ```bash
	 cd ~/.dotfiles
	 brew bundle install
	 ```
3. **Symlink the dotfiles**
	 Use GNU Stow to create symlinks for the dotfiles. This will place the files in the correct locations:

	 ```bash
	 stow .
	 ```

4. **Reload the shell**

	 After installation, start a new terminal session or reload the shell:

	 ```bash
	 exec zsh
	 ```
