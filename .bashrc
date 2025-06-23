# ~/.bashrc

export XDG_CONFIG_DIR="$HOME/.config"
export XDG_CACHE_DIR="$HOME/.cache"
export XDG_DATA_DIR="$HOME/.local/share"
export XDG_STATE_DIR="$HOME/.local/state"

[[ $- != *i* ]] && return

export EDITOR=nvim
export VISUAL=$EDITOR

shopt -s autocd
shopt -s cdspell
shopt -s extglob
shopt -s globstar

eval "$(fzf --bash)"
complete -cf doas

export PS1="\w \$ "

shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=ls

HISTDIR="$XDG_STATE_DIR/bash"
export HISTFILE="$HISTDIR/history"
mkdir -p $HISTDIR

alias ls="ls --color=auto"
alias ll="ls -lAh --color=auto --group-directories-first"
