source /etc/profile
source /etc/zsh/zprofile
#{{{ Prompt
autoload -U compinit promptinit
compinit
promptinit; prompt gentoo
#}}}
#{{{ Variables
umask 077
export HISTSIZE=20000
export LESS="$LESS -i"
export GREP_OPTIONS="--color"
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
export WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
export EDITOR="vim-open"
export VISUAL="vim-open"
export PAGER="less"
export SOCKS_SERVER="localhost:31337"
export BROWSER='xxxterm' 
#}}}
#{{{ Options
setopt correctall
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt autocd
setopt extendedglob
setopt AUTO_LIST
setopt AUTO_MENU
setopt APPEND_HISTORY
setopt share_history
setopt complete_in_word
setopt list_packed
setopt noequals
#}}}
#{{{ Completion
zmodload  zsh/complist
#kill, killall
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31' 
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

#completion cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache

#completion
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion:*:*:default' force-list always

#ignore function which are not existant
zstyle ':completion:*:functions' ignored-patterns '_*'

#removing trailing slashes from directory as an argument
zstyle ':completion:*' squeeze-shlashes 'yes'

#don't complete cd in your own dir (eg. ../`pwd`)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#colors
[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31' 

#path expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion::complete:*' '\\'

#ps
zstyle ':completion:*:processes' command 'ps -au$USER'

#warnings
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

#group matches amd describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
#}}}
#{{{ Key Bindings
bindkey -e
bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\eOd" backward-word
bindkey "\eOc" forward-word
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
#}}}
source ~alistra/.aliases
source ~alistra/.zshinit
