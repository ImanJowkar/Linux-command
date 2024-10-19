#!/bin/bash

i=0

while [[ $i -lt 10 ]]
do
	echo "i: $i"
	((i++)) # let i=i+1
done

