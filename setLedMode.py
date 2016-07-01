#!/usr/bin/env python
# -*- coding: utf-8 -*

import cgi
import subprocess
import os
import fcntl
import time
import signal
import datetime
def getCurrentModeFromHTTP():
	form = cgi.FieldStorage()
	mode = form.getvalue("mode")
	return mode;

def  writeNewMode(mode):
	fileMode = open('currentmode.txt','w')
        fcntl.flock(fileMode,fcntl.LOCK_EX | fcntl.LOCK_NB)
        fileMode.write(mode)
        fcntl.flock(fileMode,fcntl.LOCK_UN)
        fileMode.close()
	return;

def writeNewSleepTime():
	value="0"
	fileSleep = open('currentSleepTime.txt','w')
        fcntl.flock(fileSleep,fcntl.LOCK_EX | fcntl.LOCK_NB)
        fileSleep.write("0")
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

print("Content-type: text/html; charset=utf-8\n")
mode = getCurrentModeFromHTTP();
print(mode);
now = time.strftime("%c")
if mode is not None and (mode == "1" or mode == "2"):
	writeNewMode(mode);
	writeNewSleepTime();
	restartSendLedMode();
html = """<!DOCTYPE html>
<head>
    <title>Mon programme</title>
</head>
<body>

</body>
</html>
"""

print(html)
