#!/bin/bash
#########################################################
#	Author : Allard saint albin Thierry
#
#	Description : Send Ip  mac adresse and role to the web api
# 	Log file are present in the logs directory of the init folder
#
SLEEP="/bin/sleep"
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd $SCRIPTPATH
source configuration.cfg
echo "Address : $ADDRESS"
echo "Role: $ROLE"
IP=""
ext=".log"
TIME="$(/bin/date +%H_%M_%S)"
DATE="$(/bin/date +%d_%m_%Y)"
FNAME="sendIPLog"
DATAFILE=$SCRIPTPATH"/data.xvf"
FILENAME=$SCRIPTPATH"/logs/"$DATE"_"$TIME$FNAME$ext

#Until I don't have an IP Adress
until [ -n "$IP" ]; do
	IP="$($SCRIPTPATH/getIpAddress.sh)" 
	$SLEEP 1
done
MAC=$("$SCRIPTPATH"/getMacAddress.sh)
MAC=${MAC^^}
echo "MAC: $MAC"
#EXTERN SCREEN 2
#INTERN SCREEN 1

TEXT="SEND IP"


json="{\"ip_address\":\"$IP\", \"mac_address\":\"$MAC\", \"name\":\"$NAME\", \"role\":\"$ROLE\"}"
ID=0

if [ -e "$DATAFILE" ]
	then
	ID=$(cat "$DATAFILE" | grep -oh 'id":"[0-9]*"' | grep -oh "[0-9]*")
	TEXT="UPDATE IP"
	if [ -z "$ID" ]
		then
		echo "NO ID in File delete IT and exit"
		rm "$DATAFILE"
		exit 0
	fi
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
	HTTP_CODE_STATUS=$(echo "$RESPONSE" | head -n 1 | grep -E -o [0-9]{3})
	echo "exit_status = $exit_status"
	echo "HTTP_CODE_STATUS = $HTTP_CODE_STATUS"

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
