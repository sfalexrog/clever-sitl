#!/bin/bash

set -v

# Install dependencies

sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y --no-install-recommends \
	gazebo7 \
	libgazebo7-dev \
	libignition-math2-dev \
    libjansson-dev \
    libboost-dev \
    imagemagick \
    libtinyxml-dev \
    mercurial \
    cmake \
    build-essential

cd /home/$ROSUSER

wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" # This loads nvm

nvm install stable

# Get gzweb

hg clone https://bitbucket.org/osrf/gzweb
cd gzweb
hg up gzweb_1.4.0

# Patch build files

patch -p1 <<EOF
diff -r 0e51c72f1307 webify_models_v2.py
--- a/webify_models_v2.py       Mon Jan 29 23:38:09 2018 +0000
+++ b/webify_models_v2.py       Sat Feb 02 20:58:48 2019 +0300
@@ -20,10 +20,10 @@
 
 path = sys.argv[1]
 
-files = os.listdir(path)
+#files = os.listdir(path)
 
 find_cmd = ['find', path, '-name','*']
-files = subprocess.check_output(find_cmd).split()
+files = subprocess.check_output(find_cmd).split('\n')
 
 for file in files:
   try:
EOF

# Set up environment for gzweb to find models

source /usr/share/gazebo/setup.sh
source /home/$ROSUSER/Firmware/Tools/setup_gazebo.bash \
    /home/$ROSUSER/Firmware \
    /home/$ROSUSER/Firmware/build/posix_sitl_default
source /home/$ROSUSER/sim-data/gazebo_px4_envsetup.bash

# Build gzweb

./deploy.sh -m local

GZWEB_SRC=/home/$ROSUSER/gzweb

# Save a little on space
rm -rf $GZWEB_SRC/.hg

