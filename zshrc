# ~/.zshrc

# Fix the Java Problem
export _JAVA_AWT_WM_NONREPARENTING=1
export SYSTEMD_PAGER=cat

# Enable history
setopt histignorealldups sharehistory
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Manual configuration
PATH=/root/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

zstyle ':completion:*:*:pacman:*' ignored-patterns '*'

# Use modern completion system
autoload -Uz compinit
compinit -C

# Autosuggestions (inline)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_USE_ASYNC=true

bindkey '^F' autosuggest-accept

# Autocomplete (list)
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Lista visible debajo
zstyle ':autocomplete:*' list-lines 8
zstyle ':autocomplete:*' widget-style menu-select
# No auto-confirmar la primera opción
zstyle ':autocomplete:*' auto-select false
# Orden lógico
zstyle ':autocomplete:*' group-order 'history' 'commands' 'paths'
# Ignorar mayúsculas
zstyle ':autocomplete:*' ignore-case yes

zstyle ':autocomplete:*' recent-dirs true

zstyle ':autocomplete:*' tilde true

# Plugins
source /usr/share/zsh-sudo/sudo.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;3D" backward-word

# ---| Correction  and Autocompletion |--- #
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Manual aliases
alias ls='lsd --group-dirs=first'
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias cat='bat'
# Images
alias icat='kitty +kitten icat'
# alias for searching and installing packages
alias pacs="pacman -Slq | fzf -m --preview 'pacman -Si {} ; pacman -Fl {} | awk \"{print \\$2}\"' | xargs -ro sudo pacman -S"
alias mp3="ncmpcpp"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Change color for dir /mnt/
export LS_COLORS="/mnt/*=32;46:$LS_COLORS"

# Functions
function mkt(){
	mkdir {nmap,content,exploits,scripts}
}

# fzf improvement
function fzfh() {
    fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
			echo {} is a binary file ||
			(bat --style=numbers --color=always {} ||
				highlight -O ansi -l {} ||
				coderay {} ||
				rougify {} ||
				cat {}) 2> /dev/null | head -500'
}

# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

# man is a package that provides the manual pages for commands
# Set 'man' colors
function man() {
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;30m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

function rmk(){
	scrub -p dod $1
	shred -zun 10 -v $1
}

# Init Starship
eval "$(starship init zsh)"

# Init Arch's Logo
fastfetch