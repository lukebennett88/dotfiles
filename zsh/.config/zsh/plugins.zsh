# Homebrew completions and Zsh plugins.
# Apple Silicon only — same prefix as .zprofile / setup.sh.
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

if [[ -d "$HOMEBREW_PREFIX/opt/zsh-completions/share/zsh-completions" ]]; then
	fpath=("$HOMEBREW_PREFIX/opt/zsh-completions/share/zsh-completions" $fpath)
fi

autoload -Uz compinit
compinit

if command -v pnpm >/dev/null 2>&1; then
	eval "$(pnpm completion zsh)"
fi

[[ -f "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]] &&
	source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"

[[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
	source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
