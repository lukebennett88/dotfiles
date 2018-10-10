# dotfiles

Before doing anything, make sure you know what are you doing! Settings applied by this repository are very personal, and definitely not suite everyone's needs. I suggest to create your own set of dotfiles based on this repo.

1. Install [Homebrew](https://brew.sh/)

1. Install git

`brew install git`

1. Clone repository to hidden .dotfile directory in your home directory

`git clone https://github.com/lukebennett88/dotfiles ~/.dotfile`

1. Run setup-symlinks.sh

`source ~/.dotfiles/setup-symlinks.sh`

1. Same with setup-macos.sh file

`source ~/.dotfiles/setup-osx.sh`

1. Same with setup-brew.sh file

`source ~/.dotfiles/setup-osx.sh`

1. Update Visual Studio Code settings

- Overwrite user settings with settings [found here](https://gist.github.com/lukebennett88/9141bc2881906fca00bfa39029bd5c03)
- Install 'Settings Sync' extension

`code --install-extension shan.code-settings-sync`

- Reload Visual Studio Code

- `⌘` + `⇧` + `P` Sync: Download Settings

- Create new personal access token/regenerate token. Make sure 'gist' is ticked.

- Paste token into prompt on Visual Studio Code

1. Configure Alfred settings

Alfred: use GUI

```bash
~/.dotfiles
```

1. Enable Alfred clipboard (plain text for 7 days) and your personalized theme.

1. Manually install PixelSnap & Sip

Todo: For loop to create symlinks to fish functions is broken
