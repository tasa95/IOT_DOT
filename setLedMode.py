#!/usr/bin/env python
# -*- coding: utf-8 -*

import cgi
import subprocess
import os
import fcntl
import time

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
	


path = os.path.dirname(os.path.abspath(__file__))

print("Accept:application/json");
print("Content-type: text/html; charset=utf-8\n");

#print("Accept: text/*, text/html, text/html;level=1, */*; Content-type: text/html; charset=utf-8\n")
mode = getCurrentModeFromHTTP();
codesend = ""
#print(mode);
now = time.strftime("%c")
if mode is not None and (mode == "true" or mode == "false"):
	writeNewMode(mode);
	writeNewSleepTime();
	if mode == "true":
		codesend = "2"
	else:
		codesend = "1"
	cmd = "sudo "+path+"/cPartFolder/codesend "+codesend+ " &"
	subprocess.call([cmd],shell=True)

#print(mode)
html = "<!DOCTYPE html><head><title>Mode Led</title></head><body>"+codesend+"</body></html>"

print(html)
