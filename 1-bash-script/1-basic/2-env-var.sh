#!/bin/bash
filename="/etc/passwd"

echo "Number of line in The $filename file"
wc -l $filename



echo "########################"
echo "First 10 line in $filename"
head -n 10 $filename




echo "########################"
echo "Last 7 Lines: "
tail -n 7 $filename




env

printenv
printenv HOME
printenv USER
printenv HOME USER 


set         # show all environment variable
set | grep HOME         


# if you want to define a variable which always available for specific user add to the .bashrc file


vim .bashrc

--------------
testt="testtsert"
--------------




# set environment variable in global mode available for all user
vim /etc/environment
--------------
myname="iman"
--------------

