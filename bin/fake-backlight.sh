#!/bin/sh

[ -f /tmp/fbl ] && fbl=$(cat /tmp/fbl) || fbl=100

case $1 in
	get)
		echo $fbl
		;;
	g)
		[ $fbl -eq 100 ] || echo $((($fbl + 5) / 10))
		;;
	set)
		pgrep -x gammastep > /dev/null && killall gammastep
		fbl=$(($fbl + $2))
		if [ $fbl -ge 100 ]; then
			[ ! -f /tmp/fbl ] || rm /tmp/fbl
		else
			[ $fbl -lt 10 ] && fbl=10
			# idk why both -o and & are needed but they are
			# also -P doesn't seem to work
			gammastep -o -b "0.$fbl" &
			echo $fbl > /tmp/fbl
		fi
		;;
	*)
		echo 'Unknown argument'
		;;
esac
