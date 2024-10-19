#!/bin/bash

echo "Displaying the contents of $1"
sleep 2

cat $1

echo 
echo "Compressing $1"
sleep 2
tar -czvf "$1.tar.gz" $1
