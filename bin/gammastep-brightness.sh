#!/bin/sh

if pgrep -x gammastep; then
    killall gammastep
fi

if [ $# -eq 1 ]; then
    gammastep -l 0:0 -t 6500:6500 -o -b $1 &
fi

[ -d "$XDG_STATE_HOME"/gammastep ] || mkdir -p "$XDG_STATE_HOME"/gammastep
echo $1 > $XDG_STATE_HOME/gammastep/brightness
