#!/bin/sh

#each client get's its own port.
PORT_NAME=$1
# start docker dev environment
boot2docker init
boot2docker up

# todo change for actual machine:

export MACHINE_NAME="nginx-test"
boot2docker ssh "docker run --name $MACHINE_NAME -d -p $PORT_NAME:$PORT_NAME -v /shared:/shared nginx"

#no workie:
#sshfs -p 2022 docker@localhost:/shared ./docker-images/firstImage/

echo "image has been created..."
boot2docker ssh "docker ps"
echo "use this IP Address for conennection into the machine:"
echo http://`boot2docker ip`:$PORT_NAME

