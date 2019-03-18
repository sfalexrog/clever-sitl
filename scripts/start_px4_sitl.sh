#!/bin/bash

# Launch PX4 without a simulator

cd /home/$ROSUSER/sim-data
source ./gazebo_px4_envsetup.bash
./run_px4.sh
# ./build/posix_sitl_default/px4 . posix-configs/SITL/init/ekf2/iris

