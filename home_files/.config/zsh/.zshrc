# Interactive shell configuration

# ZDOTDIR is now set in .zshenv

# Load zsh configurations

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
eval "$(mise activate zsh)"					# 'mise' (runtime version manager)
eval "$(mise hook-env -s zsh)"
eval "$(fzf --zsh)"									# 'fzf' keybindings for fuzzy file finding
eval "$(zoxide init --cmd cd zsh)"	# 'zoxide' (smarter 'cd' command)

# Zinit plugins
zinit ice wait lucid; zinit light Aloxaf/fzf-tab																# Replace Zsh's default completion selection with 'fzf'
zinit ice wait lucid; zinit light grigorii-zander/zsh-npm-scripts-autocomplete	# Autocomplete npm scripts
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions									# Suggest commands based on history
zinit ice wait lucid; zinit light zsh-users/zsh-completions											# Additional autocompletion options
zinit ice wait lucid; zinit light zsh-users/zsh-syntax-highlighting							# Syntax highlighting for commands

# Zinit snippets
zinit ice wait lucid; zinit snippet OMZP::git																		# Git aliases and functions from Oh My Zsh

# History settings
HISTSIZE=10000										# Max history entries stored in memory (per session)
HISTFILE="$ZDOTDIR/.zsh_history"	# History file to save commands between sessions
SAVEHIST=$HISTSIZE								# Save same number of history entries to history file as in memory
HISTDUP=erase											# Keep only the latest duplicate
setopt appendhistory							# Append to history file on exit rather than overwriting
setopt sharehistory								# Share history across all open terminal sessions
setopt hist_ignore_space					# Ignore history entries beginning with a space (for private commands)
setopt hist_ignore_all_dups				# Remove all duplicates from history file
setopt hist_save_no_dups					# Prevent duplicate history entries in history file
setopt hist_ignore_dups						# Ignore consecutive duplicates in current session
setopt hist_find_no_dups					# Prevent duplicates when searching history
setopt hist_verify								# Show command with history expansion to user before running it

# Additional ZSH options
setopt auto_cd						# Change to a directory just by typing its name (no 'cd' required)
setopt extended_glob			# Use extended globbing syntax
setopt no_case_glob				# Case insensitive globbing
setopt numeric_glob_sort	# Sort filenames numerically when it makes sense
setopt auto_pushd					# Make cd push the old directory onto the directory stack
setopt pushd_ignore_dups	# Don't push multiple copies of the same directory onto the directory stack
setopt prompt_subst				# Enable parameter expansion, command substitution, and arithmetic expansion in the prompt

# Keybindings
bindkey '^[[A' history-search-backward	# Up arrow for history search
bindkey '^[[B' history-search-forward		# Down arrow for history search
bindkey '^[[H' beginning-of-line				# Home key goes to beginning of line
bindkey '^[[F' end-of-line							# End key goes to end of line

# Initialise 'compinit' for autocompletion
autoload -Uz compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'							# Case-insensitive matching
zstyle ':completion:*' menu select																	# Select completions with arrow keys
zstyle ':completion:*' special-dirs true														# Complete special directories like . and ..
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"							# Colored completion based on LS_COLORS
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'	# Show directory contents for 'cd' completion

# Load aliases
if [[ -f "$ZDOTDIR/aliases.zsh" ]]; then
	source "$ZDOTDIR/aliases.zsh"
fi

# Load functions
if [[ -f "$ZDOTDIR/functions.zsh" ]]; then
	source "$ZDOTDIR/functions.zsh"
fi

# Use 'bat' for colourised man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Load local configuration if it exists
if [[ -f "$ZDOTDIR/.zshrc.local" ]]; then
	source "$ZDOTDIR/.zshrc.local"
fi
