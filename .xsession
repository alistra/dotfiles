# Tray
if [ "`hostname`" == bialobrewy ] ; then
	trayer --edge top --align right --margin 1280 --SetDockType true --SetPartialStrut true --expand true --width 2 --transparent true --tint 0x000000 --height 12 &
else
	trayer --edge top --align right --margin 0 --SetDockType true --SetPartialStrut true --expand true --width 4 --transparent true --tint 0x000000 --height 12 &
fi
# Wallpaper
if [ "`hostname`" == bialobrewy ] ; then
	qiv -y ~/.wallpaper &
else
	qiv -x ~/.wallpaper &
fi

# Numlock
numlockx &

# Repeat speed
xset r rate 300 25 &

# Polish keyboard
setxkbmap -layout pl &

# Back, forward unbind
xmodmap ~/.Xmodmap &

# Cursor
xsetroot -cursor_name left_ptr &

# Applications
xscreensaver -no-splash &
urxvtd &
autocutsel -s PRIMARY &
autocutsel -s CLIPBOARD &
hoogle server -p 12345 &
notifyd &

# Xmonad start
exec xmonad
