urxvt*background: black
urxvt*foreground: gray
urxvt*fading: 10
urxvt*scrollBar: false

urxvt*font: xft:DejaVu Sans Mono:pixelsize=15:antialias=false
!! urxvt*font: xft:DejaVu Sans Mono:pixelsize=15:antialias=true
!! urxvt*font: xft:Bitstream Vera Sans Mono:pixelsize=15
!! urxvt*font: xft:Inconsolata:pixelsize=17
urxvt*transparent: yes
urxvt*shading: 10
urxvt.urgentOnBell: true
urxvt.cursorBlink: false
urxvt.saveLines: 65535
urxvt.perl-ext-common: default,matcher
urxvt.urlLauncher: xxxterm
urxvt.matcher.button: 2
urxvt.matcher.pattern.1: \\bwww\\.[\\w-]\\.[\\w./?&@#-]*[\\w/-]
urxvt.termName: rxvt
urxvt.scrollTtyOutput: false
urxvt.scrollWithBuffer: true
urxvt.scrollTtyKeypress: true

#define S_base03        #002b36
#define S_base02        #073642
#define S_base01        #586e75
#define S_base00        #657b83
#define S_base0         #839496
#define S_base1         #93a1a1
#define S_base2         #eee8d5
#define S_base3         #fdf6e3
#define S_yellow        #b58900
#define S_orange        #cb4b16
#define S_red           #dc322f
#define S_magenta       #d33682
#define S_violet        #6c71c4
#define S_blue          #268bd2
#define S_cyan          #2aa198
#define S_green         #859900

*background:            S_base03
*foreground:            S_base00
*fading:                40
*fadeColor:             S_base03
*cursorColor:           S_base1
*pointerColorBackground:S_base01
*pointerColorForeground:S_base1

!! black dark/light
*color0:                S_base02
*color8:                S_base03

!! red dark/light
*color1:                S_red
*color9:                S_orange

!! green dark/light
*color2:                S_green
*color10:               S_base01

!! yellow dark/light
*color3:                S_yellow
*color11:               S_base00

!! blue dark/light
*color4:                S_blue
*color12:               S_base0

!! magenta dark/light
*color5:                S_magenta
*color13:               S_violet

!! cyan dark/light
*color6:                S_cyan
*color14:               S_base1

!! white dark/light
*color7:                S_base2
*color15:               S_base3

