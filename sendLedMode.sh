#!/bin/bash
MY_PATH="`dirname \"$0\"`"                      # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"     	#ABSOLUTE
while true; do
	currentMode="$(cat $MY_PATH/currentmode.txt)"
	cmd="sudo $MY_PATH/cPartFolder/codesend $currentMode  > /dev/null 2>&1"
	eval $cmd
	sleep 10
done





