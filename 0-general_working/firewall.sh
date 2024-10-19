#!/bin/bash

# allow loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

# Flush All Tables
iptables -t filter -F
iptables -t mangle -F
iptables -t nat -F
iptables -t raw -F


# Configure SSH
iptables -t filter -A INPUT -p tcp --dport 22 -s 172.16.2.166 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 22 -j DROP

