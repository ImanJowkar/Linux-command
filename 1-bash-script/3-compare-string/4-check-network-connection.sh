#!/bin/bash


read -p "Enter the server IP: " SERVER
output="$(ping -c 3 $SERVER)"
#echo "$output"


if [[ "$output" == *"100% packet loss"* ]]
then
	echo "The network connection to $SERVER is not working."
else
	echo "The network connection to $SERVER is working"
fi
