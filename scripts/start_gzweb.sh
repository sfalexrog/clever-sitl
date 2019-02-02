#!/bin/bash

echo "Updating Clever packages..."

/scripts/clever_update.sh

echo "Starting Gazebo simulation..."

# TODO: Don't use xterm, put everything into Butterfly terminals

HEADLESS=1
export HEADLESS

xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "PX4 command window" -e /bin/bash -E /scripts/start_px4_sitl_gazebo.sh &
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "ROS Clever logs" -e /bin/bash /scripts/start_clever.sh &
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "User console" -e /bin/bash -login &

echo "Waiting for Gazebo server to launch..."

until gzpid=$(pidof gzserver)
do
    sleep 1;
done

echo "Point your browser to http://localhost:8081"

/bin/bash -l /scripts/start_webui.sh
