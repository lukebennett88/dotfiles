#!/bin/bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

info "Setting up 1Password for Git..."

# -- 1. SSH config for 1Password agent ----------------------------------------

SSH_CONFIG="$HOME/.ssh/config"
mkdir -p "$HOME/.ssh"

if grep -q "IdentityAgent.*1password" "$SSH_CONFIG" 2>/dev/null; then
	success "SSH config already has 1Password configuration."
else
	{
		echo ""
		echo "# 1Password SSH Agent"
		echo "Host *"
		echo '  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'
	} >> "$SSH_CONFIG"
	chmod 600 "$SSH_CONFIG"
	success "Added 1Password SSH agent to ~/.ssh/config."
fi

# -- 2. Git signing (requires 1Password CLI and signed in) --------------------

if ! command_exists op || ! op account list >/dev/null 2>&1; then
	warn "1Password CLI not available or not signed in. Git signing setup skipped."
	warn "Install with: brew install --cask 1password/tap/1password-cli"
	exit 0
fi

info "Setting up Git commit signing..."

if SSH_KEY=$(op item get "GitHub key" --fields "public key" 2>/dev/null); then
	cat > "$HOME/.gitconfig-1password-ssh" <<EOF
[user]
  signingkey = $SSH_KEY

[gpg]
  format = ssh

[gpg "ssh"]
  program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign

[commit]
  gpgsign = true
EOF
	success "Created ~/.gitconfig-1password-ssh."
else
	warn "Could not get SSH key from 1Password. Git signing setup skipped."
	warn "Make sure you have an SSH key item named 'GitHub key' in 1Password."
fi

success "1Password setup complete."
info "Test SSH authentication: ssh -T git@github.com"
info "Test Git signing: git commit --allow-empty -m 'test' -S"
