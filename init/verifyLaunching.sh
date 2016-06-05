#!/bin/bash
VAR=$(ps aux |  grep 'sudo -u pi python ./pythonWebServer.py' | grep -v grep)
if [ -z   "$VAR" ]
	then
	#python webServer is not lauchn
	exit 1
fi
#python webServer is  launch
exit 0




