#!/bin/bash
SLEEP="/bin/sleep"
MYPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
ADDRESS="http://httpbin.org/post"
IP=""
ext=".log"
TIME="$(/bin/date +%H_%M_%S)"
DATE="$(/bin/date +%d_%m_%Y)"
NAME="sendIPLog"
FILENAME=$MYPATH"/logs/"$DATE"_"$TIME$NAME$ext
until [ -n "$IP" ]; do
	IP="$($MYPATH/getIpAddress.sh)"
	$SLEEP 1
done
MAC=$(/home/pi/Server/init/getMacAddress.sh)
#EXTERN SCREEN 1
#INTERN SCREEN 0
ROLE=1
while true
do
	/usr/bin/curl --output "$FILENAME" -H "Content-Type: application/json" --head  --fail -s --request POST  "$ADDRESS" --data "IP=$IP" --data "MAC=$MAC" --data "ROLE=$ROLE"
	exit_status=$?
	if [ $exit_status != 0 ]
		then
		echo "$DATE $TIME SUCCESS send IP" >> "$FILENAME"
		break
	else
		echo "$DATE $TIME FAILED send IP" >> "$FILENAME"
		echo "TRY AGAIN IN 10 SECONDS" >> "$FILENAME"
		$SLEEP 10
	fi
done;
