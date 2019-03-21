#!/bin/sh

source /opt/ros/kinetic/setup.bash
source /home/$ROSUSER/catkin_ws/devel/setup.bash
cd /home/$ROSUSER/catkin_ws
echo "Waiting for Gazebo server to launch..."
until gzpid=$(pidof gzserver)
do
	sleep 1;
done
echo "Starting Clever nodes"
roslaunch clever sitl.launch rc:=true web_video_server:=true optical_flow:=true aruco:=true

