#!/bin/sh
brightness=$($XDG_CONFIG_HOME/bin/get-exp-brightness-round-5.sh)
if [ "$brightness" -ne 0 ]; then
    brightnessctl -e -q set $(($brightness + 5))%
else
    brightnessctl -q set 1
fi
