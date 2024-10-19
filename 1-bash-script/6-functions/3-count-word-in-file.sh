#!/bin/bash

lines_in_files () {
	grep -c "$1" "$2"
}

n=$(lines_in_files "usb" "/var/log/dmesg")
echo $n
