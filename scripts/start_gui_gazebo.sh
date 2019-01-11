#!/bin/bash

echo "Updating Clever image..."

/scripts/clever_update.sh

echo "Running SITL simulation"

xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "PX4 command window" -e /bin/bash /scripts/start_px4_sitl_gazebo.sh &
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "ROS Clever logs" -e /bin/bash /scripts/start_clever.sh &
xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "User console" -e /bin/bash -login &

wait
