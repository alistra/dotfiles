if [ "`hostname`" == bialobrewy ] ; then
	trayer --edge top --align right --margin 1280 --SetDockType true --SetPartialStrut true --expand true --width 2 --transparent true --tint 0x000000 --height 12 &
	qiv -y ~/.wallpaper &
else
	trayer --edge top --align right --margin 0 --SetDockType true --SetPartialStrut true --expand true --width 4 --transparent true --tint 0x000000 --height 12 &
	qiv -x ~/.wallpaper &
fi
numlockx &
xset r rate 300 25 &
setxkbmap -layout pl &
xmodmap ~/.Xmodmap &
xsetroot -cursor_name left_ptr &

xscreensaver -no-splash &
urxvtd &
autocutsel -s PRIMARY &
autocutsel -s CLIPBOARD &
hoogle server -p 12345 &
notifyd &

exec xmonad
