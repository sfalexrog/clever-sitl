#!/bin/bash

# Stop on errors, display actual commands
set -ex

CLEVER_SRC=/home/$ROSUSER/clever
CATKIN_WS=/home/$ROSUSER/catkin_ws

# Enable ROS environment 
source /opt/ros/$ROS_DISTRO/setup.bash

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
	git \
	python-dev \
	python3-dev

git clone https://github.com/copterexpress/clever $CLEVER_SRC
mkdir -p $CATKIN_WS/src
ln -s $CLEVER_SRC/clever $CATKIN_WS/src/clever
cd $CATKIN_WS
rosdep install -y --from-paths src --ignore-src -r
catkin_make

# A workaround for VL53L1X being a RPi-only package :(
(xargs -a $CATKIN_WS/src/clever/requirements.txt -n 1 pip install --user || true)

# GeographicLib needs to be installed as well
sudo /opt/ros/$ROS_DISTRO/lib/mavros/install_geographiclib_datasets.sh

echo 'PATH="$HOME/.local.bin:$PATH"' >> ~/.profile

