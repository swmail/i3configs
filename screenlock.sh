#!/bin/bash

# KEYFILE
KEYFILE=/tmp/z_turned_off

# output T (sTopped), S (interruptible sleep), nothing?
STAT=$(ps aux | grep $(pidof xautolock) | grep xautolock | sed 's/[ ]\+/\t/g' | cut -f8)
#echo $STAT

if [ "$STAT" == "S" ]; then
	# interruptible sleep
	echo "Disable turning screen off"
	xset -dpms
	xset s off
	kill -SIGSTOP $(pidof xautolock)
	touch "$KEYFILE"
	#killall -SIGUSR1 i3status
	pkill -x -SIGUSR1 i3status
elif [ "$STAT" == "T" ]; then
	# stopped
	echo "Enable turning screen off"
	xset +dpms
	xset s on
	kill -SIGCONT $(pidof xautolock)
	rm "$KEYFILE"
	#killall -SIGUSR1 i3status
	pkill -x -USR1 i3status
fi
