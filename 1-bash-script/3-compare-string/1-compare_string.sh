#!/bin/bash

read -p "String1: " str1
read -p "String2: " str2

if [ "$str1" = "$str2" ]
then
	echo "The strings are equal."

else
	echo "The strings are not equal."
fi

######################################
if [[ "$str1" == "$str2" ]]
then
        echo "The strings are equal."

else
        echo "The strings are not equal."
fi
#####################################

if [[ "$str1" != "$str2" ]];then
	echo "The strings are not equal."
fi

##########################################

