#!/usr/bin/python3
# -*- coding: utf-8 -*

import cgi 

form = cgi.FieldStorage()
print("Content-type: text/html; charset=utf-8\n")


html = """<!DOCTYPE html>
<head>
    <title>Server</title>
</head>
<body>
    Index
</body>
</html>
"""

print(html)
