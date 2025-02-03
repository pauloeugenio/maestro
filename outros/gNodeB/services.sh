#!/bin/bash


set -e

if (( $# != 1 )); then
    echo "Illegal number of parameters"
    echo "usage: services [create|start|stop]"
    exit 1
fi

command="$1"
case "${command}" in
	"help")
        echo "usage: services [create|start|stop]"
        ;;
    "start")
		
		echo ""
		docker compose -p oai up -d --remove-orphans
		echo ""
		;;
	"stop")
		echo "stopping containers"
		docker compose -p oai down -v --remove-orphans
		;;
	"create")
		echo "Obtaining images"
		# docker pull mongo:3.6
                ;;
	*)
		echo "Command not Found."
		echo "usage: services [create|start|stop]"
		exit 127;
		;;
esac


