#!/bin/bash

echo "Waiting for Gazebo server to launch..."

until gzpid=$(pidof gzserver)
do
	sleep 1;
	echo "Still waiting..."
done

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

cd /home/$ROSUSER/gzweb
npm start -p 8081

