#!/usr/bin/python

# This python script queried our asset management system (Asset Tracker, a plugin for Request Tracker - a ticketing system) and gave me valuable information back quickly about a machine. In a large enterprise environment, it is impossible to know where everything is by heart, so this allowed me to quickly look it up with arguments for multiple inputs / output types.

# importing argparse to determine input and sys to run RT commands from the cli

import argparse
import subprocess as sp
import re

parser = argparse.ArgumentParser(description='Convert Server info to ids for easy AT management')

parser.add_argument('--name', help='Hostname Lookup')
parser.add_argument('--serial', help='Serial Number lookup')
parser.add_argument('--assettag', help='Asset Tag lookup')
parser.add_argument('--onlyid', action='store_true', help='Prints only the numerical ID, and not the asset/ prefix')
parser.add_argument('--location', action='store_true', help='Prints the location of the asset')

args = parser.parse_args()

name = args.name
serial = args.serial
assettag = args.assettag
onlyid = args.onlyid
location = args.location
name = args.name



if name:
    option = 'Name'
    inp = name
if serial:
    option = 'CF-SerialNumber'
    inp = serial
if assettag:
    option = 'CF-AssetTag'
    inp = assettag.strip()
if name:
    option = 'Name'
    inp = name.strip()

def rt_lookup(option, inp):
    id = sp.Popen(['rt', 'ls', '-t', 'asset', '-i', '%s like "%s"' % (option, inp)], stdout=sp.PIPE, stderr=sp.PIPE)
    strofid = str(id.communicate()[0])
    
    #strofonlyid = re.sub('asset/', '', strofid.strip())
    if "asset" in strofid:
        if onlyid:
            print(re.sub('asset/', '', strofid.strip()))
        else:
            print(strofid).strip()
    else:
        print("Nothing found for %s %s" % (option, inp)).strip()
    
    if location:
        locator = sp.Popen(['rt', 'show', '-f', 'CF-Rack,CF-RmuLoc', '%s' % (strofid)], stdout=sp.PIPE, stderr=sp.PIPE)
        stroflocation = str(locator.communicate()[0])
        print(stroflocation)

    


rt_lookup(option, inp)
