#!/bin/sh

#each client get's its own port.
PORT_NAME=$1
# start docker dev environment
boot2docker init
boot2docker up

# todo change for actual machine:

export MACHINE_NAME="nginx-test"
boot2docker ssh "docker run --name $MACHINE_NAME -d -p $PORT_NAME:$PORT_NAME nginx"

echo "image has been created..."
boot2docker ssh "docker ps"
echo "use this IP Address for conennection into the machine:"
echo http://`boot2docker ip`:$PORT_NAME

