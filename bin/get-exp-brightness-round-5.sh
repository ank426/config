#!/bin/sh
brightnessctl -e info | awk 'NR==2 {print int(substr(substr($NF, 1, length($NF)-2), 2)/5)*5}'
