#!/bin/sh

monitor-sensor | while read line; do
    case $line in
        *orientation\ changed:\ normal)
            hyprctl dispatch exec "hyprctl keyword monitor eDP-2,preferred,auto,auto,transform,0"
            ;;
        # *orientation\ changed:\ left-up)
        #     hyprctl dispatch exec "hyprctl keyword monitor eDP-2,preferred,auto,auto,transform,1"
        #     ;;
        *orientation\ changed:\ bottom-up)
            hyprctl dispatch exec "hyprctl keyword monitor eDP-2,preferred,auto,auto,transform,2"
            ;;
        # *orientation\ changed:\ right-up)
        #     hyprctl dispatch exec "hyprctl keyword monitor eDP-2,preferred,auto,auto,transform,3"
        #     ;;
    esac
done
