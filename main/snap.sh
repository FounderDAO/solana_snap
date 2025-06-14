#!/bin/bash

#export LC_NUMERIC="en_US.UTF-8"
if [ -n "$1" ]
then
 pabkey=$1
else
 echo "NO TRASTED PABKEY"
 exit
fi
echo $pabkey
ip=0
ip=$(solana gossip | grep $pabkey | awk '{print $1}')":8899"
echo $ip

if [ -n "$2" ]
then
 path=$2
else
 path=/mnt/disk2/snapshots
fi
#echo $path
#exit
if [ ! -d "/mnt/disk2/snapshots/" ]; then
    mkdir -p /mnt/disk2/snapshots/
fi

cd /mnt/disk2/snapshots/
wget --trust-server-names -P http://$ip/snapshot.tar.bz2

if [ ! -d "/mnt/ramdisk/incremental_snapshots/" ]; then
    mkdir -p /mnt/ramdisk/incremental_snapshots/
fi

cd /mnt/ramdisk/incremental_snapshots/
wget --trust-server-names -P "$path" http://$ip/incremental-snapshot.tar.bz2

cd /root/solana/

make reload && make start
