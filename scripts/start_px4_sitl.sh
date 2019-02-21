#!/bin/bash

# Launch PX4 without a simulator

cd /home/$ROSUSER/Firmware
./build/posix_sitl_default/px4 -d . posix-configs/SITL/init/ekf2/iris

