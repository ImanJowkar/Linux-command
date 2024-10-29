#!/bin/bash

# Positional Parameters

echo $0   # is the name of the script itself (script.sh)
echo ${1:-default_value}   # is the first positional argument (filename1)
echo ${1:--100}   # is the first positional argument (filename1)
echo $2   # is the second positional argument 
echo $3   # is the third argument of the script
.
.
.
echo $9   # would be the ninthe argument and ${10} the tenth
echo ${10}   # would be the 10th argument and ${10} the tenth
echo ${11}   # would be the 11th argument and ${10} the tenth

echo $#   # is the number of the positional arguments


echo "$*" # is a string representation of all positional arguments: $1, $2, $3
echo $@   # same as above


app.sh
--------------------
for item in $@
do
    echo $item
done
-------------------
./app.sh 2 1 3 4 j 



echo $?   # is the most recent foreground command exit status
echo $$   # give the process ID of the shell



