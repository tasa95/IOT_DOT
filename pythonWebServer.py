#!/usr/bin/python

import BaseHTTPServer
import CGIHTTPServer
import sys
import datetime

if(len(sys.argv) > 1):
	fileError = sys.argv[1]
	sys.stderr = open(fileError,'w')
	sys.stdout = sys.stderr
	print datetime.datetime.now()


PORT = 8888
server_adress = ("",PORT)

server = BaseHTTPServer.HTTPServer
handler = CGIHTTPServer.CGIHTTPRequestHandler
handler.cgi_directories = ["/"]
print "Server actif sur le port :", PORT

httpd = server(server_adress,handler)
httpd.serve_forever()
