#!/bin/bash

if [ -z $ROS_DISTRO ]; then
  echo "ROS_DISTRO is not set; source your ROS setup.bash!"
  exit 1
fi

WORLD_NAME=$1

if [ -z $WORLD_NAME ]; then
  WORLD_NAME=clever
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${SCRIPT_DIR}/gazebo_px4_envsetup.bash

roslaunch gazebo_ros empty_world.launch world_name:=${SCRIPT_DIR}/worlds/${WORLD_NAME}.world

