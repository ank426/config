#!/bin/sh
brightness=$($XDG_CONFIG_HOME/hypr/scripts/get-exp-brightness-round-5.sh)
if [ "$brightness" -ne 0 ]; then
    brightnessctl -e -q set $(($brightness - 5))%
fi
