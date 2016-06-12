#!/bin/bash
#
#Author : Allard saint albin Thierry
#
#Send Ip  mac adresse and role to the web api
#
SLEEP="/bin/sleep"
PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source  ./configuration.cfg
echo "Address : $ADDRESS"
echo "Role: $ROLE"
IP=""
ext=".log"
TIME="$(/bin/date +%H_%M_%S)"
DATE="$(/bin/date +%d_%m_%Y)"
FNAME="sendIPLog"
DATAFILE=$PATH"/data.xvf"


FILENAME=$PATH"/logs/"$DATE"_"$TIME$FNAME$ext
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

if[ -a "$DATAFILE"]
	then
	ID=$(cat "$DATAFILE" | grep -oh 'id:":"[0-9]*"' | grep -oh [0-9]*)
	TEXT="UPDATE IP"
fi


RESPONSE=""
while true
do
	if [ $ID == 0 ]
		then
		RESPONSE=$(/usr/bin/curl --output "$FILENAME" -H "Content-Type: application/json"  --fail  --request POST --data "$json" "$ADDRESS")  
	else
		RESPONSE=$(/usr/bin/curl --ouptut "$FILENAME" -H "Content-type: application/json" --fail --request PUT --data "$json" "$ADRESS/$ID")
	fi
	exit_status=$?
	echo "exit_status = $exit_status"
	if [ $exit_status == 0 ]
		then
		echo "$DATE $TIME SUCCESS $TEXT" >> "$FILENAME"
		#SI LA REPONSE EST UN POST
		if [ $ID == 0 ]
			then
			echo "$RESPONSE" > "$DATAFILE"
		fi
		break
	else
		echo "$DATE $TIME FAILED $TEXT" >> "$FILENAME"
		echo "TRY AGAIN IN 10 SECONDS" >> "$FILENAME"
		$SLEEP 10
	fi
done;
