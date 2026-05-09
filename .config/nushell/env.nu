# =============================================
# env.nu  —  Variables de entorno para Nushell
# =============================================

# --- Sistema ---
$env.QT_QPA_PLATFORM             = "wayland;xcb"
$env.XDG_SESSION_TYPE            = "wayland"
$env._JAVA_AWT_WM_NONREPARENTING = "1"
$env.SYSTEMD_PAGER               = "cat"

# --- Rust / Cargo ---
$env.CARGO_BUILD_JOBS             = "2"
$env.RUSTC_WRAPPER                = "sccache"
$env.CARGO_NET_GIT_FETCH_WITH_CLI = "true"

# --- PATH  (equivalente al typeset -U de zsh: sin duplicados) ---
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend [
        ($env.HOME | path join ".local"  "bin")        # binarios de usuario
        ($env.HOME | path join ".cargo"  "bin")        # rustup / cargo
        ($env.HOME | path join ".local"  "share" "fnm") # binario de fnm
        "/usr/local/bin"
    ]
    | uniq
)

# --- Carapace ---
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'  # optional

# --- fnm → Node → pnpm ---
if (which fnm | is-not-empty) {
    let fnm = (fnm env --json | from json)
    $env.FNM_MULTISHELL_PATH       = $fnm.FNM_MULTISHELL_PATH
    $env.FNM_VERSION_FILE_STRATEGY = $fnm.FNM_VERSION_FILE_STRATEGY
    $env.FNM_DIR                   = $fnm.FNM_DIR
    $env.FNM_LOGLEVEL              = $fnm.FNM_LOGLEVEL
    $env.FNM_NODE_DIST_MIRROR      = $fnm.FNM_NODE_DIST_MIRROR
    # Agrega el bin del Node activo al PATH
    $env.PATH = ($env.PATH | prepend ($fnm.FNM_MULTISHELL_PATH | path join "bin"))
}