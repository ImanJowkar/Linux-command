#!/bin/bash

for ip in $(cat ips.txt)
do
	echo "Dropping packets form $ip"
	iptables -I INPUT -s $ip -j DROP
done

