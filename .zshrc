# .zshrc

# Set Homebrew path based on system architecture
if [[ $(uname -m) == 'arm64' ]]; then
	# Apple Silicon Mac
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	# Intel Mac
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Initialise Starship prompt
eval "$(starship init zsh)"

# Directory for Zinit (plugin manager for Zsh) and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install Zinit if missing
if [ ! -d "$ZINIT_HOME" ]; then
	echo "Zinit not found, installing…"
	mkdir -p "$(dirname "$ZINIT_HOME")"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Shell integrations
eval "$(mise activate zsh)"					# ‘mise’ (node version manager)
eval "$(mise hook-env -s zsh)"
eval "$(fzf --zsh)"									# ‘fzf’ keybindings for fuzzy file finding
eval "$(zoxide init --cmd cd zsh)"	# ‘zoxide’ (smarter ‘cd’ command)

# Zinit plugins
zinit ice wait lucid; zinit light Aloxaf/fzf-tab																# Replace Zsh’s default completion selection with ‘fzf’
zinit ice wait lucid; zinit light grigorii-zander/zsh-npm-scripts-autocomplete	# Autocomplete npm scripts
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions									# Suggest commands based on history
zinit ice wait lucid; zinit light zsh-users/zsh-completions											# Additional autocompletion options
zinit ice wait lucid; zinit light zsh-users/zsh-syntax-highlighting							# Syntax highlighting for commands

# Zinit snippets
zinit ice wait lucid; zinit snippet OMZP::git																		# Git aliases and functions

# History settings
HISTSIZE=5000								# Max history entries stored in memory (per session)
HISTFILE=~/.zsh_history			# History file to save commands between sessions
SAVEHIST=$HISTSIZE					# Save same number of history entries to history file as in memory
HISTDUP=erase								# Keep only the latest duplicate
setopt appendhistory				# Append to history file on exit rather than overwriting
setopt sharehistory					# Share history across all open terminal sessions
setopt hist_ignore_space		# Ignore history entries beginning with a space (for private commands)
setopt hist_ignore_all_dups	# Remove all duplicates from history file
setopt hist_save_no_dups		# Prevent duplicate history entries in history file
setopt hist_ignore_dups			# Ignore consecutive duplicates in current session
setopt hist_find_no_dups		# Prevent duplicates when searching history

# Keybindings
bindkey '^[[A' history-search-backward	# Up arrow for history search
bindkey '^[[B' history-search-forward		# Down arrow for history search

# Initialise ‘compinit’ for autocompletion
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'							# Case-insensitive matching
zstyle ':completion:*' menu no																			# Use ‘fzf’ completion menu
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'	# Show directory contents for ‘cd’ completion

# Aliases
alias ..='cd ..'																												# Go up one directory
alias c='clear'																													# Clear the terminal screen
alias cat='bat'																													# A ‘cat’ clone with syntax highlighting and git integration
alias gcf='git clean -fxd'																							# Remove untracked files and directories in git
alias ls="eza"																													# A modern replacement for ls
alias ll="eza --long --all --group-directories-first --icons"						# List all files with details and icons
alias tree="eza --tree"																									# List files in a tree-like structure
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"	# Tailscale CLI

# Use ‘bat’ for colourised man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Set XDG directories for consistent file organisation
export XDG_CACHE_HOME="$HOME/.cache"				# Cache files (~/.cache)
export XDG_CONFIG_HOME="$HOME/.config"			# Config files (~/.config)
export XDG_DATA_HOME="$HOME/.local/share"		# Application data (~/.local/share)
export XDG_STATE_HOME="$HOME/.local/state"	# State files (~/.local/state)

# Delete all local branches except the specified one (default: main)
gbdm() {
	local keep_branch="${1:-main}"
	git branch | rg -v "^\*?\s*(${keep_branch})\$" | xargs git branch -D
}
