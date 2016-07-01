#!/usr/bin/env python
# -*- coding: utf-8 -*

######################################################
#
#	Author : Allard saint albin Thierry
#	Description : web page for send availabiy of people in the room
#	Take True or false for the argument
#	exemple : http://127.0.0.1/setLetMode.py?mode=true


import cgi
import subprocess
import os
import fcntl
import time
import signal
import datetime
## get currentMode argument from web
def getCurrentModeFromHTTP():
	form = cgi.FieldStorage()
	mode = form.getvalue("mode")
	return mode;

##Write the new availability to the file currentMode
def  writeNewMode(mode):
	fileMode = open('currentmode.txt','w')
	## lock the file
        fcntl.flock(fileMode,fcntl.LOCK_EX | fcntl.LOCK_NB)
        fileMode.write(mode)
	#unlocked it
        fcntl.flock(fileMode,fcntl.LOCK_UN)
        fileMode.close()
	return;
##Write hte sleeping Time to the file currentSleepTime
def writeNewSleepTime():
	value="0"
	fileSleep = open('currentSleepTime.txt','w')
	#lock the file
        fcntl.flock(fileSleep,fcntl.LOCK_EX | fcntl.LOCK_NB)
        fileSleep.write("0")
	#unlock the file
        fcntl.flock(fileSleep,fcntl.LOCK_UN)
        fileSleep.close()
	return;

def killSendLedModeProcess():
	if os.path.isfile('sendLedModePid'):
                if os.stat("sendLedModePid").st_size != 0:
			with open('sendLedModePid', 'r') as myfile:
				for line in myfile:
					filePid=line
					cmd = "(sudo kill "+filePid+")&"
					subprocess.call([cmd],shell=True)
			os.remove("sendLedModePid")
			return 0
	return 1

def startSendLedModeProcess():
	today=datetime.datetime.now()
        logFile="log_"+str(today.year)+"_"+str(today.month)+"_"+str(today.day)+"_"+str(today.hour)+"_"+str(today.minute)+"_"+str(today.second)+".log"
        if not os.path.exists("./log"):
        	os.makedirs("log")
        if not os.path.exists("./log/sendLedMode"):
        	os.makedirs("./log/sendLedMode")
        cmd = "(sudo -u pi ./sendLedMode.sh >> ./log/sendLedMode/"+logFile+")&"
        subprocess.call([cmd],shell=True)


def restartSendLedMode():
	if killSendLedModeProcess() == 0:
		startSendLedModeProcess()
			
path = os.path.dirname(os.path.abspath(__file__))

##HTTP HEADERS
print("Accept:application/json");
print("Content-type: text/html; charset=utf-8\n");

mode = getCurrentModeFromHTTP();
codesend = ""
now = time.strftime("%c")
if mode is not None and (mode == "true" or mode == "false"):
	writeNewSleepTime();
	restartSendLedMode();
	if mode == "true":
		codesend = "2"
	else:
		codesend = "1"
	writeNewMode(codesend)
	cmd = "sudo "+path+"/cPartFolder/codesend "+codesend+ " &"
	subprocess.call([cmd],shell=True)

html = "<!DOCTYPE html><head><title>Mode Led</title></head><body>"+codesend+"</body></html>"

print(html)
