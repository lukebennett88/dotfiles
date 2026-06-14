#!/bin/bash

# Shared helpers for dotfiles scripts. Source this file at the top of any
# script that needs logging, colour output, or command-existence checks:
#
#   source "$(dirname "$0")/lib.sh"
#
# Or, from setup.sh:
#
#   source "$DOTFILES/scripts/lib.sh"

# Guard against double-sourcing
if [ -n "${__DOTFILES_LIB_LOADED:-}" ]; then
	return 0
fi
__DOTFILES_LIB_LOADED=1

# -- Colours -------------------------------------------------------------------

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# -- Logging -------------------------------------------------------------------

info()    { printf "${BLUE}➜ %s${NC}\n" "$*"; }
success() { printf "${GREEN}✓ %s${NC}\n" "$*"; }
error()   { printf "${RED}✗ %s${NC}\n" "$*" >&2; }
warn()    { printf "${YELLOW}! %s${NC}\n" "$*"; }

step() { printf "\n${BLUE}▸ %s${NC}\n" "$*"; }

# -- Helpers -------------------------------------------------------------------

command_exists() { command -v "$1" >/dev/null 2>&1; }

# Ask a yes/no question. Returns 0 for yes, 1 for no. Enter accepts the
# default (yes), so a fresh-machine run can breeze through by hitting return.
#   confirm "Apply macOS defaults?" && do_thing
confirm() {
	local reply
	read -r -p "$(printf "${YELLOW}? %s [Y/n] ${NC}" "$1")" reply
	[[ -z "$reply" || "$reply" =~ ^[Yy] ]]
}

# Run an optional phase behind a confirm prompt. On decline, print the skip
# hint (if given) so the user knows how to run it later.
#   optional_phase "Stow symlinks?" "$DOTFILES/scripts/install-stow.sh" \
#       "Skipping stow. Run later: ~/.dotfiles/scripts/install-stow.sh"
optional_phase() {
	local prompt="$1" script="$2" hint="${3:-}"
	if confirm "$prompt"; then
		"$script"
	elif [ -n "$hint" ]; then
		info "$hint"
	fi
}

# Resolve the dotfiles root from any script that lives under scripts/
dotfiles_root() {
	local script_dir
	script_dir="$(cd "$(dirname "${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}")" && pwd)"
	# If we're inside scripts/, go up one level
	if [[ "$(basename "$script_dir")" == "scripts" ]]; then
		dirname "$script_dir"
	else
		echo "$script_dir"
	fi
}
