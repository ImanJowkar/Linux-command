#!/bin/bash


while true 
do
	read -p "Enter The process name: " proc
	output="$(pgrep $proc)"
	if [[ -n "$output" ]]
	then
		echo "The proccess \"$proc\" is running."
		echo "The pid of the proccess is \"$output\" "
		echo "##############"
	else
		echo "The proccess \"$proc\" is not running"
	fi
	sleep 3
done

