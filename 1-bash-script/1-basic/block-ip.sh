#!/bin/bash

read -p "Enter Ip address which you want to block: " IP

iptables -t filter -A INPUT -s $IP -j DROP


