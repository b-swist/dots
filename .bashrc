# ~/.bashrc

export PATH="$PATH:$HOME/.local/bin"

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

[[ $- != *i* ]] && return

export EDITOR=nvim
export VISUAL="$EDITOR"
export PAGER=less

export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export MOZ_ENABLE_WAYLAND=1
export LESS="-FiMRWX -x4"

shopt -s autocd
shopt -s cdspell

shopt -s extglob
shopt -s dotglob
shopt -s globstar

eval "$(fzf --bash)"
eval "$(dircolors)"

complete -F _command doas
alias doedit="doas $EDITOR"

source /usr/share/git/git-prompt.sh
export PS1="\$([[ \j -ne 0 ]] && echo '[\j] ')\w\$(__git_ps1 ' => %s') \$ "

shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="l[sl]:pwd:exit:[bf]g:history"
export HISTSIZE=10000
export HISTFILESIZE="$HISTSIZE"
export HISTTIMEFORMAT="%F %T  "

HISTDIR="$XDG_STATE_HOME"/bash
export HISTFILE="$HISTDIR"/history
mkdir -p "$HISTDIR"

alias rd="rmdir"
alias ..="cd .."
alias ...="cd ../.."
alias ls="ls -Fv --color=auto"
function ll {
    command ls -C "$@" -Ahlv --color=always --group-directories-first --time-style=long-iso | "$PAGER"
}
