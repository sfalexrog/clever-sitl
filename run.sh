#!/bin/bash

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run \
	-it \
	--rm \
	-v $XSOCK:$XSOCK:rw \
	-v $XAUTH:$XAUTH:rw \
	-e DISPLAY=$DISPLAY \
	-e XAUTHORITY=$XAUTH \
	--device /dev/dri/card0:/dev/dri/card0 \
	-p 14556:14556 \
	-p 14557:14557 \
	-p 8080:8080 \
	-p 8081:8081 \
	-p 8082:8082 \
    -p 9090:9090 \
	-p 2222:22 \
    -p 35602:35602 \
	sfalexrog/clever-sitl:latest $@
