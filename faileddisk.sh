#!/bin/bash
#	This script identifies bad disks using racadm (dell remote access commands through IDRAC)


#   Use this to identify which disks have gone bad on a system and pull the disk details

ssh -t $1 "for d in {0..3}; do for i in {0..12} ; do \/opt\/dell\/srvadmin\/bin\/omreport storage pdisk controller=0 pdisk=0:\$d:\$i | egrep -q Critical && \/opt\/dell\/srvadmin\/bin\/omreport storage pdisk controller=0 pdisk=0:\$d:\$i | grep '^ID\|^Status\|^State\|^Bus Protocol\|^Failure Predicted\|^Certified\|^Capacity\|^Vendor ID\|^Product ID\|^Serial No.\|^Negotiated Speed\|^Capable Speed'; done; done"
