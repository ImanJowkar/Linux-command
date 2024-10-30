#!/bin/bash

read -p "Which port you want to restirct it? " port
sudo iptables -F
for ip in `cat ip`
do
        sudo iptables -t filter -A INPUT -p tcp --dport $port -s $ip -j DROP
done

sudo iptables -nvL INPUT