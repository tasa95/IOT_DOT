#!/usr/bin/python
##########################################################
# Author : Allard saint albin Thierry
# Description : Start python webServer
# Argument 0 : Script name
# Argument 1 : file for log 
#

import BaseHTTPServer
import CGIHTTPServer
import sys
import datetime
import SocketServer
import SimpleHTTPServer
import os

#IF argument 1 exists
if(len(sys.argv) > 1):
	fileError = sys.argv[1]
	#Redirect screen error output and standard output to file
	sys.stderr = open(fileError,'a+')
	sys.stdout = open(fileError,'a+')
	## print actual user id
	print os.getegid()
	## print actual dateTime
	print datetime.datetime.now()


PORT = 8888

#Simple HTTPServer
server_adress= ("",PORT)
server = BaseHTTPServer.HTTPServer
handler = CGIHTTPServer.CGIHTTPRequestHandler
handler.cgi_directories = ["/"]
print "Server actif sur le port :", PORT

httpd = server(server_adress,handler)
httpd.serve_forever()
##FIN
