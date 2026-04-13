#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$BACKUP_ROOT/$STAMP"

mkdir -p "$CONFIG_HOME"

backup_if_needed() {
  local target="$1"

  if [[ -L "$target" ]]; then
    local resolved
    resolved="$(readlink -f "$target")"
    if [[ "$resolved" == "$REPO_ROOT"* ]]; then
      return
    fi
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
    echo "Backed up $target -> $BACKUP_DIR/"
  fi
}

link_file() {
  local source="$1"
  local target="$2"

  backup_if_needed "$target"
  mkdir -p "$(dirname "$target")"
  ln -sfn "$source" "$target"
  echo "Linked $target -> $source"
}

link_file "$REPO_ROOT/.config/nvim" "$CONFIG_HOME/nvim"
link_file "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
link_file "$REPO_ROOT/.tmux.conf" "$HOME/.tmux.conf"

echo "Dotfiles linked from $REPO_ROOT"
