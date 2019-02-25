#!/bin/bash

source /opt/ros/kinetic/setup.bash
cd /home/$ROSUSER/Firmware
source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/posix_sitl_default

roslaunch gazebo_ros empty_world.launch world_name:=$(pwd)/Tools/sitl_gazebo/worlds/iris_fpv_cam.world gui:=false

