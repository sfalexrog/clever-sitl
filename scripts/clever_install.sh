#!/bin/bash

# Stop on errors, display actual commands
set -ev

CLEVER_SRC=/home/$ROSUSER/clever
CATKIN_WS=/home/$ROSUSER/catkin_ws

# Enable ROS environment 
source /opt/ros/kinetic/setup.bash

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
	git \
	python-dev \
	python3-dev

git clone --depth 50 https://github.com/copterexpress/clever $CLEVER_SRC
mkdir -p $CATKIN_WS/src
ln -s $CLEVER_SRC/clever $CATKIN_WS/src/clever
cd $CATKIN_WS
rosdep install -y --from-paths src --ignore-src -r
catkin_make

# A workaround for VL53L1X being a RPi-only package :(
(xargs -a $CATKIN_WS/src/clever/requirements.txt -n 1 pip install --user || true)

# GeographicLib needs to be installed as well
sudo /opt/ros/$ROS_DISTRO/lib/mavros/install_geographiclib_datasets.sh

echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
echo "source $CATKIN_WS/devel/setup.bash" >> ~/.profile

# Launch web_video_server and rc by default

sed -i "s/\"web_video_server\" default=\"false\"/\"web_video_server\" default=\"true\"/" $CLEVER_SRC/clever/launch/sitl.launch
sed -i "s/\"rc\" default=\"false\"/\"rc\" default=\"true\"/" $CLEVER_SRC/clever/launch/sitl.launch

