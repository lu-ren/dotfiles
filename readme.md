# Dotfiles

Personal dotfiles for:

- Neovim
- zsh
- tmux

## Layout

- `nvim/.config/nvim`: Neovim config
- `shell/.zshrc`: zsh config
- `shell/.tmux.conf`: tmux config
- `bootstrap.sh`: creates the expected symlinks in `$HOME`

## Install

```bash
git clone https://github.com/lu-ren/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

## Notes

- Neovim config targets modern Neovim `0.12+`
- Language servers are managed locally through Mason inside Neovim
