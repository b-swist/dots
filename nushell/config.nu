use std/dirs

$env.config = {
    show_banner: false
    history: {file_format: "sqlite"}
}

let path_conversions = {
    from_string: {|s|
        $s | split row (char esep) | compact -e
    }
    to_string: {|v|
        $v | str join (char esep)
    }
}

$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge (
  [PATH MANPATH XCURSOR_PATH]
  | each {|n| { $n: $path_conversions } }
  | reduce {|it, acc| $acc | merge $it }
)

## xdg
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local" "share")
$env.XDG_STATE_HOME = ($env.HOME | path join ".local" "state")
$env.XDG_BIN_HOME = ($env.HOME | path join ".local" "bin") # note: not present in the spec

## programming
$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join "cargo")
$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join "rustup")

$env.GOPATH = ($env.XDG_DATA_HOME | path join "go")
$env.GOMODCACHE = ($env.XDG_CACHE_HOME | path join "go" "mod")

$env.PYTHON_HISTORY = ($env.XDG_STATE_HOME | path join "python_history")
$env.PYTHONPYCACHEPREFIX = ($env.XDG_CACHE_HOME | path join "python")
$env.PYTHONUSERBASE = ($env.XDG_DATA_HOME | path join "python")

$env.NODE_REPL_HISTORY = ($env.XDG_STATE_HOME | path join "node_repl_history")
$env.NPM_CONFIG_USERCONFIG = ($env.XDG_CONFIG_HOME | path join "npm" "npmrc")
$env.NPM_CONFIG_PREFIX = ($env.XDG_DATA_HOME | path join "npm")
$env.NPM_CONFIG_CACHE = ($env.XDG_CACHE_HOME | path join "npm")
$env.NPM_CONFIG_INIT_MODULE = ($env.XDG_CONFIG_HOME | path join "npm" "npm-init.js")
$env.NPM_CONFIG_LOGS_DIR = ($env.XDG_STATE_HOME | path join "npm" "logs")

$env.OPAMROOT = ($env.XDG_DATA_HOME | path join "opam")

$env.ELM_HOME = ($env.XDG_CONFIG_HOME | path join "elm")

# $env._JAVA_OPTIONS = "-Djava.util.prefs.userRoot=" + ($env.XDG_CONFIG_HOME | path join "java")
$env.GRADLE_USER_HOME = ($env.XDG_DATA_HOME | path join "gradle")

$env.DOTNET_CLI_TELEMETRY_OPTOUT = 1

$env.PLATFORMIO_CORE_DIR = ($env.XDG_DATA_HOME | path join "platformio")

## wayland
$env.ELECTRON_OZONE_PLATFORM_HINT = "auto"
try {
    if (is-not-empty $env.WAYLAND_DISPLAY) {
        $env.MOZ_ENABLE_WAYLAND = 1
        $env.QT_QPA_PLATFORM = "wayland;xcb"
    }
}

## x11
$env.XINITRC = ($env.XDG_CONFIG_HOME | path join "X11" "xinitrc")
$env.XAUTHORITY = try {
    $env.XDG_RUNTIME_DIR | path join "Xauthority"
}

$env.XCURSOR_PATH = $env.XCURSOR_PATH? | default []
$env.XCURSOR_PATH ++= [
    ($env.XDG_DATA_HOME | path join "icons")
]

## config
$env.WGETRC = ($env.XDG_CONFIG_HOME | path join "wgetrc")
$env.LESS = "-FiMqRWX -x4 -z3"

$env.PAGER = "less"
$env.BROWSER = "firefox"
$env.EDITOR = "nvim"
$env.VISUAL = $env.EDITOR

## path
$env.PATH = $env.PATH? | default [
    "/usr/local/bin"
    "/usr/local/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/bin"
    "/sbin"
]
$env.PATH ++= [
    $env.XDG_BIN_HOME
    ($env.CARGO_HOME | path join "bin")
    ($env.NPM_CONFIG_PREFIX | path join "bin")
    ($env.GOPATH | path join "bin")
    ($env.HOME | path join ".dotnet")
    ($env.HOME | path join ".dotnet" "tools")
]
$env.PATH = $env.PATH | uniq

## aliases
alias ll = ls -a
alias fg = job unfreeze

# Wrapper around df command to print the result as a formatted table.
def df []: nothing -> table {
    ^df -h # TODO: make wrapped
    | str replace "Mounted on" "mountpoint"
    | detect columns
    | rename -b { str lowercase }
    | rename -c { avail: available }
    | into filesize size used available
}

def pico []: nothing -> table {
    let px = slurp -p | str trim
    let rgb = '%[fx:int(255*r)],%[fx:int(255*g)],%[fx:int(255*b)]'
    let hex = '#%[hex:p]'
    let fmt = $"($rgb)\n($hex)\n"
    grim -g $px -t ppm - | magick - -format $fmt info:
}
