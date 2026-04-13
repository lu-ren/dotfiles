#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config"

ln -sfn "$REPO_ROOT/nvim/.config/nvim" "$HOME/.config/nvim"
ln -sfn "$REPO_ROOT/shell/.zshrc" "$HOME/.zshrc"
ln -sfn "$REPO_ROOT/shell/.tmux.conf" "$HOME/.tmux.conf"

echo "Linked Neovim, zsh, and tmux dotfiles from $REPO_ROOT"
