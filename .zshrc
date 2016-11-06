#
# /etc/zsh/zshrc
#

# Freeze the terminal
ttyctl -f

# Command not found hook
source /usr/share/doc/pkgfile/command-not-found.zsh

# Completion
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select

# Autoload
autoload -Uz compinit promptinit colors history-search-end
compinit
promptinit
colors
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Settings
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=$HISTSIZE
setopt histignoredups
setopt appendhistory
bindkey -v

# Fancy prompt
PS1="[%F{%(!.red.blue)}%B%n%b%f@%B%m%b %1~]%# "
RPS1=
function zle-line-init zle-keymap-select {
	RPS1="${${KEYMAP/vicmd/"%F{yellow}%B[NORMAL]%b%f"}/(main|viins)/} [%F{cyan}%?%f]"
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

# Keybindings
typeset -A key
key[Home1]="^[[H"
key[Home2]="^[OH"
key[End1]="^[[F"
key[End2]="^[OF"
key[Insert]="^[[2~"
key[Delete]="^[[3~"
key[BackSpace]="^H"
key[BackTab]="^[[Z"
key[Up]="^[[A"
key[Down]="^[[B"
key[Right]="^[[C"
key[Left]="^[[D"

function bind2maps () {
	local i sequence widget
	local -a maps

	while [[ "$1" != "--" ]]; do
		maps+=( "$1" )
		shift
	done
	shift

	sequence="${key[$1]}"
	widget="$2"

	[[ -z "$sequence" ]] && return 1

	for i in "${maps[@]}"; do
		bindkey -M "$i" "$sequence" "$widget"
	done
}

bind2maps emacs             -- Home1       beginning-of-line
bind2maps       viins vicmd -- Home1       vi-beginning-of-line
bind2maps emacs             -- Home2       beginning-of-line
bind2maps       viins vicmd -- Home2       vi-beginning-of-line
bind2maps emacs             -- End1        end-of-line
bind2maps       viins vicmd -- End1        vi-end-of-line
bind2maps emacs             -- End2        end-of-line
bind2maps       viins vicmd -- End2        vi-end-of-line
bind2maps emacs viins       -- Insert      overwrite-mode
bind2maps             vicmd -- Insert      vi-insert
bind2maps emacs             -- Delete      delete-char
bind2maps       viins vicmd -- Delete      vi-delete-char
bind2maps emacs             -- BackSpace   backward-delete-char
bind2maps       viins       -- BackSpace   vi-backward-delete-char
bind2maps             vicmd -- BackSpace   vi-backward-char
bind2maps emacs viins vicmd -- BackTab     reverse-menu-complete
bind2maps emacs viins vicmd -- Up          history-beginning-search-backward-end
bind2maps emacs viins vicmd -- Down        history-beginning-search-forward-end
bind2maps emacs             -- Left        backward-char
bind2maps       viins vicmd -- Left        vi-backward-char
bind2maps emacs             -- Right       forward-char
bind2maps       viins vicmd -- Right       vi-forward-char

unfunction bind2maps

# Colorful mate-terminal
[[ $(cat /proc/$PPID/cmdline) =~ "mate-terminal" ]] && TERM=xterm-256color

# Aliases
alias cupstart="systemctl start org.cups.cupsd.service"
alias cupstop="systemctl stop org.cups.cupsd.service"
alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Sprunge
sprunge() {
	curl -F 'sprunge=<-' http://sprunge.us
}
