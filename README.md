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

Only Phase 1 (Homebrew) is mandatory — everything else depends on the tools it installs. Every other phase prompts before running: hit Enter to accept (the default) or answer `n` to skip. That makes re-running setup for a single phase painless — just skip past the ones you don't need.

| Phase | Script                    | Optional? | What it does                                              |
| ----- | ------------------------- | --------- | --------------------------------------------------------- |
| 1     | `install-homebrew.sh`     | no        | Install or update Homebrew                                |
| 2     | `install-brewfile.sh`     | yes       | Required Brewfile, then `fzf` picker for optional entries |
| 3     | `install-stow.sh`         | yes       | Symlink configs from top-level dirs into `$HOME`          |
| 4     | `install-bat-themes.sh`   | yes       | Download Catppuccin theme, rebuild bat cache              |
| 5     | `install-skills.sh`       | yes       | mise + pnpm via corepack, restore Claude skills           |
| 6     | `install-rtk.sh`          | yes       | Link rtk filters, wire rtk into Claude Code + Codex        |
| 7     | `setup-macos-defaults.sh` | yes       | macOS defaults (Dock, Finder, keyboard)                   |
| 8     | `setup-1password.sh`      | yes       | SSH agent + Git signing via 1Password                     |

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

Each top-level dir is a stow package, except `scripts`, `rtk`, `.git`, and `.stow-backups`:

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

## rtk

[rtk](https://github.com/rtk-ai/rtk) (Rust Token Killer) is a token-optimizing CLI
proxy for AI coding agents. It's an optional Brewfile entry — pick it in the picker.

`install-rtk.sh` does three things, all idempotent:

- Symlinks the tracked global filters (`rtk/filters.toml`) into
  `~/Library/Application Support/rtk/filters.toml`.
- Wires rtk into **Claude Code** via `rtk init -g --auto-patch` (hook + `RTK.md` +
  `settings.json` patch + `@RTK.md` reference in `CLAUDE.md`).
- Wires rtk into **Codex** via `rtk init -g --codex` (`~/.codex/RTK.md` + `@RTK.md`
  reference in `~/.codex/AGENTS.md`).

```bash
~/.dotfiles/scripts/install-rtk.sh   # re-run any time; no-ops if already set up
```

> `rtk` is intentionally **not** a stow package. Its config dir also holds runtime
> data (`history.db`), so stow would fold that into the repo. The script symlinks
> only `filters.toml`. The hook/`RTK.md`/agent-config artifacts are regenerated by
> `rtk init`, so they aren't tracked.

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
