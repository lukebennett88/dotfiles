#!/bin/bash

# Minimal 1Password Git setup
# Adds SSH config and Git signing configuration

set -e

echo "🔐 Setting up 1Password for Git..."

# 1. Setup SSH config for 1Password agent
SSH_CONFIG="$HOME/.ssh/config"
mkdir -p "$HOME/.ssh"

if ! grep -q "IdentityAgent.*1password" "$SSH_CONFIG" 2>/dev/null; then
    echo "" >> "$SSH_CONFIG"
    echo "# 1Password SSH Agent" >> "$SSH_CONFIG"
    echo "Host *" >> "$SSH_CONFIG"
    echo '  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"' >> "$SSH_CONFIG"
    chmod 600 "$SSH_CONFIG"
    echo "✓ Added 1Password SSH agent to ~/.ssh/config"
else
    echo "✓ SSH config already has 1Password configuration"
fi

# 2. Setup Git signing (requires 1Password CLI and signed in)
if command -v op >/dev/null 2>&1 && op account list >/dev/null 2>&1; then
    echo "📝 Setting up Git commit signing..."

    # Get SSH public key from 1Password (customize "GitHub key" to your item name)
    if SSH_KEY=$(op item get "GitHub key" --fields "public key" 2>/dev/null); then
        cat > "$HOME/.gitconfig-1password-ssh" << EOF
[user]
  signingkey = $SSH_KEY

[gpg]
  format = ssh

[gpg "ssh"]
  program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
EOF
        echo "✓ Created ~/.gitconfig-1password-ssh"
    else
        echo "⚠️  Could not get SSH key from 1Password. Git signing setup skipped."
        echo "   Make sure you have an SSH key item named 'GitHub key' in 1Password"
    fi
else
    echo "⚠️  1Password CLI not available or not signed in. Git signing setup skipped."
    echo "   Install with: brew install --cask 1password/tap/1password-cli"
fi

echo "✅ 1Password setup complete!"
echo ""
echo "Test SSH authentication: ssh -T git@github.com"
echo "Test Git signing: git commit --allow-empty -m 'test' -S"
