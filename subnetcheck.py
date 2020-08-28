#!/usr/bin/python

# This was a bit of a weird script, but I think it shows a good example of how I come up with... Unique solutions to problems I'm having. I had multiple of these running in cron jobs on a host so I could check what our IP space looked like. It helped find new IPs to use when we were provisioning, and helped clean up DNS.

# Basically it printed these things to a file, which I then converted to HTML in another script (Lost it somewhere). It was basically just a webpage giving me a quick glance at what IPs were available, which were used (but maybe the host didn't exist anymore), etc. I always just used this as a first glance and double checked everything before making DNS chagnes, but it was nice to have as a first point of reference.


import subprocess
import sys

sys.stdout = open('ips.txt', 'a+')
for ping in range(2,254): 
    address = "10.24.33." + str(ping) 
    res = subprocess.call(['ping', '-c', '2', address])
    if res == 0: 
        
        print "Used", address
    else: 
        hostcheck = subprocess.call(['host', address])
        if hostcheck == 0:
            print "Hostname but no ping", address
        else:
            print "Available", address
