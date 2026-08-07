# =============================================
# config.nu  —  Configuración principal Nushell
# =============================================

# --- Starship prompt ---
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# ─────────────────────────────────────────────
# CONFIGURACIÓN CENTRAL
# ─────────────────────────────────────────────
$env.config = {
    show_banner: false      # fastfetch lo reemplaza (ver abajo)
    edit_mode:   emacs

    history: {
        max_size:     10000
        sync_on_enter: true
        file_format:  "sqlite"    # historial persistente entre sesiones
    }

    # Sugerencia inline desde historial (equivalente a zsh-autosuggestions)
    # Aparece en gris mientras escribes; Ctrl+F la acepta completa
    shell_integration: {
        osc2:   true
        osc7:   true
        osc8:   true
        osc9_9: false
        osc133: true
    }

    # ── Menú de completado tipo IDE ──────────────────────────────────────
    menus: [
        # Menú de historial completo (Ctrl+R, como en zsh)
        {
            name:                  history_menu
            only_buffer_difference: true
            marker:                "? "
            type: {
                layout:    list
                page_size: 20
            }
            style: {
                text:             cyan
                selected_text:    cyan_reverse
                description_text: blue
            }
        }
    ]

    # ── Keybindings ──────────────────────────────────────────────────────
    keybindings: [
        # Ctrl+F → acepta la sugerencia inline de historial completa
        # (igual que bindkey '^F' autosuggest-accept en zsh)
        {
            name:     aceptar_sugerencia
            modifier: control
            keycode:  char_f
            mode:     [emacs, vi_insert]
            event:    { send: historyhintcomplete }
        }
        # Ctrl+R → historial en menú completo
        {
            name:     historial
            modifier: control
            keycode:  char_r
            mode:     [emacs, vi_insert]
            event:    { send: menu name: history_menu }
        }
        # Home / Fin de línea
        {
            name:     inicio_linea
            modifier: none
            keycode:  home
            mode:     [emacs, vi_insert]
            event:    { edit: movetolinestart }
        }
        {
            name:     fin_linea
            modifier: none
            keycode:  end
            mode:     [emacs, vi_insert]
            event:    { edit: movetolineend }
        }
        # Supr → borrar carácter a la derecha
        {
            name:     delete_char
            modifier: none
            keycode:  delete
            mode:     [emacs, vi_insert]
            event:    { edit: delete }
        }
        # Alt+← → palabra atrás (como ^[[1;3D en zsh)
        {
            name:     palabra_atras
            modifier: alt
            keycode:  left
            mode:     [emacs, vi_insert]
            event:    { edit: movewordleft }
        }
        # Esc → añade/quita sudo al inicio (como zsh-sudo, una pulsación)
        {
            name:     toggle_sudo
            modifier: none
            keycode:  esc
            mode:     [emacs]
            event:    { send: executehostcommand, cmd: "toggle_sudo" }
        }
    ]

    # ── hook: fnm use-on-cd ──────────────────────────────────────────────
    # Cambia la versión de Node automáticamente al entrar a un directorio
    # que tenga .nvmrc / .node-version (equivalente a fnm env --use-on-cd)
    hooks: {
        env_change: {
            PWD: [
                {|_before, _after|
                    if (which fnm | is-not-empty) {
                        fnm use --silent-if-unchanged
                    }
                }
            ]
        }
    }

    completions: {
        external: {
            enable: true
            completer: {|spans|
                carapace $spans.0 nushell ...$spans
                | from json
                | if ($in | default [] | where value =~ '^-' | is-empty) { $in } else { $in }
            }
        }
    }

    color_config: {
        # Comandos
        shape_internalcall: { fg: cyan attr: b }   # comandos built-in
        shape_external:     { fg: cyan attr: b }  # comandos externos (pactl, git…)
        shape_garbage:      { fg: red attr: b }    # comando no existe → rojo

        # Valores
        shape_string:    yellow
        shape_int:       cyan
        shape_float:     cyan
        shape_bool:      light_cyan

        # Variables y operadores
        shape_variable:  purple
        shape_operator:  white
        shape_pipe:      { fg: white attr: b }

        # Rutas y flags
        shape_filepath:  { fg: cyan attr: u }      # subrayado como zsh
        shape_flag:      blue
        shape_keyword:   { fg: purple attr: b }

        # Errores / desconocido
        shape_nothing:   light_red
    }
}

