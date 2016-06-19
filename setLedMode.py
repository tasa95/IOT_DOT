#!/usr/bin/env python
# -*- coding: utf-8 -*

import cgi
import subprocess
import os
import fcntl

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

print("Content-type: text/html; charset=utf-8\n")
mode = getCurrentModeFromHTTP();
print(mode);

if mode is not None and (mode == "1" or mode == "2"):
	writeNewMode(mode);
	writeNewSleepTime();
	cmd = "sudo "+path+"/cPartFolder/codesend "+mode
	subprocess.call([cmd],shell=True)
html = """<!DOCTYPE html>
<head>
    <title>Mon programme</title>
</head>
<body>

</body>
</html>
"""

print(html)
