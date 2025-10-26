# ~/.bashrc

export PATH="${PATH}:/usr/local/bin:${HOME}/.local/bin"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
alias wget="wget --hsts-file="${XDG_CACHE_HOME}/wget-hsts""

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java""
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node_repl_history"

export ELECTRON_OZONE_PLATFORM_HINT=auto
if [[ -n "$WAYLAND_DISPLAY" ]]; then
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM="wayland;xcb"
fi

export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"

export XCURSOR_PATH="${XCURSOR_PATH}:${XDG_DATA_HOME}/icons"

export EDITOR=nvim
export VISUAL="$EDITOR"
export BROWSER=firefox
export PAGER=less

export LESS="-FiMqRWX -x4 -z3"

[[ $- != *i* ]] && return

is_installed() { type -P "$@"; }
has_completion() { complete -p "$@" 2>/dev/null; }

get_distro() {
	local distro
	[[ ! -f /etc/os-release ]] && return 1
	distro="$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d \'\")"
	echo "$distro"
}

set -o noclobber
shopt -s autocd
shopt -s cdspell

shopt -s extglob
shopt -s dotglob
shopt -s globstar

[[ "$(is_installed fzf)" ]] && eval "$(fzf --bash)"
[[ "$(is_installed atuin)" ]] && eval "$(atuin init --disable-up-arrow bash)"

if [[ "$(is_installed doas)" ]]; then
	alias doedit='doas $EDITOR'
	[[ "$(has_completion doas)" ]] || complete -cf doas

	if [[ "$(get_distro)" == void ]]; then
		for cmd in poweroff reboot zzz ZZZ; do
			# shellcheck disable=SC2139
			alias "$cmd"="doas /usr/bin/${cmd}"
		done
		unset cmd
	fi
fi

[[ "$(is_installed sudo)" ]] && [[ ! "$(has_completion sudo)" ]] && complete -cf sudo

if [[ -f /usr/share/git/git-prompt.sh ]]; then
	source /usr/share/git/git-prompt.sh
	export PS1='$([[ \j -ne 0 ]] && echo "[\j] ")\w$(__git_ps1 " => %s") \$ '
else
	export PS1='$([[ \j -ne 0 ]] && echo "[\j] ")\w \$ '
fi

shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="l[sl]:pwd:exit:[bf]g:history:.."
export HISTSIZE=-1
export HISTFILESIZE="$HISTSIZE"
export HISTTIMEFORMAT="%F %T  "

set_histfile() {
	local HISTDIR="${XDG_STATE_HOME}/bash"
	if [[ ! -d "$HISTDIR" ]]; then
		mkdir -p "$HISTDIR" || echo "Failed to create history directory"
	fi
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

[[ "$(type -t ll)" == "alias" ]] && unalias ll
ll() {
	command ls -C "$@" -Ahlv --color=always --group-directories-first --time-style=long-iso | $PAGER
}

rungui() {
	if [[ $# -eq 0 ]]; then
		echo "No parameter provided"
		return 1
	fi
	(nohup "$@" &>/dev/null &) && exit
}
[[ "$(has_completion rungui)" ]] || complete -cf rungui
[[ -n "$WAYLAND_DISPLAY" ]] && alias spotify="rungui spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"

unset -f has_completion is_installed
