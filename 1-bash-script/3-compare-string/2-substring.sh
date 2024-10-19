#!/bin/bash

str1="Ubuntu is one of the distro of Linux which is the most favorite distro in the world."

if [[ "$str1" == *linux* ]]
then
	echo "The substring linux is there."
else
	echo "The substring linux is not there."
fi
