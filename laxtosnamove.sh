#!/bin/bash

# This script was used for asset management when we had a datacenter move. This was just a way for me to batch change a bunch of parameters on all of our assets that were moving, with a log to track changes (just in case). Of course this was followed up by a full audit of on-prem assets to confirm everything was moved and documented properly.

dt=$(date +"%Y.%m.%d %H:%M:%S")

MOVElog="/home/ctajii/logs/"$dt"_laxtosnamove.log"
echo "Enter your RT password"
read -s mypass

touch $MOVElog
export RTUSER=REDACTED
export RTPASSWD=$mypass
export RTSERVER=http://rt.REDACTED.com

while read idtag rack rmuloc
  do
    # This line is for if we want to use the asset tag numbers instead of internal IDs of assets - it converts the asset tag to the ID tag which is how we the assets.
    #idtag=$(rt ls -t asset "CF-AssetTag like '$assettag'" | awk '{print $1}' | sed s/://)
    echo "idtag is $idtag" | tee -a $MOVElog
    rt edit "asset/$idtag" set Status=InService | tee -a $MOVElog
    rt edit "asset/$idtag" set CF-ROOM=DC-02 | tee -a $MOVElog
    rt edit "asset/$idtag" set CF-Site=SNA | tee -a $MOVElog
    rt edit "asset/$idtag" set CF-Rack=$rack | tee -a $MOVElog
    rt edit "asset/$idtag" set CF-RmuLoc=$rmuloc | tee -a $MOVElog
    rt edit "asset/$idtag" set CF-OOSReason="" | tee -a $MOVElog
