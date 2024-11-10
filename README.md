# Dotfiles Setup

This repository contains the dotfiles for my system.

## Installation

You can run the setup script directly from this repository using `curl`. This will:

- Clone the dotfiles repository if not already cloned
- Install Homebrew if it is not already installed
- Install dependencies from the Brewfile
- Symlink dotfiles to their correct locations using GNU Stow
- Set iTerm2 preferences

To execute the script:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukebennett88/dotfiles/main/setup.sh)"
```

### Manual Steps

If any issues occur while running the script, or if you prefer a manual setup, follow these steps:

#### Install Homebrew (if not already installed):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install Brewfile dependencies:

```bash
brew bundle --no-lock --file=~/.dotfiles/Brewfile
```

#### Symlink the dotfiles using GNU Stow:

```bash
cd ~/.dotfiles
stow .
```

### Updating Brewfile

To update the Brewfile with any new dependencies, run:

```bash
brew bundle dump --no-lock --force
```

To remove any installed packages not listed in the Brewfile, run:

```bash
brew bundle cleanup --no-lock --force --file=~/.dotfiles/Brewfile
```

This command will uninstall all packages, casks, or taps not defined in the `Brewfile`, keeping your system aligned with the `Brewfile` contents.

### Reload the shell

After installation, start a new terminal session or reload the shell:

```bash
exec zsh
```

#### iTerm2

- Open iTerm2 and go to **iTerm2 > Preferences** (or press `⌘ + ,`).
- Under the **General** tab, in the **Settings** section:
  - Enable **"Load preferences from a custom folder or URL"**.
  - Set the path to your dotfiles directory: `~/.dotfiles/com.googlecode.iterm2.plist`.
  - Set **"Save changes"** to **"automatically"** to keep your settings updated.
- Restart iTerm2 to load your settings.
