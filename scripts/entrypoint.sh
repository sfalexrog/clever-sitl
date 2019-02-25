#!/bin/bash

# Start virtual X server in the background if there is no display
if [[ -x "$(command -v Xvfb)" && -z "$DISPLAY" ]]; then
	echo "Starting Xvfb"
	Xvfb :99 -screen 0 1600x1200x24+32 &
	export DISPLAY=:99
fi

exec "$@"