# ─────────────────────────────────────────────
# ZOXIDE  (navegación por directorios históricos)
#   z  → cd al directorio más frecuente que coincide
#   zi → selección interactiva con fzf
#   zq → query sin cambiar de directorio
# ─────────────────────────────────────────────
if (which zoxide | is-not-empty) {
    # hook: registra los directorios visitados
    $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD | append {
        __zoxide_hook: true
        code: {|_, dir| ^zoxide add -- $dir }
    })
}

# z → cd al mejor match (o al dir si ya es uno existente)
def --env z [...rest: string] {
    cd (
        if ($rest | is-empty) { '~' }
        else if ($rest | length) == 1 and (($rest.0 | path expand) | path type) == 'dir' { $rest.0 }
        else { ^zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n" }
    )
}

# zi → selección interactiva de directorio histórico (zoxide + fzf)
def --env zi [...rest: string] {
    cd (^zoxide query --interactive -- ...$rest | str trim -r -c "\n")
}

# zq → query sin cambiar de directorio
def zq [...rest: string] {
    ^zoxide query -- ...$rest
}

# ─────────────────────────────────────────────
# FASTFETCH
# ─────────────────────────────────────────────
fastfetch

# ─────────────────────────────────────────────
# ALIAS
# ─────────────────────────────────────────────
alias l   = ls
alias ll  = ls -l
alias la  = ls -a
alias lsa = ls -a
alias lla = ls -la
alias cat = bat
alias icat = kitty +kitten icat
alias mp3 = musikcube
alias npm = pnpm
alias npx = pnpx
alias music = ncmpcpp
alias cmatrix = ^cmatrix -C cyan

# pacs: buscar e instalar paquetes de pacman con fzf
# (usa bash interno para el pipeline complejo con comillas anidadas)
def pacs [] {
  ^zsh ~/.local/bin/pacs.zsh
}

# ─────────────────────────────────────────────
# FUNCIONES  (de tu zshrc, portadas a Nushell)
# ─────────────────────────────────────────────

def toggle_sudo [] {
    let line = (commandline)
    let new = if ($line | str starts-with 'sudo ') {
        $line | str replace -r '^sudo\s+' ''
    } else {
        $"sudo ($line)"
    }
    commandline edit --replace $new
}

# Crea estructura de directorios para pentest/CTF
def mkt [] {
    mkdir nmap content exploits scripts
    print "✓ Creados: nmap/ content/ exploits/ scripts/"
}

# fzf con preview de archivos (usa bat para resaltado)
def fzfh [] {
    ^fzf -m --reverse --preview-window down:20 --preview $"($env.HOME)/.local/bin/fzfh_preview.zsh {}"
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

# Extrae puertos abiertos de un archivo de salida de nmap
# Uso: extractPorts nmap_output.txt
def extractPorts [file: string] {
    let content  = (open $file | into string)
    let ports    = (
        $content
        | grep -oP '\d{1,5}/open'
        | lines
        | each { |l| $l | split row '/' | first }
        | str join ','
        | str trim
    )
    let ip = (
        $content
        | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
        | lines
        | sort
        | uniq
        | first
    )
    print $"\n[*] Extrayendo información...\n"
    print $"\t[*] IP Address : ($ip)"
    print $"\t[*] Open ports : ($ports)\n"
    $ports | xclip -sel clip
    print "[*] Puertos copiados al portapapeles\n"
}

# Borrado seguro de archivos (DoD 7 pasadas + shred)
# Uso: rmk archivo.txt
def rmk [file: string] {
    scrub -p dod $file
    shred -zun 10 -v $file
}
