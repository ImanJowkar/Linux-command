#!/bin/bash

read -p "Enter something: " var1
read -p "Enter The same: " var2

while [ "$var1" != "$var2" ]
do
	echo "I said Enter The same thing :(, Enter again."
	read -p "Enter something: " var1
	read -p "Enter The same: " var2
done

echo "well done."
echo "Good Neight.:))))"
