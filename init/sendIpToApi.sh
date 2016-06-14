#!/bin/bash
#
#Author : Allard saint albin Thierry
#
#Send Ip  mac adresse and role to the web api
#
SLEEP="/bin/sleep"
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source  ./configuration.cfg
echo "Address : $ADDRESS"
echo "Role: $ROLE"
IP=""
ext=".log"
TIME="$(/bin/date +%H_%M_%S)"
DATE="$(/bin/date +%d_%m_%Y)"
FNAME="sendIPLog"
DATAFILE=$SCRIPTPATH"/data.xvf"


FILENAME=$SCRIPTPATH"/logs/"$DATE"_"$TIME$FNAME$ext
until [ -n "$IP" ]; do
	IP="$(/home/pi/Server/init/getIpAddress.sh)"
	$SLEEP 1
done
MAC=$(/home/pi/Server/init/getMacAddress.sh)
MAC=${MAC^^}
echo "MAC: $MAC"
#EXTERN SCREEN 1
#INTERN SCREEN 0
ROLE=1
TEXT="SEND IP"



json="{\"ip_address\":\"$IP\", \"mac_address\":\"$MAC\", \"name\":\"$NAME\", \"role\":\"$ROLE\"}"
ID=0

if [ -e "$DATAFILE" ]
	then
	ID=$(cat "$DATAFILE" | grep -oh 'id":"[0-9]*"' | grep -oh "[0-9]*")
	TEXT="UPDATE IP"
fi


RESPONSE=""
echo "$ID"
while true
do
	if [ $ID == 0 ] #FIRST TIME IS ON
		then
		RESPONSE=$(/usr/bin/curl -sb --output "$FILENAME" -H "Content-Type: application/json"  --request POST --data "$json" "$ADDRESS")  
	else
		RESPONSE=$(/usr/bin/curl -sb --ouptut "$FILENAME" -H "Content-type: application/json" --request PUT --data "$json" "$ADDRESS/$ID")
	fi
	exit_status=$?
	echo "exit_status = $exit_status"
	if [ $exit_status == 0 ]
		then
		echo "$DATE $TIME SUCCESS $TEXT" >> "$FILENAME"
		#SI LA REPONSE EST UN POST
		if [ $ID == 0 ]
			then
			if [ -n "$RESPONSE" ]
				then
				echo "$RESPONSE" > "$DATAFILE"
			fi
		fi
		break
	else
		echo "$DATE $TIME FAILED $TEXT" >> "$FILENAME"
		echo "TRY AGAIN IN 10 SECONDS" >> "$FILENAME"
		$SLEEP 10
	fi
done;
