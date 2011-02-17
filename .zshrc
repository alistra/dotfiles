source /etc/profile
source /etc/zsh/zprofile
#{{{ Prompt
autoload -U compinit promptinit
compinit
promptinit; prompt gentoo
#}}}
#{{{ Variables
umask 077
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
export WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
export EDITOR="vim"
export VISUAL="/usr/bin/vim"
export BROWSER="chromium"
export PATH="$PATH:$HOME/bin"
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
#{{{ Aliases
alias ls='ls --color=auto -h'
alias grep='nocorrect grep -i --color'
alias egrep='nocorrect egrep -i --color'
alias cogrep='grep -v'
alias du='du -h'
alias df='df -h'
alias ex='rlwrap ex'
alias adventure='rlwrap adventure .adventure'
alias mplayer='mplayer -softvol -softvol-max 800 -volstep 1'
alias mv='nocorrect mv -i'
alias cp='nocorrect cp -i'
alias mkdir='nocorrect mkdir'
alias git='nocorrect git'
alias rm='nocorrect rm'
alias locate='nocorrect locate'
alias echo='nocorrect echo'
alias eix='nocorrect noglob eix'
alias rcp='cp -r'
alias rscp='scp -r'
alias rgrep='grep -r'
alias open='xdg-open'
alias qiv='qiv -tm'
alias v='vim'
alias i='tmux attach -t irc'
alias m='tmux attach -t mail'
alias M='tmux attach -t Music'
alias scpresume="rsync --partial --progress --rsh=ssh"
alias du1='du -h --max-depth=1'
alias fresh='ls -lrt'
alias noemptylines='grep -v "^$"'
alias nocomments='grep -v "^[\t ]*#"'
if [ "`hostname`" = "adeli" ]
then
	alias blueoff='echo 0 > /sys/devices/platform/thinkpad_acpi/bluetooth_enable'
	alias blueon='echo 1 > /sys/devices/platform/thinkpad_acpi/bluetooth_enable'
	alias hibernate='su -c pm-hibernate'
	alias suspend='su -c pm-suspend'
elif [ "`hostname`" = "bialobrewy" ]
then
	alias thps3='cd ~/.wine/drive_c/Program\ Files/Activision/Thps3 && wine Skate3.exe && cd -'
	alias dow='cd /windows/c/Program\ Files/THQ/Dawn\ of\ War\ -\ Dark\ Crusade/ && wine DarkCrusade.exe 1>/dev/null 2>/dev/null && cd -'
	alias sc='wine ~/.wine/drive_c/Program\ Files/Starcraft/StarCraft.exe -window'
	alias cwbench="awk '\$4~/alistra/{s+=\$2}\$4~/dude/{s-=\$2}END{print s}'"
	alias s='tmux attach -t seriale'
	alias c='tmux attach -t current'
fi
#}}}
#{{{ Shell functions
def(){wn "$*" -over} 
loop(){while true; do $@; done}
proxy(){ssh -f -N -D31337 "$*"}
soundssh(){dd if=/dev/dsp | ssh -c arcfour -C $* dd of=/dev/dsp}
todo(){grep "$*" ~/.todo}
todoadd(){echo "$*" >> ~/.todo}
#}}}
#{{{ Tmux Init
if [ "`hostname`" = "adeli" ]
then
	if [ "$ZSHINIT" = "dudemusic" ]
	then
		cd ~/mp3
	fi
elif [ "`hostname`" = "bialobrewy" ] 
then
	if [ "$ZSHINIT" = "Imgur" ]
	then
		Imgur-Directory-Listing/script/server
	elif [ "$ZSHINIT" = "seriale" ]
	then
		cd /torrents
	elif [ "$ZSHINIT" = "current" ]
	then
		cd /torrents
		fresh
	elif [ "$ZSHINIT" = "music" ]
	then
		cd /torrents/music
	fi
fi

if [ "$ZSHINIT" = "mail" ]
then
	alpine
elif [ "$ZSHINIT" = "mail-compose" ]
then
	local MAILTO NEWMAILTO TO CC BCC SUBJECT BODY ATTACH MUTTPARAMS
	MAILTO=$(echo "$MUTTDATA" | sed 's/^mailto://')
	echo "$MAILTO" | grep -qs "^?"
	if [ "$?" = "0" ] ; then
	MAILTO=$(echo "$MAILTO" | sed 's/^?//')
	else
	MAILTO=$(echo "$MAILTO" | sed 's/^/to=/' | sed 's/?/\&/')
	fi
	
	MAILTO=$(echo "$MAILTO" | sed 's/&/\n/g')
	TO=$(echo "$MAILTO" | grep '^to=' | sed 's/^to=//' | awk '{ printf "%s,",$0 }')
	CC=$(echo "$MAILTO" | grep '^cc=' | sed 's/^cc=//' | awk '{ printf "%s,",$0 }')
	BCC=$(echo "$MAILTO" | grep '^bcc=' | sed 's/^bcc=//' | awk '{ printf "%s,",$0 }')
	SUBJECT=$(echo "$MAILTO" | grep '^subject=' | tail -n 1)
	BODY=$(echo "$MAILTO" | grep '^body=' | tail -n 1)
	ATTACH=$(echo "$MAILTO" | sed 's/^attach=/\n\nfile:\/\//g' | awk '/^file:/ { printf "%s,",$0 }')
	MUTTPARAMS=""

	SUBJECT=`echo $SUBJECT | sed -e 's/%20/ /gi'| sed -e 's/subject=//'`
	BODY=`echo $BODY|sed -e 's/%20/ /gi'|sed -e 's/body=//'`
	CC=`echo $CC|sed -e 's/%20/ /gi'|sed -e 's/cc=//'`
	BCC=`echo $BCC|sed -e 's/%20/ /gi'|sed -e 's/bcc=//'`
	ATTACH=`echo $ATTACH|sed -e 's/%20/ /gi'|sed -e 's/attach=//'`
	TO=`echo $TO|sed -e 's/%20/ /gi'| sed -e 's/,/ /gi'`
	
	if [ "$SUBJECT" != "" ] ; then
		MUTTPARAMS="$MUTTPARAMS -s \"$SUBJECT\""
	fi
	if [ "$BODY" != "" ] ; then
		BODYFILE=`mktemp /tmp/mutt.compose.XXXX`
		echo $BODY|sed -e 's/%0A/\n/gi' > $BODYFILE
		cat $BODYFILE
		MUTTPARAMS="$MUTTPARAMS -i $BODYFILE"
	fi	
	if [ "$CC" != "" ] ; then
		MUTTPARAMS="$MUTTPARAMS -c \"$CC\""
	fi
	if [ "$BCC" != "" ] ; then
		MUTTPARAMS="$MUTTPARAMS -b \"$BCC\""
	fi
	if [ "$ATTACH" != "" ] ; then
		MUTTPARAMS="$MUTTPARAMS -a \"$ATTACH\""
	fi
	
	MUTTPARAMS="$MUTTPARAMS -- $TO"
	
	eval "mutt $MUTTPARAMS"
	unset MUTTDATA
	if [ "$BODYFILE" != "" ] ; then
		rm $BODYFILE
	fi
elif [ "$ZSHINIT" = "vim" ]
then
	vim $VIMFILE
	unset VIMFILE
elif [ "$ZSHINIT" = "irc" ]
then
	AUTOSSH_POLL=60
	autossh -M 0 -t af 'ZSHINIT=irc zsh'
	unset AUTOSSH_POLL
fi
unset ZSHINIT
#}}}
