# Completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' match-original only
zstyle ':completion:*' max-errors 2 numeric
zstyle -e ':completion:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

zstyle ':completion:*' format '%F{blue}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{yellow}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:messages' format '%F{green} -- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' select-prompt ''
zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' verbose yes

zstyle :compinstall filename "$HOME/.zshrc"

# Autoload
autoload -Uz compinit colors history-search-end
compinit
colors
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Settings
HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt  histignoredups appendhistory autocd notify
unsetopt beep extendedglob nomatch

# Default prompt
PS1="[%F{%(!.red.blue)}%B%n%b%f@%B%m%b %1~]%# "
RPS1="[%F{cyan}%?%f]"

# Keybindings
bindkey -e
typeset -A key
key[Home]="$terminfo[khome]"
key[End]="$terminfo[kend]"
key[PageUp]="$terminfo[kpp]"
key[PageDown]="$terminfo[knp]"
key[Insert]="$terminfo[kich1]"
key[Delete]="$terminfo[kdch1]"
key[Backspace]="$terminfo[kbs]"
key[Down]="$terminfo[kcbt]"
key[Up]="$terminfo[kcuu1]"
key[Down]="$terminfo[kcud1]"
key[Right]="$terminfo[kcuf1]"
key[Left]="$terminfo[kcub1]"

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

bind2maps emacs             -- Home        beginning-of-line
bind2maps       viins vicmd -- Home        vi-beginning-of-line
bind2maps emacs             -- End         end-of-line
bind2maps       viins vicmd -- End         vi-end-of-line
bind2maps emacs viins       -- PageUp      history-beginning-search-backward-end
bind2maps emacs viins       -- PageDown    history-beginning-search-forward-end
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

# Freeze the terminal
ttyctl -f

# Colorful mate-terminal
[[ $(cat /proc/$PPID/cmdline) =~ 'mate-terminal' ]] && TERM=xterm-256color

# Command not found hook
[ -f /usr/share/doc/pkgfile/command-not-found.zsh ] && source /usr/share/doc/pkgfile/command-not-found.zsh

# Ruby paths
if command -v ruby >/dev/null 2>&1; then
    PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
    export GEM_HOME="$(ruby -e 'print Gem.user_dir')"
fi

# Aliases
alias zplug='LC_ALL=en_US.UTF-8 zplug'
alias sudo='sudo '
alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias cupstart='systemctl start org.cups.cupsd.service'
alias cupstop='systemctl stop org.cups.cupsd.service'
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias vimdiff='nvim -d'
    alias vi='nvim'
fi
alias virtualenv='virtualenv --system-site-packages'
alias virtualenv2='virtualenv2 --system-site-packages'
alias virtualenv3='virtualenv3 --system-site-packages'

# Sprunge
sprunge() {
    curl -F 'sprunge=<-' http://sprunge.us
}

# PLUGINS
[ ! -f ~/.zplug/init.zsh ] && git clone https://github.com/zplug/zplug ~/.zplug
source ~/.zplug/init.zsh

zplug 'bhilburn/powerlevel9k', use:'powerlevel9k.zsh-theme', if:"[[ $(tput colors) -eq 256 ]]"
zplug 'junegunn/fzf', use:'shell/*.zsh'
zplug 'junegunn/fzf-bin', from:gh-r, as:command, rename-to:fzf
zplug 'zsh-users/zsh-completions'

zplug check || zplug install
zplug load

# powerlevel9k settings
if [ -d $ZPLUG_REPOS/bhilburn/powerlevel9k ]; then
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context custom_dir vcs virtualenv rbenv custom_prompt)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
    POWERLEVEL9K_CONTEXT_TEMPLATE="%B%m%b $(print_icon 'LEFT_SUBSEGMENT_SEPARATOR') %n"
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
    POWERLEVEL9K_STATUS_OK_FOREGROUND='black'
    POWERLEVEL9K_STATUS_OK_BACKGROUND='cyan'
    POWERLEVEL9K_STATUS_ERROR_FOREGROUND='black'
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND='magenta'
fi
