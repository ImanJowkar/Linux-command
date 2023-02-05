#!/bin/bash
# This script is about configure iptables for securing ssh

# Set Default Policy
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# Flush All Tables
iptables -t filter -F
iptables -t mangle -F
iptables -t nat -F
iptables -t raw -F


# Delete User Defined chains
iptables -X



# Configure SSH
iptables -t filter -A INPUT -p tcp --dport 22 -s 172.16.2.166 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 22 -j DROP


# DROP ICMP packets
iptables -t filter -A INPUT -p icmp --icmp-type echo-request -j DROP

# Change default poliy to DROP
iptables -P INPUT DROP
