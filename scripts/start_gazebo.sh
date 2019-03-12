#!/bin/bash

source /opt/ros/kinetic/setup.bash
cd /home/$ROSUSER/Firmware
source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/posix_sitl_default
source /home/$ROSUSER/sim-data/gazebo_px4_envsetup.bash

roslaunch gazebo_ros empty_world.launch world_name:=/home/$ROSUSER/sim-data/worlds/clever.world gui:=false

