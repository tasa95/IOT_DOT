#!/bin/bash
echo "$(/sbin/ifconfig wlan0 |/bin/sed -En 's/127.0.0a.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')"
