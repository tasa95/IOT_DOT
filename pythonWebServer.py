#!/usr/bin/python

import BaseHTTPServer
import CGIHTTPServer
import sys
import datetime
import SocketServer
import SimpleHTTPServer
if(len(sys.argv) > 1):
	fileError = sys.argv[1]
	sys.stderr = open(fileError,'a+')
	sys.stdout = open(fileError,'a+')
	print datetime.datetime.now()

#class MyHTTPHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
#    log_file = open(sys.argv[1], 'w')
#    def log_message(self, format, *args):
#        self.log_file.write("%s - - [%s] %s\n" %
#                            (self.client_address[0],
#                             self.log_date_time_string(),
#                             format%args))

PORT = 8888
##Mon Propre Handler
#Handler = MyHTTPHandler
#httpd = SocketServer.TCPServer(("", PORT), Handler)
#print "serving at port", PORT
#httpd.serve_forever()
##Fin du Handler

#Simple HTTPServer
server_adress= ("",PORT)
server = BaseHTTPServer.HTTPServer
handler = CGIHTTPServer.CGIHTTPRequestHandler
handler.cgi_directories = ["/"]
print "Server actif sur le port :", PORT

httpd = server(server_adress,handler)
httpd.serve_forever()
##FIN
