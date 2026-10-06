# Interactive shell configuration

# ZDOTDIR is set in .zshenv.

# Initialise Starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# Shell integrations
command -v mise >/dev/null && eval "$(mise activate zsh)"
command -v fzf >/dev/null && eval "$(fzf --zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"

# History settings
HISTSIZE=10000
HISTFILE="$ZDOTDIR/.zsh_history"
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_verify

# Additional ZSH options
setopt auto_cd
setopt extended_glob
setopt no_case_glob
setopt numeric_glob_sort
setopt auto_pushd
setopt pushd_ignore_dups
setopt prompt_subst

# Keybindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Load Homebrew completions and plugins. Syntax highlighting loads last.
if [[ -f "$ZDOTDIR/plugins.zsh" ]]; then
	source "$ZDOTDIR/plugins.zsh"
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':completion:*' special-dirs true
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

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

# Disable GitHub CLI telemetry
export GH_TELEMETRY=false
export DO_NOT_TRACK=true

# Load machine-specific configuration if it exists (gitignored).
if [[ -f "$ZDOTDIR/.zshrc.local" ]]; then
	source "$ZDOTDIR/.zshrc.local"
fi

# Syntax highlighting wraps ZLE widgets, so load it after other integrations.
[[ -f "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
	source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
