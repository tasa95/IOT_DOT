#!/usr/bin/python

import BaseHTTPServer
import CGIHTTPServer


PORT = 8888
server_adress = ("",PORT)

server = BaseHTTPServer.HTTPServer
handler = CGIHTTPServer.CGIHTTPRequestHandler
handler.cgi_directories = ["/"]
print "Server actif sur le port :", PORT

httpd = server(server_adress,handler)
httpd.serve_forever()
