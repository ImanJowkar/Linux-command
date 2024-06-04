#!/bin/bash

ping -c 4 yahoo.com >>/dev/null 2> /dev/null
if [[ $? -eq 0 ]]
then
        echo "Connected to the Internet, OK!."
else
        echo "your server is not connected to the Internet, Fail."
fi
sleep 1