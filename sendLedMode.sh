#!/bin/bash
###################################################################
#	Author : Allard saint albin Thierry
#	Description :  repeat sending code send to arduino with an increasing sleeping time
#	File For currentMode.txt contains the data that will be send 
#	currentSleepTime.txt contains the sleeping time
#


##If Interruption is send to the script it will erase the lock on it
trap '{ rm -rf /var/lock/sendLedMode.exclusiveLock; exit 1; }' INT

##Get the path of the script
MY_PATH="`dirname \"$0\"`"                      # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"     	#ABSOLUTE
occurence=0
defaulTime=1
startTime=0
limit=10
(
echo $BASHPID >> sendLedModePid
## lock  script execution with file descriptor 200 and a sleeping time of 10
flock -x -w 10 200 || exit 1
while true; do
	#Get current mode
	currentMode="$(cat $MY_PATH/currentmode.txt)"

	date +"%m/%d/%Y %H:%M:%S $HOSTNAME" 
	#send the current Mode to codesend script
	cmd="sudo $MY_PATH/cPartFolder/codesend $currentMode"
	eval $cmd
	#get the current Sleeping between the next script execution
	currentSleepTime="$(cat $MY_PATH/currentSleepTime.txt)"
	#if default time equals start Time so the setLetMode.py webPage has been called 
	if [ "$currentSleepTime" == "$startTime" ]
		then
		occurence=O
		#we lock and write default time to a txt file
		currentSleepTime=$defaulTime
		flock -x -w 5  "$MY_PATH/currentSleepTime.txt" echo $currentSleepTime > "$MY_PATH/currentSleepTime.txt"
	fi
		
	## IF  the setLedMode.py has not been calls  during 10 sleep, so we increase the sleeping tiùe
	if [ $occurence == $limit ]
		then
		currentSleepTime=$(($currentSleepTime *10))	
		echo "Nouveau Temps d'attente pour l'envoi du mode : $currentSleepTime secondes"
		## we lock and write the new default time
		flock -x -w 5  "$MY_PATH/currentSleepTime.txt" echo $currentSleepTime > "$MY_PATH/currentSleepTime.txt" 
	fi
	let occurence++
	#Sleep command
	sleep "$currentSleepTime"
done
) 200>/var/lock/sendLedMode.exclusiveLock
