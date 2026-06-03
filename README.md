# Dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick start

Fresh Mac:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukebennett88/dotfiles/main/setup.sh)"
```

Repo already cloned:

```bash
~/.dotfiles/setup.sh
```

## How it works

`setup.sh` runs each phase as a separate script under `scripts/`. Any script can be re-run on its own.

| Phase | Script                    | What it does                                              |
| ----- | ------------------------- | --------------------------------------------------------- |
| 1     | `install-homebrew.sh`     | Install or update Homebrew                                |
| 2     | `install-brewfile.sh`     | Required Brewfile, then `fzf` picker for optional entries |
| 3     | `install-stow.sh`         | Symlink configs from top-level dirs into `$HOME`          |
| 4     | `install-bat-themes.sh`   | Download Catppuccin theme, rebuild bat cache              |
| 5     | `install-skills.sh`       | mise + pnpm via corepack, restore Claude skills           |
| 6     | `setup-macos-defaults.sh` | macOS defaults (optional)                                 |
| 7     | `setup-1password.sh`      | SSH agent + Git signing via 1Password (optional)          |

Failed runs preserve `setup-YYYYMMDD-HHMMSS.log` in the repo root and print the path. Successful runs clean up.

## Brewfile

`Brewfile` is bootstrap-only — just the CLI tools needed for a working shell and to run the installer itself (`git`, `stow`, `mise`, `zsh`, `starship`, `fzf`, `zoxide`, `eza`, `bat`, `ripgrep`, `fd`, `mas`). Everything else — GUI apps, fonts, and situational CLIs — lives in `Brewfile.optional` and is chosen from an `fzf` checklist picker.

```bash
~/.dotfiles/scripts/install-brewfile.sh         # required + picker
~/.dotfiles/scripts/install-brewfile.sh --all   # required + all optional
~/.dotfiles/scripts/install-brewfile.sh --none  # required only
```

`Brewfile.optional` format:

```text
brew:doggo                       # modern DNS client
cask:figma                       # design tool
tap:anomalyco/tap
mas:1Password for Safari=1569813296
```

Selections feed into `brew bundle --file=-`.

### Maintenance

```bash
# Remove anything not in Brewfile (ignores Brewfile.optional)
brew bundle cleanup --force --file=~/.dotfiles/Brewfile
```

> **Warning:** avoid `brew bundle dump --file=~/.dotfiles/Brewfile` — it rewrites the
> file from _everything_ currently installed, which re-bloats the bootstrap-only
> `Brewfile` and undoes the split. Add new situational items to `Brewfile.optional` by
> hand instead.

> **Warning:** `brew bundle cleanup` only consults the required `Brewfile`, so it
> will uninstall everything you picked from `Brewfile.optional`. Treat it as a reset
> back to the bootstrap baseline — re-run the picker (or `install-brewfile.sh --all`)
> to restore your optional packages afterwards.

VS Code extensions sync through Settings Sync, hence `--no-vscode`.

## Adding a new config

Each top-level dir is a stow package, except `scripts`, `.git`, and `.stow-backups`:

```bash
mkdir -p newtool/.config/newtool
echo "my config" > newtool/.config/newtool/config.toml
stow -t ~ newtool
git add newtool && git commit -m "Add newtool config"
```

## Machine-specific config

Anything that should only run on one machine (per-machine tool inits, PATH tweaks,
work-only aliases) goes in `~/.config/zsh/.zshrc.local`, which `.zshrc` sources last and
`.gitignore` keeps untracked. Bootstrap it from the tracked template:

```bash
cp ~/.config/zsh/.zshrc.local.example ~/.config/zsh/.zshrc.local
```

## Skills

`install-skills.sh` activates mise, prepares pnpm via corepack, and runs `pnpm dlx skills experimental_install`. Skills are tracked in `skills/.local/state/skills/.skill-lock.json`.

## 1Password

`setup-1password.sh` (optional) writes:

- 1Password SSH agent socket into `~/.ssh/config`
- `~/.gitconfig-1password-ssh` for SSH-based commit signing (sourced by the main gitconfig)

Requires the 1Password app with SSH agent enabled, the 1Password CLI, and an SSH key item named `GitHub key`.

## macOS defaults

`setup-macos-defaults.sh` (optional) sets:

- Finder: show extensions, path bar, status bar; column view; folders on top; search current folder; new windows open at `$HOME`; no `.DS_Store` on network/USB
- Dock: `tilesize=37`, hide recent apps
- Keyboard: fast key repeat (2/15), no press-and-hold accent picker, full keyboard access in dialogs
- Appearance: auto-switch Light/Dark
- Launch Services: no "Are you sure?" prompt for downloaded apps
- Screenshots saved to `~/Downloads`
- App Store: daily update check, auto-install
