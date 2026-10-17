__is_installed() {
	local cmd
	for cmd in "$@"; do
		command -v -- "$cmd" >/dev/null || return 1
	done
	return 0
}

__has_completion() {
	complete -p -- "$@" >/dev/null 2>&1
}

__get_distro() {
	local distro
	[ ! -f /etc/os-release ] && return
	distro="$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d \'\")"
	[ -z "$distro" ] && return
	echo "$distro"
}

__append_path() {
	local d="${1%/}"
	[[ ":$PATH:" != *:"$d":* ]] && PATH="${PATH:+$PATH:}$d"
}

distro="$(__get_distro)"

## xdg base dir
set_xdg() {
	declare -A xdg
	local xdg=(
		["XDG_CONFIG_HOME"]="${HOME}/.config"
		["XDG_CACHE_HOME"]="${HOME}/.cache"
		["XDG_DATA_HOME"]="${HOME}/.local/share"
		["XDG_STATE_HOME"]="${HOME}/.local/state"
		["XDG_BIN_HOME"]="${HOME}/.local/bin" # note: not present in the spec
	)

	local env
	for env in "${!xdg[@]}"; do
		local d="${xdg[$env]}"
		[ ! -d "$d" ] && mkdir -p -- "$d"
		export "$env"="$d"
	done
}
set_xdg
unset set_xdg

## env vars
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"

export GOPATH="${XDG_DATA_HOME}/go"
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"

export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"

export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node_repl_history"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_LOGS_DIR="${XDG_STATE_HOME}/npm/logs"
export NPM_CONFIG_INIT_MODULE="${XDG_CONFIG_HOME}/npm/config/npm-init.js"

export GHCUP_USE_XDG_DIRS=1
export OPAMROOT="${XDG_DATA_HOME}/opam"
export ELM_HOME="${XDG_CONFIG_HOME}/elm"
export PLTUSERHOME="${XDG_DATA_HOME}/racket"

# export _JAVA_OPTIONS="-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java""
export GRADLE_USER_HOME="${XDG_DATA_HOME}/gradle"

export ELECTRON_OZONE_PLATFORM_HINT=auto
if [ "$WAYLAND_DISPLAY" ]; then
	export MOZ_ENABLE_WAYLAND=1
	export QT_QPA_PLATFORM="wayland;xcb"
fi

export PLATFORMIO_CORE_DIR="${XDG_DATA_HOME}/platformio"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"

export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"

GPG_TTY="$(tty)"
export GPG_TTY

export XCURSOR_PATH="${XCURSOR_PATH:+$XCURSOR_PATH:}${XDG_DATA_HOME}/icons"

export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
export WGETRC="${XDG_CONFIG_HOME}/wgetrc"
[ ! -f "$WGETRC" ] && touch -- "$WGETRC"

export LESS="-FiMqRWX -x4 -z3"
export MOOR="--quit-if-one-screen --tab-size=4"

export GH_TELEMETRY=
export DO_NOT_TRACK=1

export EDITOR=nvim
export VISUAL="$EDITOR"
export BROWSER=firefox

__is_installed moor && PAGER=moor || PAGER=less
export PAGER

## path
set_path() {
	local extra_path d

	[ "$PATH" ] || PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

	extra_path=(
		"${XDG_BIN_HOME}"
		"${CARGO_HOME}/bin"
		"${NPM_CONFIG_PREFIX}/bin"
		"${GOPATH}/bin"
	)

	for d in "${extra_path[@]}"; do
		__append_path "$d"
	done

	export PATH
}
set_path
unset set_path

[[ $- != *i* ]] && return

unalias -a

set -o noclobber
shopt -s autocd
shopt -s cdspell

shopt -s extglob
shopt -s dotglob
shopt -s globstar

__is_installed fzf && eval "$(fzf --bash)"
# __is_installed atuin && eval "$(atuin init --disable-up-arrow bash)"
__is_installed star && eval "$(command star init bash)"

if __is_installed doas; then
	__is_installed doasedit || alias doasedit='doas ${EDITOR:-vi}'
fi

case "$distro" in
arch)
	alias zzz="systemctl suspend"
	;;
void)
	__is_installed doas && for cmd in poweroff reboot zzz ZZZ; do
		# shellcheck disable=SC2139
		alias "$cmd"="doas /usr/bin/${cmd}"
	done
	unset cmd
	;;
esac

__esc() {
	printf "\001%s\002" "$1"
}

__set_color() {
	__esc "$(tput setaf "$1")"
}

declare -A _c=(
	[RESET]="$(__esc "$(tput sgr0)")"
	[BOLD]="$(__esc "$(tput bold)")"
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

__jobs_prompt() {
	local jobs
	jobs=$(__get_jobs)
	[ -z "$jobs" ] && return
	echo "${_c[BOLD]}${_c[GRAY]}[$jobs]${_c[RESET]} "
}

__git_branch_prompt() {
	local branch
	branch="$(git branch --show-current 2>/dev/null)"
	[ -z "$branch" ] && return

	local prompt=" on ${_c[GREEN]}($branch)${_c[RESET]}"
	# [ "$action" ] && prompt+=" doing ${_c[YELLOW]}<$action>${_c[RESET]}"

	echo "$prompt"
}

__symbol_prompt() {
	local ret symbol
	ret="$1"
	symbol=">"
	if [ "$ret" -ne 0 ]; then
		echo "${_c[RED]}${symbol}${_c[RESET]}"
	else
		echo "$symbol"
	fi
}

__prompt_cmd() {
	local return=$?
	_symbol="$(__symbol_prompt "$return")"
	_git_prompt="$(__git_branch_prompt)"
	_jobs="$(__jobs_prompt)"
}

PROMPT_COMMAND=__prompt_cmd
__is_installed direnv && eval "$(direnv hook bash)"

PS1="\$_jobs${_c[MAGENTA]}\u${_c[RESET]} at ${_c[BLUE]}\h${_c[RESET]} in ${_c[CYAN]}[\w]${_c[RESET]}\$_git_prompt\n\$_symbol "

export PS1 PROMPT_COMMAND

## history
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

## functions
__is_installed tree && tree() {
	command tree -C "$@" | "$PAGER"
}

__is_installed lstr && lstr() {
	command lstr -G --icons --color=always "$@" | "$PAGER"
}

ll() {
	command ls -Ahlv --color=always --group-directories-first --time-style=long-iso "$@" | "$PAGER"
}

__is_installed grim slurp magick && pico() {
	local px rgb hex fmt out

	px="$(slurp -p)" || return 1
	rgb="rgb(%[fx:int(255*r)],%[fx:int(255*g)],%[fx:int(255*b)])"
	hex="#%[hex:p]"

	fmt="$rgb\n$hex\n"
	out="$(grim -g "$px" -t ppm - | magick - -format "$fmt" info:)"
	echo "$out"
}

rungui() {
	if [ $# -eq 0 ]; then
		echo "No parameter provided"
		return 1
	fi
	(nohup -- "$@" &>/dev/null &) && exit
}

## aliases
alias rd="rmdir"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias ..="cd .."
alias ls="ls -Fv --color=auto"
__is_installed wget && alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
