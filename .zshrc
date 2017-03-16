# Autoload
autoload -Uz compinit promptinit colors history-search-end
compinit
promptinit
colors
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Completion
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select

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

# Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt histignoredups
setopt appendhistory
bindkey -v

# Freeze the terminal
ttyctl -f

# Colorful mate-terminal
[[ $(cat /proc/$PPID/cmdline) =~ "mate-terminal" ]] && TERM=xterm-256color

# Fancy prompt
if [ $(tput colors) -eq 256 ] && [ -f ~/.promptline/shell_prompt.sh ]; then
	function zle-line-init zle-keymap-select {
		_promptline_vim_mode="${${KEYMAP/vicmd/"NORMAL"}/(main|viins)/}"
		_promptline_exit_code="%?"
		__promptline
		zle reset-prompt
	}
	zle -N zle-line-init
	zle -N zle-keymap-select
	export KEYTIMEOUT=1
	source ~/.promptline/shell_prompt.sh
else
	PS1="[%F{%(!.red.blue)}%B%n%b%f@%B%m%b %1~]%# "
	RPS1=
	function zle-line-init zle-keymap-select {
		RPS1="${${KEYMAP/vicmd/"%F{yellow}%B[NORMAL]%b%f"}/(main|viins)/} [%F{cyan}%?%f]"
		zle reset-prompt
	}
	zle -N zle-line-init
	zle -N zle-keymap-select
	export KEYTIMEOUT=1
fi

# Ruby paths
if command -v ruby >/dev/null 2>&1; then
    PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
    export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
fi

# Command not found hook
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases
alias sudo='sudo '
alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias cupstart="systemctl start org.cups.cupsd.service"
alias cupstop="systemctl stop org.cups.cupsd.service"
if command -v nvim >/dev/null 2>&1; then
	alias vim="nvim"
	alias vimdiff="nvim -d"
	alias vi="nvim"
fi

# Sprunge
sprunge() {
	curl -F 'sprunge=<-' http://sprunge.us
}