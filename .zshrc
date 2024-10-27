# .zshrc

# Check if Homebrew is installed, if not, install it
if ! command -v brew &> /dev/null; then
	echo "Homebrew not found, installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Detect architecture and set Homebrew path
if [[ $(uname -m) == 'arm64' ]]; then
	# M1/M2 Mac
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	# Intel Mac
	eval "$(/usr/local/bin/brew shellenv)"
fi

# Initialize oh-my-posh prompt
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"

# Set the directory we want to store Zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install Zinit if it's not already there
if [ ! -d "$ZINIT_HOME" ]; then
	echo "Zinit not found, installing..."
	mkdir -p "$(dirname "$ZINIT_HOME")"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Shell integrations
eval "$(mise hook-env -s zsh)"
eval "$(mise activate zsh)"					# Activate mise-en-place (node version manager)
eval "$(fzf --zsh)"									# Enable fzf keybindings
eval "$(zoxide init --cmd cd zsh)"	# Enable zoxide shell integration (replacing 'cd')

# Zinit plugins
zinit ice wait lucid; zinit light Aloxaf/fzf-tab																# Replace zsh's default completion selection menu with fzf
zinit ice wait lucid; zinit light grigorii-zander/zsh-npm-scripts-autocomplete	# Autocomplete npm scripts
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions									# Autosuggestions based on history
zinit ice wait lucid; zinit light zsh-users/zsh-completions											# Additional completions
zinit ice wait lucid; zinit light zsh-users/zsh-syntax-highlighting							# Syntax highlighting

# Zinit snippets
zinit ice wait lucid; zinit snippet OMZP::git	# adds aliases and functions for git
zinit ice wait lucid; zinit snippet OMZP::gh	# adds completion for the GitHub CLI

# History settings
HISTSIZE=5000								# Maximum number of history entries stored in memory (commands per session)
HISTFILE=~/.zsh_history			# File where history is saved across sessions
SAVEHIST=$HISTSIZE					# Save the same number of history entries to file as the HISTSIZE
HISTDUP=erase								# Erase older duplicate commands when a new one is added (keeps only the latest)
setopt appendhistory				# Append history to the history file, rather than overwriting it, when a shell exits
setopt sharehistory					# Share history across all open terminal sessions
setopt hist_ignore_space		# Ignore commands that begin with a space (useful for private commands)
setopt hist_ignore_all_dups	# Remove all older duplicates from the entire history file
setopt hist_save_no_dups		# Avoid saving duplicates of the same command (only keeps the latest in memory)
setopt hist_ignore_dups			# Ignore consecutive duplicate commands in the current session
setopt hist_find_no_dups		# Prevent showing duplicates when searching for a command in history

# Keybindings
bindkey '^[[A' history-search-backward	# Up arrow for history search
bindkey '^[[B' history-search-forward		# Down arrow for history search

# Completion styling
autoload -Uz compinit && compinit																		# Ensure compinit is loaded and initialized
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'							# Case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"							# Use 'ls' colors for completion list
zstyle ':completion:*' menu no																			# Enable fzf completion menu instead of zsh's default
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'	# Preview directory contents when completing 'cd'

# Aliases
alias ..='cd ..'
alias c='clear'
alias ls='ls --color'
