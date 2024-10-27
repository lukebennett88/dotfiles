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

		Install Homebrew:

		```bash
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		```
		
		Then install dependencies from the Brewfile:

		```bash
		brew bundle --file=~/.dotfiles/Brewfile
		```

		To update the Brewfile with any new dependencies, run:

		```bash
		brew bundle dump --force
		```

		To remove any installed packages not listed in the Brewfile, run:

		```bash
		brew bundle --force cleanup --file=~/.dotfiles/Brewfile
		```

		This command will uninstall all packages, casks, or taps not defined in the `Brewfile`, keeping your system aligned with the `Brewfile` contents.

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

## iTerm2

To sync your iTerm2 preferences (such as themes, fonts, and profiles), point iTerm2 to the `com.googlecode.iterm2.plist` file stored in this repository.

- Open iTerm2 and go to **iTerm2 > Preferences** (or press `⌘ + ,`).
- Under the **General** tab, in the **Settings** section:
	- Enable **"Load preferences from a custom folder or URL"**.
	- Set the path to your dotfiles directory: `~/.dotfiles/com.googlecode.iterm2.plist`.
	- Set **"Save changes"** to **"automatically"** to keep your settings updated.
- Restart iTerm2 to load your settings.
