#!/bin/bash

docker rm -f mosquitto

docker run \
	-d \
	--name=mqtt \
	-p 1883:1883 \
	mosquitto:1.4.14-beta.1
	
