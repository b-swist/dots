# ~/.bashrc

# common functions
__is_installed() {
	local cmd
	for cmd in "$@"; do
		command -v -- "$cmd" >/dev/null || return 1
	done
	return 0
}
__has_completion() { complete -p -- "$@" >/dev/null 2>&1; }

__get_distro() {
	local distro
	[ ! -f /etc/os-release ] && return
	distro="$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d \'\")"
	[ -z "$distro" ] && return
	echo "$distro"
}

distro="$(__get_distro)"

# xdg base dir
declare -A xdg
xdg=(
	["XDG_CONFIG_HOME"]="${HOME}/.config"
	["XDG_CACHE_HOME"]="${HOME}/.cache"
	["XDG_DATA_HOME"]="${HOME}/.local/share"
	["XDG_STATE_HOME"]="${HOME}/.local/state"
	["XDG_BIN_HOME"]="${HOME}/.local/bin" # note: not present in the spec
)

for env in "${!xdg[@]}"; do
	d="${xdg[$env]}"
	[ ! -d "$d" ] && mkdir -p -- "$d"
	export "$env"="$d"
done
unset xdg env d

# env vars

## rust
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
## go
export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
## python
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
## js
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node_repl_history"
## elm
export ELM_HOME="${XDG_CONFIG_HOME}/elm"
## java
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java""
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"

## wayland
export ELECTRON_OZONE_PLATFORM_HINT=auto
if [ -n "$WAYLAND_DISPLAY" ]; then
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM="wayland;xcb"
fi

## x11
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export XCURSOR_PATH="${XCURSOR_PATH:+$XCURSOR_PATH:}${XDG_DATA_HOME}/icons"

## configs
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
export LESS="-FiMqRWX -x4 -z3"

## general
export EDITOR=nvim
export VISUAL="$EDITOR"
export BROWSER=firefox
export PAGER=less

# path
path=(
	"/usr/local/bin"
	"${XDG_BIN_HOME}"
	"${XDG_BIN_HOME}/${distro}"
	"${XDG_DATA_HOME}/npm/bin"
	"${GOPATH}/bin"
)

__append_path() {
	local dir="${1%/}"
	case ":$PATH:" in
	*:"$dir":*) ;;
	*) PATH="${PATH:+$PATH:}$dir" ;;
	esac
}

for d in "${path[@]}"; do
	__append_path "$d"
done
unset path _appendpath d

[[ $- != *i* ]] && return

set -o noclobber
shopt -s autocd
shopt -s cdspell

shopt -s extglob
shopt -s dotglob
shopt -s globstar

__is_installed fzf && eval "$(fzf --bash)"
__is_installed atuin && eval "$(atuin init bash)"

if __is_installed doas; then
	alias doedit='doas ${EDITOR:-vi}'
	__has_completion doas || complete -cf doas

	if [ "$distro" = void ]; then
		for cmd in poweroff reboot zzz ZZZ; do
			# shellcheck disable=SC2139
			alias "$cmd"="doas /usr/bin/${cmd}"
		done
		unset cmd
	fi
fi

__is_installed sudo && ! __has_completion sudo && complete -cf sudo

# prompt
if [[ -f /usr/share/git/git-prompt.sh ]]; then
	source /usr/share/git/git-prompt.sh
	_has_git_prompt=1
else
	_has_git_prompt=0
fi

__set_color() {
	if [ "$1" -ge 0 ] 2>/dev/null && [ "$1" -le 255 ]; then
		printf '\001%s\002' "$(tput setaf "$1")"
	elif [ "$1" = "reset" ]; then
		printf "\001%s\002" "$(tput sgr0)"
	fi
}

## TODO: make these settings work better
# export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWSTASHSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=1

declare -A _c=(
	[RESET]="$(__set_color reset)"
	[RED]="$(__set_color 1)"
	[GREEN]="$(__set_color 2)"
	[YELLOW]="$(__set_color 3)"
	[BLUE]="$(__set_color 4)"
	[MAGENTA]="$(__set_color 5)"
	[CYAN]="$(__set_color 6)"
	[GRAY]="$(__set_color 7)"
)

__get_jobs() {
	local -i n
	n=$(jobs -p | wc -l)
	[ $n -gt 0 ] && echo $n
}

__git_prompt_cmd() {
	local default branch action
	default="$(__git_ps1 '%s')"

	local regex='(.*)\|([A-Z\ -]+)$'
	if [[ "$default" =~ $regex ]]; then
		branch="${BASH_REMATCH[1]}"
		action="${BASH_REMATCH[2],,}"
	elif [ "$default" ]; then
		branch="$default"
		action=""
	else
		return
	fi

	local prompt=" on ${_c[GREEN]}($branch)${_c[RESET]}"
	[ "$action" ] && prompt+=" doing ${_c[YELLOW]}<$action>${_c[RESET]}"

	echo "$prompt"
}

__prompt_cmd() {
	local return=$?
	[ $return -ne 0 ] && _symbol="${_c[RED]}>${_c[RESET]}" || _symbol=">"

	_jobs=$(__get_jobs)
	[ $_jobs ] && _jobs="${_c[GRAY]}[$(__get_jobs)]${_c[RESET]} "

	[ $_has_git_prompt ] && _git_prompt="$(__git_prompt_cmd)"
}

PROMPT_COMMAND=__prompt_cmd
__is_installed direnv && eval "$(direnv hook bash)"

PS1="\$_jobs${_c[MAGENTA]}\u${_c[RESET]} at ${_c[BLUE]}\h${_c[RESET]} in ${_c[CYAN]}[\w]${_c[RESET]}\$_git_prompt\n\$_symbol "

export PS1 PROMPT_COMMAND

# history
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="l[sl]:pwd:exit:[bf]g:history:.."
export HISTSIZE=-1
export HISTFILESIZE="$HISTSIZE"
export HISTTIMEFORMAT="%F %T  "

set_histfile() {
	local HISTDIR="${XDG_STATE_HOME}/bash"
	if [ ! -d "$HISTDIR" ]; then
		mkdir -p -- "$HISTDIR" || echo "Failed to create history directory"
	fi
	export HISTFILE="${HISTDIR}/history"
}
set_histfile
unset -f set_histfile

# aliases
alias rd="rmdir"
alias cp="cp -iv"
alias mv="mv -iv"
alias ..="cd .."
alias ...="cd ../.."
alias ls="ls -Fv --color=auto"
# shellcheck disable=SC2139
alias wget="wget --hsts-file=\"${XDG_CACHE_HOME}/wget-hsts\""

__is_installed grim slurp magick && alias pick='grim -g "$(slurp -p)" -t ppm - | magick - -format "%[pixel:p{0,0}]" txt:-'

[ "$(type -t ll)" = "alias" ] && unalias ll
ll() {
	command ls -Ahlv --color=always --group-directories-first --time-style=long-iso "$@" | $PAGER
}

rungui() {
	if [ $# -eq 0 ]; then
		echo "No parameter provided"
		return 1
	fi
	(nohup -- "$@" &>/dev/null &) && exit
}
__has_completion rungui || complete -cf rungui
[ -n "$WAYLAND_DISPLAY" ] && alias spotify="rungui spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"

unset distro __has_completion __is_installed
