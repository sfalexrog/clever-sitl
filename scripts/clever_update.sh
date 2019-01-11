#!/bin/bash

cd /home/$ROSUSER/clever
git pull

cd /home/$ROSUSER/catkin_ws
. /opt/ros/$ROS_DISTRO/setup.bash
. /home/$ROSUSER/catkin_ws/devel/setup.bash
catkin_make

