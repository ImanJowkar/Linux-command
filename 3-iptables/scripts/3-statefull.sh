#!/bin/bash


iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT

iptables -t filter -A INPUT -p tcp --dport 22 -m state --state NEW -s 10.10.10.1 -j ACCEPT

iptables -t filter -A INPUT -m state --state INVALID -j DROP
iptables -t filter -A OUTPUT -m state --state INVALID -j DROP




iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


iptables -t filter -P INPUT DROP
iptables -t filter -P OUTPUT DROP