#!/bin/bash

trap '{ rm -rf /var/lock/sendLedMode.exclusiveLock; exit 1; }' INT
MY_PATH="`dirname \"$0\"`"                      # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"     	#ABSOLUTE
occurence=0
defaulTime=1
startTime=0
limit=10
(
echo $BASHPID >> sendLedModePid
flock -x -w 10 200 || exit 1
while true; do
	currentMode="$(cat $MY_PATH/currentmode.txt)"

	date +"%m/%d/%Y %H:%M:%S $HOSTNAME" 
	cmd="sudo $MY_PATH/cPartFolder/codesend $currentMode"
	eval $cmd
	currentSleepTime="$(cat $MY_PATH/currentSleepTime.txt)"
	if [ "$currentSleepTime" == "$startTime" ]
		then
		occurence=O
		currentSleepTime=$defaulTime
		flock -x -w 5  "$MY_PATH/currentSleepTime.txt" echo $currentSleepTime > "$MY_PATH/currentSleepTime.txt"
	fi
		
	
	if [ $occurence == $limit ]
		then
		currentSleepTime=$(($currentSleepTime *10))
		echo "Nouveau Temps d'attente pour l'envoi du mode : $currentSleepTime secondes"
		flock -x -w 5  "$MY_PATH/currentSleepTime.txt" echo $currentSleepTime > "$MY_PATH/currentSleepTime.txt" 
	fi
	let occurence++
	sleep "$currentSleepTime"
done
) 200>/var/lock/sendLedMode.exclusiveLock
