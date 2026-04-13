# Dotfiles

Personal dotfiles for Neovim, zsh, and tmux.

## Layout

- `.config/nvim`: Neovim config
- `.zshrc`: zsh config
- `.tmux.conf`: tmux config
- `bootstrap.sh`: links the repo into `$HOME`

## Install

```bash
git clone https://github.com/lu-ren/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` will back up existing conflicting files into `~/.dotfiles-backup/<timestamp>/`.

## Dependencies

- `neovim` 0.12+
- `tmux`
- `zsh`
- `git`
- `node` and `npm`
- `gcc`, `cc`, `make`
- `tree-sitter`
- `ripgrep`
- `fd`
- `fzf`

## Notes

- The Neovim config uses `lazy.nvim`, Mason, LSP, Telescope, Treesitter, and modern Lua plugins.
- Language servers are installed per-user through Mason.
- Treesitter parsers compile locally, so the build tools above matter.
