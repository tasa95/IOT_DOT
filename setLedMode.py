#!/usr/bin/env python
# -*- coding: utf-8 -*

import cgi
import subprocess
import os
path = os.path.dirname(os.path.abspath(__file__))
form = cgi.FieldStorage()
print("Content-type: text/html; charset=utf-8\n")
print(form.getvalue("mode"))
mode = form.getvalue("mode")
if mode is not None:
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
