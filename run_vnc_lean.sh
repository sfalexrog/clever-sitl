#!/bin/bash

docker run --rm --name "clever-sitl" -d -p 5900:5900 -p 6080:6080 sfalexrog/clever-sitl:vnc-gui \
&& echo "Open http://localhost:6080 in your browser or open localhost:5900 in your VNC client" \
|| echo "Unable to run container - maybe it is already running?"
