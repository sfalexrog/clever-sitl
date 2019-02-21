#!/bin/bash

docker run \
	-it \
	--rm \
	-p 14556:14556 \
	-p 14557:14557 \
	-p 8080:8080 \
	-p 8081:8081 \
	-p 8082:8082 \
    -p 9090:9090 \
    -p 35602:35602 \
	-p 2222:22 \
	sfalexrog/clever-sitl:latest $1
