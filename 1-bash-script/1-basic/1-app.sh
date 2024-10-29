#!/bin/bash
: '
This is multi line comment

# '


# alias
alias   # show all aliases

alias ports="netstat -ntlp"
ports
alias c='clear'

# for persistent alias 
------
vim .bashrc
# add below line to this file
alias c='clear'
alias ports="netstat -ntulp"
-------

source ~/.bashrc

# remove alias
unalias ports




# define Variables
name=jack
age=32

os="Windows"
echo ${os}11


multi_var="$name $age"
echo "THis is multi-var: ${multi_var}"

echo "Hi $name, You are $age years old"


# const variables > you can't set or delete this type of variables
declare -r var="This is constant variables"
echo $var

var="change me"
unset var
