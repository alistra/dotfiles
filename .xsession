# Tray
if [ "`hostname`" == bialobrewy ] ; then
	trayer --edge top --align right --margin 1280 --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --tint 0x191970 --height 12 &
else
	trayer --edge top --align right --margin 0 --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &
fi
# Wallpaper
qiv -x ~/.wallpaper &

# Numlock
numlockx &

# Repeat speed
xset r rate 300 25 &

# Polish keyboard
setxkbmap -layout pl

# Applications
if [ "`hostname`" == bialobrewy ] ; then
	ktorrent &
fi
kwalletd &
xscreensaver -no-splash &
tmux-init &
urxvtd &

# Xmonad start
exec xmonad
