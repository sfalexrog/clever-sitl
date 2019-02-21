#!/bin/bash

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

docker run \
	-it \
	--rm \
	-p 14556:14556 \
	-p 14557:14557 \
	-p 8080:8080 \
	-p 8081:8081 \
    -p 9090:9090 \
    -p 35602:35602 \
	sfalexrog/clever-sitl:latest /bin/bash
