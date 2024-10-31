#!/bin/bash

TR=80
df -h --output=source,pcent | tail -n +2 | while read line;
do
        filesystem=$(echo $line | awk '{print $1}')
        usage=$(echo $line | awk '{print $2}' | tr -d '%d')

        if [ $usage -ge $TR ];
        then
                echo "warning: Disk usage of $filesystem is at $usage%"
        fi
done