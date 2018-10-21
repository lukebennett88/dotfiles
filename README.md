# .dotfiles

> These are my dotfiles. There are many like them, but these are mine. My dotfiles are my best friend. They are my life. I must master them as I must master my life.
>
> _The ~~Rifleman's~~ Developer's Creed_

## Instructions to configure a new machine

1. Install [Homebrew](https://brew.sh/)
2. Install git: `brew install git`
3. Clone dotfiles to home directory: `git clone https://github.com/lukebennett88/dotfiles ~/.dotfile`
4. Update terminal theme:
    - Open dotfiles directory `cd ~/.dotfiles ; open .`
    - Double click on `gatito.terminal`
    - In Terminal `Preferences > Profiles` select Gatito from sidebar and select `Default`
5. Run script to set up symlinks: `source ~/.dotfiles/setup-symlinks.sh`
6. Run script to install software: `source ~/.dotfiles/setup-installer.sh`
7. Run script to configure Mac settings: `source ~/.dotfiles/setup-macos.sh`
8. Configure Visual Studio Code:
    - Overwrite user settings with settings [found here](https://gist.github.com/lukebennett88/9141bc2881906fca00bfa39029bd5c03)
    - Install 'Settings Sync' extension `code --install-extension shan.code-settings-sync`
    - Reload Visual Studio Code
    - `⌘ + ⇧ + P` Sync: Download Settings
    - Create new personal access token/regenerate token. Make sure `gist` is ticked.
    - Paste token into prompt on Visual Studio Code
9. Configure Alfred:
    - `Preferences > Advanced > Set preferences folder...`set to `~/.dotfile`
    - Make sure Alfred Clipboard is enabled: `Preferences > Features > Clipboard > Keep Plain Text` check checkbox and set to 7 days
    - Make sure Gatito theme is enabled, it is included in the dotfiles under `gatito.alfredappearance` if it is not
10. Configure iTerm:
    - `Preferences > General > Preferences > Load preferences from a custom folder or URL:` and set to `~/.dotfile`
    - Make sure Gatito theme is enabled, it is included in the dotfiles under `gatito.itermcolors` if it is not
11. Configure fish:
    - Set fish as default shell `chsh -s /usr/local/bin/fish`
    - If fish isn't already added to `etc/shells` do so via the following command: `echo /usr/local/bin/fish | sudo tee -a /etc/shells` and repeat previous step
12. Install apps that cannot be installed via a script:
    - [Sip](https://sipapp.io/download/sip.dmg)
    - [PixelSnap](https://gumroad.com/d/238485f7b5dbb3037087d4665abc71d2)
