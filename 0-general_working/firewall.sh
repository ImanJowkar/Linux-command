#!/bin/bash

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -F

# INPUT
iptables -t filter -A INPUT -i ens33 -p tcp --dport 22 -s 192.168.229.1 -j ACCEPT
iptables -t filter -A INPUT -i ens33 -p tcp --dport 22 -m time --timestart 18:00 --timestop 19:02 -s 192.168.229.167 -j ACCEPT





# OUTPUT
iptables -t filter -A OUTPUT -o ens33 -p tcp --sport 22 -d 192.168.229.1 -j ACCEPT
iptables -t filter -A OUTPUT -o ens33 -p tcp --sport 22 -m time --timestart 18:00 --timestop 19:02 -d 192.168.229.167 -j ACCEPT


iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

