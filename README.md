# .dotfiles

> These are my dotfiles. There are many like them, but these are mine. My dotfiles are my best friend. They are my life. I must master them as I must master my life.
>
> _The ~~Rifleman's~~ Developer's Creed_

## Instructions to configure a new machine

Run the following command to do all of the things! `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && git clone https://github.com/lukebennett88/dotfiles ~/.dotfiles && cd ~/.dotfiles && source setup-installer.sh && source setup-symlinks.sh && source setup-macos.sh`

1. Install [Homebrew](https://brew.sh/)
1. Install git: `brew install git`
1. Clone dotfiles to home directory: `git clone https://github.com/lukebennett88/dotfiles ~/.dotfiles`
1. Run script to set up symlinks: `source ~/.dotfiles/setup-symlinks.sh`
1. Run script to install software: `source ~/.dotfiles/setup-installer.sh`
1. Run script to configure Mac settings: `source ~/.dotfiles/setup-macos.sh`
1. Configure Visual Studio Code:
   - Overwrite user settings with settings [found here](https://gist.github.com/lukebennett88/9141bc2881906fca00bfa39029bd5c03)
   - Install 'Settings Sync' extension `code --install-extension shan.code-settings-sync`
   - Reload Visual Studio Code
   - `⌘ + ⇧ + P` Sync: Download Settings
   - Create new personal access token/regenerate token. Make sure `gist` is ticked.
   - Paste token into prompt on Visual Studio Code
   - To update application icon — right click on `/Applications/Visual Studio Code.app > Get Info` and drag the `vscode-cobaltnext.icns file onto the application icon at the top of the 'Get Info' window
1. Configure Alfred:
   - `Preferences > Advanced > Set preferences folder...`set to `~/.dotfile`
   - Make sure Alfred Clipboard is enabled: `Preferences > Features > Clipboard > Keep Plain Text` check checkbox and set to 7 days
   - Make sure 'Oceanic Next' theme is enabled, it is included in the dotfiles under `oceanic-next.alfredappearance` if it is not
1. Configure iTerm:
   - `Preferences > General > Preferences > Load preferences from a custom folder or URL:` and set to `~/.dotfile`
   - Make sure 'Oceanic Next' theme is enabled, it is included in the dotfiles under `oceanic-next.itermcolors` if it is not
1. Configure fish:
   - Add fish to `etc/shells` using the following command: `echo /usr/local/bin/fish | sudo tee -a /etc/shells`
   - Set fish as default shell `chsh -s /usr/local/bin/fish`
1. Install apps that cannot be installed via a script:
   - [Sip](https://sipapp.io/download/sip.dmg)
   - [PixelSnap](https://gumroad.com/d/238485f7b5dbb3037087d4665abc71d2)
