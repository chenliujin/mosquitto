#!/bin/bash

docker rm -f mqtt 

docker run \
	-d \
	--name=mqtt \
  --restart=always \
	-p 1883:1883 \
	mosquitto:1.4.14
	
