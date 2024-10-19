#!/bin/bash

read -p "Enter the IP address of domain to block: " IP

sudo iptables -I INPUT -s $IP -j DROP

echo "The packets from $IP will be dropped"


read -s -p "Enter you password: " # usefull for reading secret input.

