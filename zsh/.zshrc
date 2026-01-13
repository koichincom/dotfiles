# If not running interactively, don't do anything
[[ ! -o interactive ]] && return

# Enable zsh completion system
autoload -Uz compinit
compinit

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

alias light='gsettings set org.gnome.desktop.interface color-scheme "prefer-light"'
alias dark='gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"'

alias n='nvim .'
alias nv='nvim'
alias o='opencode'
alias g='git'
alias p="cd ~/Projects"
alias zigdev="$HOME/.local/share/zig-x86_64-linux-0.16.0-dev.1859+212968c57/zig"

# Custom prompt (adapted from bash PS1='[\u@\h \W]\$ ')
PROMPT='[%n@%m %1~]$ '

# Environment variables
export EDITOR='nvim'
export PATH=/home/koichi/.opencode/bin:$PATH

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Fcitx5
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Source local environment (if exists)
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Load zsh plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
