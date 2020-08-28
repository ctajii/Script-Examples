#!/bin/bash

# This script set the IDRAC NIC configuration for a batch of hosts read from a csv. It also deleted the history from the $history command since the password was written in here in plain text in order to set it properly.

#	For this, $1 needs to be a text file with a hostname and ip parameters. You can edit this as shown below to have it change multiple
#	dracs on different subnets with different gateways at a time - I suppose that may be a better way to do it but this is how i wrote it
#	*shrug*

while read host dracip

	do
		#set netmask and gateway for set of hosts you're changing, or you can create the document to read from with these and add vars
		ssh -t $host "sudo racadm setniccfg -s $dracip 255.255.254.0 10.200.252.1; sudo racadm set iDRAC.Users.2.Password REDACTED"
		ssh -t $host "history | grep 'racadm set iDRAC.Users.2.Password'" | awk '{ print $1 }' | sort -rn > racadmhist.txt ; for i in $(cat racadmhist.txt); do history -d $i; done"
	done
