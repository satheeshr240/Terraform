#! /bin/bash
 
# Name of the docker Container
CONTAINER_NAME="sonarqube"

#Check docker container is running
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2>/dev/null)
#echo " RUNNING value is: $RUNNING"
 
#If the container is not running, start it
if [ "$RUNNING" != "true" ]; then
  echo " Contrainer $CONTAINER_NAME is not running. Starting container... "
  docker start $CONTAINER_NAME
else
  echo " Container $CONTAINER_NAME is already running. "
fi