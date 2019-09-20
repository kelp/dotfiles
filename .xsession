# set UTF-8 everywhere
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# load Xresources file
xrdb -merge $HOME/.Xresources

# set your background color
xsetroot -solid dimgray

# xidle will lock your display after a period of inactivity
xidle &

# sadly, xclock has a bug where the font selection is ignored when UTF-8
# is enabled, so we unset LANG here.
LANG= xclock -strftime "%a %e %b %Y %H:%M" &

# disable system beep
xset b off

# if you have a ThinkPad, the following lines enable TrackPoint
# scrolling by dragging with the middle button.
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1 
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2 
# Apple Style Natural Scrolling
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 7 6 5 4 
# Take 5 pixels of movement before we start scrolling. Defualt is 10
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Inertia" 5

# use caps lock as ctrl key
setxkbmap -option ctrl:nocaps

PREFIX=/usr/local

if [ -x ${PREFIX}/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
        eval `dbus-launch --sh-syntax --exit-with-x11`
fi

# start cwm!
exec cwm
