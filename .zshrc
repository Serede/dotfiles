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
key[Home3]="^[[7~"
key[End1]="^[[F"
key[End2]="^[OF"
key[End3]="^[[8~"
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
bind2maps emacs             -- Home3       beginning-of-line
bind2maps       viins vicmd -- Home3       vi-beginning-of-line
bind2maps emacs             -- End1        end-of-line
bind2maps       viins vicmd -- End1        vi-end-of-line
bind2maps emacs             -- End2        end-of-line
bind2maps       viins vicmd -- End2        vi-end-of-line
bind2maps emacs             -- End3        end-of-line
bind2maps       viins vicmd -- End3        vi-end-of-line
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
if [ -f ~/.powerlevel9k/powerlevel9k.zsh-theme ] && [ $(tput colors) -eq 256 ]; then
    source ~/.powerlevel9k/powerlevel9k.zsh-theme
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context custom_dir vcs virtualenv rbenv custom_prompt)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode status)
    POWERLEVEL9K_CONTEXT_TEMPLATE="%B%m%b $(print_icon 'LEFT_SUBSEGMENT_SEPARATOR') %B%n%b"
    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='black'
    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='cyan'
    POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='white'
    POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND='red'
    POWERLEVEL9K_SHORTEN_DIR_LENGTH='1'
    POWERLEVEL9K_SHORTEN_DELIMITER=''
    POWERLEVEL9K_CUSTOM_DIR='echo %1~'
    POWERLEVEL9K_CUSTOM_DIR_FOREGROUND='black'
    POWERLEVEL9K_CUSTOM_DIR_BACKGROUND='blue'
    POWERLEVEL9K_VCS_BRANCH_ICON=$'\uE0A0 '
    POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
    POWERLEVEL9K_VCS_CLEAN_BACKGROUND='blue'
    POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
    POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='blue'
    POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'
    POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='blue'
    POWERLEVEL9K_VIRTUALENV_FOREGROUND='white'
    POWERLEVEL9K_VIRTUALENV_BACKGROUND='008'
    POWERLEVEL9K_RBENV_FOREGROUND='white'
    POWERLEVEL9K_RBENV_BACKGROUND='008'
    POWERLEVEL9K_CUSTOM_PROMPT='echo %#'
    POWERLEVEL9K_CUSTOM_PROMPT_FOREGROUND='white'
    POWERLEVEL9K_CUSTOM_PROMPT_BACKGROUND='008'
    POWERLEVEL9K_VI_INSERT_MODE_STRING=''
    POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='white'
    POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='008'
    POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='white'
    POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND='008'
    POWERLEVEL9K_STATUS_OK_FOREGROUND='black'
    POWERLEVEL9K_STATUS_OK_BACKGROUND='cyan'
    POWERLEVEL9K_STATUS_ERROR_FOREGROUND='black'
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND='magenta'
    function zle-line-init zle-keymap-select {
        zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-keymap-select
    export KEYTIMEOUT=1
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
