#!/bin/bash
set -euo pipefail

source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

info "Setting up skills..."

if ! command_exists mise; then
	warn "mise not found. Skipping skills setup."
	warn "Run this later after opening a new shell: pnpm dlx skills experimental_install"
	exit 0
fi

# Activate mise so runtimes (node, pnpm) are available in this script
eval "$(mise activate bash)"
eval "$(mise hook-env)"

info "Installing mise runtimes..."
mise install

if ! command_exists node; then
	warn "Node.js not available via mise. Skipping skills setup."
	warn "Run this later after opening a new shell: pnpm dlx skills experimental_install"
	exit 0
fi

# Prepare pnpm via corepack (no global package manager install needed)
if ! command_exists pnpm; then
	info "Preparing pnpm via corepack..."
	# Don't let a transient corepack failure abort the whole orchestrator —
	# fall through to the `command_exists pnpm` check below.
	corepack prepare pnpm@latest --activate || warn "corepack prepare failed."
	eval "$(mise hook-env)" || true
fi

if ! command_exists pnpm; then
	warn "pnpm not available via corepack. Skipping skills setup."
	warn "Run this later after opening a new shell: pnpm dlx skills experimental_install"
	exit 0
fi

info "Restoring skills from lockfile..."
pnpm dlx skills experimental_install || warn "Skills restoration may have failed or was skipped."
success "Skills setup complete."
