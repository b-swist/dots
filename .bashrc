# ~/.bashrc

export PATH="${PATH}:${HOME}/.local/bin"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"

[[ -z "$WAYLAND_DISPLAY" ]] && export MOZ_ENABLE_WAYLAND=1
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

export EDITOR=nvim
export VISUAL="$EDITOR"
export PAGER=less

export LESS="-FiMRWX -x4"

[[ $- != *i* ]] && return

set -o noclobber
shopt -s autocd
shopt -s cdspell

shopt -s extglob
shopt -s dotglob
shopt -s globstar

[[ "$(type -P fzf)" ]] && eval "$(fzf --bash)"
# eval "$(dircolors)"

if [[ "$(type -P doas)" ]]; then
    alias doedit="doas \$EDITOR"
    [[ -z "$(complete -p doas 2> /dev/null)" ]] && complete -cf doas
fi

if [[ -f /usr/share/git/git-prompt.sh ]]; then
    source /usr/share/git/git-prompt.sh
    export PS1="\$([[ \j -ne 0 ]] && echo '[\j] ')\w\$(__git_ps1 ' => %s') \$ "
else
    export PS1="\$([[ \j -ne 0 ]] && echo '[\j] ')\w \$ "
fi

shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="l[sl]:pwd:exit:[bf]g:history"
export HISTSIZE=10000
export HISTFILESIZE="$HISTSIZE"
export HISTTIMEFORMAT="%F %T  "

set_histfile() {
    local HISTDIR="${XDG_STATE_HOME}/bash"
    mkdir -p "$HISTDIR"
    export HISTFILE="${HISTDIR}/history"
}
set_histfile
unset -f set_histfile

alias rd="rmdir"
alias cp="cp -iv"
alias mv="mv -iv"
alias ..="cd .."
alias ...="cd ../.."
alias ls="ls -Fv --color=auto"
function ll {
    command ls -C "$@" -Ahlv --color=always --group-directories-first --time-style=long-iso | "$PAGER"
}
