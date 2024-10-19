#!/bin/bash


my_str="asdf"

if [[ -z "$my_str" ]]
then
	echo "String is zero length."
else
	echo "String is not zero lenght"
fi


if [[ -n "$my_str" ]]
then
	echo "String is not zero length."
else
	echo "String is zero lenght."
fi
