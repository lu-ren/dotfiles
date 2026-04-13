# Interactive shell guard
[[ -o interactive ]] || return

autoload -Uz compinit colors vcs_info

typeset -U path fpath

path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.pyenv/bin"
  "$HOME/.fzf/bin"
  $path
)

export PATH
export ZDOTDIR="${ZDOTDIR:-$HOME}"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less -FR"
export LESSHISTFILE=-
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

mkdir -p "${HISTFILE:h}" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
colors

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

bindkey -v

source_if_exists() {
  local file="$1"
  [[ -r "$file" ]] && source "$file"
}

PLUGIN_ROOTS=(
  "$HOME/.antigen/bundles"
  "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
)

plugin_file() {
  local relative="$1"
  local root
  for root in "${PLUGIN_ROOTS[@]}"; do
    [[ -r "$root/$relative" ]] && print -r -- "$root/$relative" && return 0
  done
  return 1
}

source_plugin() {
  local relative="$1"
  local file
  file="$(plugin_file "$relative")" || return 0
  source "$file"
}

source_plugin "robbyrussell/oh-my-zsh/lib/git.zsh"
source_plugin "robbyrussell/oh-my-zsh/plugins/git/git.plugin.zsh"
source_plugin "robbyrussell/oh-my-zsh/plugins/pip/pip.plugin.zsh"
source_plugin "robbyrussell/oh-my-zsh/plugins/command-not-found/command-not-found.plugin.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
ZVM_CURSOR_STYLE_ENABLED=true

if [[ -t 0 && -t 1 ]]; then
  source_plugin "zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
  source_plugin "jeffreytse/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

source_if_exists "$HOME/.fzf.zsh"

if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

if [[ -d "$HOME/.pyenv" ]] && (( $+commands[pyenv] )); then
  eval "$(pyenv init - zsh)"
  if [[ -d "$HOME/.pyenv/plugins/pyenv-virtualenv" ]]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  unset -f nvm node npm npx pnpm corepack yarn
  source_if_exists "$NVM_DIR/nvm.sh"
  source_if_exists "$NVM_DIR/bash_completion"
}

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  nvm() { lazy_load_nvm; nvm "$@"; }
  node() { lazy_load_nvm; command node "$@"; }
  npm() { lazy_load_nvm; command npm "$@"; }
  npx() { lazy_load_nvm; command npx "$@"; }
  pnpm() { lazy_load_nvm; command pnpm "$@"; }
  corepack() { lazy_load_nvm; command corepack "$@"; }
  yarn() { lazy_load_nvm; command yarn "$@"; }
fi

if (( ! $+commands[fd] && $+commands[fdfind] )); then
  alias fd='fdfind'
fi

alias nv='nvim'
alias v='nvim'
alias zel='zellij'
alias lg='lazygit'
alias xcopy='xsel --clipboard'
alias xpaste='xsel --output --clipboard'
alias idea='/home/ceres/Desktop/idea-IU-242.23339.11/bin/idea.sh >/dev/null 2>&1 &'

vv() {
  local finder file
  finder="${commands[fd]:-${commands[fdfind]}}"
  (( ${+commands[fzf]} )) || return 1
  [[ -n "$finder" ]] || return 1
  file="$("$finder" --type f --hidden --exclude .git 2>/dev/null | fzf)" || return 0
  [[ -n "$file" ]] && "$EDITOR" "$file"
}

mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

if [[ -t 0 && -t 1 ]]; then
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey '^e' edit-command-line
fi

zstyle ':vcs_info:git:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{244}[%b]%f'
zstyle ':vcs_info:git:*' actionformats ' %F{214}[%b|%a]%f'

precmd() {
  vcs_info
}

setopt PROMPT_SUBST
PROMPT='%F{39}%n@%m%f %F{76}%~%f${vcs_info_msg_0_} %(?.%f.%F{160}[%?]%f)
%# '

if [[ -t 0 && -t 1 ]]; then
  source_plugin "zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
