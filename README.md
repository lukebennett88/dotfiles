# Dotfiles

macOS on Apple Silicon, managed with [GNU Stow](https://www.gnu.org/software/stow/) and [just](https://github.com/casey/just).

## Bootstrap

```bash
git clone https://github.com/lukebennett88/dotfiles ~/.dotfiles
~/.dotfiles/setup.sh
```

`setup.sh` installs Homebrew and `just` if needed, then runs the default bootstrap: essentials, Stow links, mise Node.js and pnpm, and the bat theme cache. It does not pull Git changes, install optional apps, or change macOS preferences.

## Commands

From the repository directory:

```bash
cd ~/.dotfiles
just                 # default bootstrap
just optional        # full additional inventory
just drift           # report Homebrew drift (read-only)
just stow            # relink configs
just check           # validate configs without changing anything
just runtimes        # Node.js and pnpm from mise
just skills          # install skills listed in skills.txt
just skills-drift    # report drift from skills.txt (read-only)
just agents          # install agents and skills
just macos           # apply macOS preferences
```

From another directory, pass `--justfile ~/.dotfiles/justfile` before the recipe name.

`stow` uses an explicit package list, refuses conflicts, and does not adopt, back up, or remove existing files. Zsh history, completion caches, sessions, and local config stay unlinked via `.stowrc`.

## Homebrew

`Brewfile` is the shell essentials (including `just`, Ghostty, VS Code, Worktrunk, GitHub CLI, and Zsh plugins). `optional/Brewfile` is the rest: extra CLIs, fonts, GUI apps, Setapp alternatives, and Mac App Store apps, including alternatives kept side by side. Apply with `just packages` or `just optional`, or edit a manifest and install individual entries.

Do not run `brew bundle cleanup` against only one manifest; that treats the other manifest's entries as unwanted. Use `just drift` to report what is installed but listed in neither file, and what is listed but not installed.

To update, pull Git changes, review them, then run the recipe you want.

## Skills and agents

`skills.txt` lists skills as `<source> <skill>...` per line (`#` starts a whole-line comment). `just skills` runs `scripts/skills.sh`, which uses `skills@1.7.0` to install each entry into `~/.agents/skills` and add Claude Code compatibility links. Codex reads that directory directly. The global lock file is machine state and is not tracked. Removing a line does not uninstall the skill.

`just skills-drift` reports skills listed but not installed, installed but not listed, and `~/.claude/skills` links that are dangling or point outside `~/.agents/skills`.

`just agents` stows the optional mise config for Aube, installs Claude Code via its native installer, installs Aube via mise, then installs the listed skills. Codex is in `optional/Brewfile` (`just optional`). The default mise config is only Node.js and pnpm. Sign in to each tool with its own login flow.

## Worktrees

Set tool roots separately: Claude Code Desktop → Settings → Claude Code → Worktree location → `~/.worktrees/claude`; Codex → Settings → Worktrees → Worktree root → `~/.worktrees/codex`. Worktrunk's tracked template uses `~/.worktrees/worktrunk/<owner>/<repo>/<branch>` (branch names sanitized). Existing Worktrunk worktrees are left in place. Claude Code and Codex preferences stay machine-local.

## Machine-specific shell config

Put machine-only PATH entries and tool init in `~/.config/zsh/.zshrc.local` (gitignored). It loads after shared settings and before syntax highlighting. Add Vite+ or a local OpenCode CLI there when needed. mise manages Node.js and pnpm.

## Authentication and Git signing

Run `gh auth login` for GitHub CLI. Credentials stay in gh's user config, which is not tracked.

For 1Password SSH, enable the SSH agent in 1Password's Developer settings and add to `~/.ssh/config`:

```sshconfig
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

For Git signing, choose the public key from your 1Password item and configure the machine-local include:

```bash
git config --file ~/.gitconfig-1password-ssh gpg.format ssh
git config --file ~/.gitconfig-1password-ssh gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --file ~/.gitconfig-1password-ssh user.signingkey ~/.ssh/your-public-key.pub
git config --file ~/.gitconfig-1password-ssh commit.gpgsign true
```

Replace the public-key path with the key you chose. Keep private keys and generated 1Password or gh state out of this repository.

## macOS preferences

`just macos` applies `scripts/setup-macos-defaults.sh`: Finder display and search, Dock size and recents, keyboard repeat and navigation, automatic appearance, and screenshot location. Set automatic macOS and App Store updates in System Settings → General → Software Update → Automatic Updates; those live in the system domain and this unprivileged script does not change them.
