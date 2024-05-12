#!/bin/bash


iptables -F

# change default policy
iptables -t filter -P INPUT DROP
iptables -t filter -P OUTPUT DROP


# allow from loopback interface
iptables  -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT


# allow tcp
iptables -t filter -A INPUT -p tcp -j ACCEPT
iptables -t filter -A OUTPUT -p tcp -j ACCEPT

# allow udp
iptables -t filter -A INPUT -p udp -j ACCEPT
iptables -t filter -A OUTPUT -p udp -j ACCEPT
