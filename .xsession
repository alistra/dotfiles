# Resources
# xrdb -merge .Xresources

# Tray
trayer --edge top --align right --margin 1280 --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --tint 0x191970 --height 12 &

# Wallpaper
qiv -y ~/wallpapers/Dragon.png &

# Numlock
numlockx &

# Repeat speed
xset r rate 300 25 &

# Polish keyboard
setxkbmap -layout pl

# Applications
ktorrent &
kwalletd &
xscreensaver -no-splash &
tmux-init &
urxvtd &

# Xmonad start
exec xmonad
