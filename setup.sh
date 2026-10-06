#!/bin/bash
set -euo pipefail

if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
	printf 'This setup targets macOS on Apple Silicon.\n' >&2
	exit 1
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -x /opt/homebrew/bin/brew ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v just >/dev/null 2>&1; then
	brew install just
fi

exec just --justfile "$DOTFILES/justfile" bootstrap
