# ~/.bashrc

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

[[ $- != *i* ]] && return

export EDITOR=nvim
export VISUAL="$EDITOR"

shopt -s autocd
shopt -s cdspell

shopt -s extglob
shopt -s dotglob
shopt -s globstar

eval "$(fzf --bash)"
complete -cf doas

export PS1="\w \$ "

shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:ll:pwd:exit:fg"

HISTDIR="$XDG_STATE_HOME"/bash
export HISTFILE="$HISTDIR"/history
mkdir -p "$HISTDIR"

alias ls="ls --color=auto"
alias ll="ls -lAh --color=auto --group-directories-first"
