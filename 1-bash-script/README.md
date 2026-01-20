# bash-script

This [refrence](https://www.cyberithub.com/category/scripting/bash/) have useful bash excersize and best practice for learning bash

## add comment in the begining of the bash file

```sh
# Auther: x
# Date: 2021
# description: ssss
# usage: ./app.sh
```


## variables
```sh
alias # show all aliases which defined in the OS

# create alias
alias ssn='systemctl status nginx'



vim /etc/bashrc
----
alias kgp='kubectl get pod'
alias ssp='systemctl status postgresql-18'
alias net-reset='nmcli networking off; nmcli networking on'

----

source /etc/bashrc # or run bash
type net-reset
unalias ssp

rpm -qf `which timescaledb-tune`  # show which package added timescaledb-tune in our system
rpm -qf `which timescaledb-parallel-copy`
rpm -qf `which zabbix_agent2`
rpm -qf `which zabbix_get`


# function
vim app1.sh
------
#!/bin/bash
hello() {
        echo Hello $USER welcom to linux bash script
}
hello
------
./app1.sh

# when open new bash, first ~/.bashrc  will run  and then this file will run /etc/bashrc 

# if you want to know how long do it takes the script you can use time before running a script
time ./app1.sh



name=jack
age=32

os="Windows"
echo ${os}11

x=1 y=2 z=4
echo $x
echo $y
echo $z


out=`ls -lah`
echo $out


multi_var="$name $age"
echo "THis is multi-var: ${multi_var}"

echo "Hi $name, You are $age years old"

# constant variables > you can't set or delete this type of variables
declare -r var="This is constant variables"
echo $var

var="change me"
unset var



# read data from user and store it in a variable
read -p "Enter the IP address of domain to block: " IP
sudo iptables -I INPUT -s $IP -j DROP
echo "The packets from $IP will be dropped"

# read secret data
echo "Enter your password:"
read -s password
echo $password



var1=osLINx
echo ${var1}
echo ${var1^^}   # upper
echo ${var1,,}   # lower
echo ${var1~~}   # invert


# array
NAME[0]="Iman"
NAME[1]="Jafar"
NAME[2]="Gheysar"

echo ${NAME[1]}


for n in ${NAME[@]}
do 
echo $n
done


# number of char in a text
txt="asdwegdfhrtyu"
echo ${#txt}

```


## arithmatic 

```sh
num=2
echo $(( $num + 2))



let a=2+12
echo $a 



let "a = 2 + 3"
echo $a 


let a++
echo $a

let a--
echo $a

let "a = 47 * 5"
echo $a


num=$( expr 2 + 2)
echo $num



```


## Positional Parameters

```sh
echo $0   # is the name of the script itself (script.sh)
echo ${1:-default_value}   # is the first positional argument (filename1)
echo ${1:--100}   # is the first positional argument (filename1)
echo $2   # is the second positional argument 
echo $3   # is the last argument of the script
echo $9   # would be the ninthe argument and ${10} the tenth
echo $#   # is the number of the positional arguments


echo "$*" # is a string representation of all positional arguments: $1, $2, $3
echo $@   # same as above


echo $?   # is the most recent foreground command exit status
echo $$   # give the process ID of the shell


```


## conditions

```sh


test # specifiy a variable which is empty or not

test -z $var
echo $?

---------------------
#!/bin/bash

num=1

if [[ -z $num ]]; then

        echo "variable num is empty..."
else
        echo "variable num is not empty..."
fi
------------------------





# inline if

if test -z $name; then echo "empty variable"; fi


if test -z $name; then echo "empty variable"; else echo "variable not empty"; fi

cat /etc/passwd | cut -d ":" -f1

----------------
#!/bin/bash

print_style () {

    if [ "$2" == "info" ] ; then
        COLOR="96m";
    elif [ "$2" == "success" ] ; then
        COLOR="92m";
    elif [ "$2" == "warning" ] ; then
        COLOR="93m";
    elif [ "$2" == "danger" ] ; then
        COLOR="91m";
    else #default color
        COLOR="0m";
    fi

    STARTCOLOR="\e[$COLOR";
    ENDCOLOR="\e[0m";

    printf "$STARTCOLOR%b$ENDCOLOR" "$1";
}




if [[ $# -eq 1 ]]
then


	if [[ -f $1 ]]
	then
		print_style "\n you enter a file , so i want to print the content of this file" "info";
		sleep 1
		cat $1
	elif [[ -d $1 ]]
	then	
		print_style " \n you enter a directory so i want to list the detial of this dir , running 'ls -l' ..." "info";
		sleep 1
		ls -l $1

	else
		print_style "The argument ($1) is neither a file nor a directory." "warning";


	fi
else
	echo "The script should be run with an argument. "
	echo "Note that, Input can be a file or a directory"
fi


###############################
# double brakets
read -p "Enter your age: " age

if [[ $age -lt 18 ]] && [[ $age -ge 0 ]]
then
	echo "You are kid!"

elif [[ $age -eq 18 ]]
then
	echo "hey, you are a young man boy."

elif [[ $age -gt 18 ]] && [[ $age -le 100 ]]
then
	echo "You are old."
else
	echo "Ivalid age."
fi


##########################
# single brakets


read -p "Enter your age: " age

if [ $age -lt 18 -a $age -ge 0 ]
then
	echo "You are kid!"

elif [[ $age -eq 18 ]]
then
	echo "hey, you are a young man boy."

elif [ $age -gt 18 -a $age -le 100 ]
then
	echo "You are old."
else
	echo "Ivalid age."
fi


```



## compare string

```

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



# Check a word exist in a sentence: 

str1="Linux is a widely-used open-source operating system kernel that serves as the foundation for various Linux distributions, such as Ubuntu, Fedora, and Debian. Developed by Linus Torvalds in 1991, Linux is known for its stability, security, and flexibility, making it a popular choice for servers, supercomputers, embedded systems, and personal computers. Linux is characterized by its robust command-line interface, which allows users to interact with the system efficiently and perform a wide range of tasks. With a strong emphasis on community-driven development and collaboration, Linux has fostered a vibrant ecosystem of software and support, empowering users to customize their computing environments to suit their specific needs."

if [[ "$str1" == *linux* ]]
then
	echo "The substring linux is there."
else
	echo "The substring linux is not there."
fi










# check for empry string

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


----------------------------
# bad input
#!/bin/bash

num=1

if [[ $# -ne 2 ]]; then

        echo "bad input"
        echo "usage: $0 <dir> <file>"
        exit 1
fi

dir=$1
file=$2
path=${dir}/${file}

if [[ ! -d dir ]]; then
        mkdir $dir || { echo "can't create ${dir} "; exit 1; }
fi


if [[ ! -f $path ]]; then
        touch $path || { echo "can't create ${path} "; exit 1; }
fi


```





## loops

```

for name in apple iman jafar ehsan  "test"
do
	echo "name is: $name"
done


###################################

for i in {1..41}
do
	echo "number: $i"
done

###################################

for i in {10..400..50}
do
	echo "We are in iterate: $i"
done

###################################

# show number of line in each file in current directory
for item in ./*
do
        if [[ -f "$item" ]]
        then
                echo "Number of line in $item is: $(wc -l $item)"
                sleep 1
                echo "###########################################"
        fi
done



##############################

# inline for loop

for i in {1..3}; do echo $i; done
for i in `ls`; do cat $i && sleep 3; done










###################################

for file in *.py
do
        mv "$file" "rename_$file"
done







######################################
# c style for loop

for ((t=0;t<=20;t++))
do
        echo "t = $t"
done



#######################################
:"
This app drop incoming connection from below ip
"

DROPPED_IPS="8.8.8.8 1.1.1.1 4.4.4.4"

for ip in $DROPPED_IPS
do
        echo "Dropping packets from $ip"
        iptables -I INPUT -s $ip -j DROP
done



############################################
# drop ip from file

for ip in $(cat ips.txt)
do
	echo "Dropping packets form $ip"
	iptables -t filter -I INPUT -s $ip -j DROP
done


###############################################

# while loop

b=0

while [[ $b -lt 10 ]]
do
	echo "b: $b"
	((b++)) # let b=b+1
done



#######################################################

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


#############################################################

while true 
do
	read -p "Enter The process name: " proc
	output="$(pgrep $proc)"
	if [[ -n "$output" ]]
	then
		echo "The proccess \"$proc\" is running."
		echo "The pid of the proccess is \"$output\" "
		echo "##############"
	else
		echo "The proccess \"$proc\" is not running"
	fi
	sleep 3
done





# until 

until false
do
        echo "hello"
        sleep 1
done







```

## case statement

```
read -p "Enter your name: " name

case "$name" in 
	iman|Iman|IMAN)
		echo "your name is Iman"
		;;
	ali|Ali|ALI)
		echo "your name is ali"
		;;
	*)
		echo "Your name is not in my database"
esac

####################################

if [[ $# -ne 2 ]]
then
	echo "Running The script with 2 arguments: Signal and PID."
	exit
fi

case "$1" in
	1)
		echo "Sending the SIGHUP signal to $2"
		kill -SIGHUP $2
		;;
	2)
		echo "Sending the SIGINT signal to $2"
		kill -SIGINT $2
		;;
	15)
		echo "Sending the SIGTERM signal to $2"
		kill -15 $2
		;;
	*)
		echo "Signal Number $1 will not be delivered"
		;;
esac



```

## functions

```
function echo_name () {
	echo "This is a simple function"
}




# another way to define funciton

echo_name () {
	echo "this is a simple function"
}

echo_name



##############
# count a word in a file

lines_in_files () {
	grep -c "$1" "$2"
}

n=$(lines_in_files "iman" "/home/iman/name")
echo $n

####################

# variable scope


var1="XXXXXXXX"
var2="YYYYYYYY"


echo "Before calling func1: var1=$var1, var2=$var2"

func1() {
	var1="AAAAAAAA"
	echo "Inside func1: var1=$var1, var2=$var2"
}

func1

echo "After calling func1: var1=$var1, var2=$var2"


echo "######################################################"

var1="XXXXXXXX"
var2="YYYYYYYY"


echo "Before calling func2: var1=$var1, var2=$var2"

func2() {
        local var1="AAAAAAAAAAA"
        echo "Inside func2: var1=$var1, var2=$var2"
}

func2

echo "After calling func2: var1=$var1, var2=$var2"


## return a value in function 


# solution 1
----------------------------
#!/bin/bash

add(){

        a=$1
        b=$2
        z=$(( $a * $b ))
}


add 2 3
echo $z
-----------------------------------



# solution 2
----------------------------------
#!/bin/bash



add(){

        a=$1
        b=$2
        local z=$(( $a * $b ))
        echo $z
}


output=`add 2 3`
echo $output


# add function
###################################
#!/bin/bash

add() {

        sum=0
        for i in "$@"
        do
                #echo "$sum + $i : $(( $sum + $i ))"
                sum=$(( $sum + $i ))
        done
        echo "$sum"
}

add $@

resutl=`./app-add.sh 3 32  5 2 3 6 2 5 8 `

#######################################





---------------------------------




```


## Services
#### example-1
in linux we have 11 types of unit that systemd control them.
```

systemctl status zabbix-server.service
systemctl cat zabbix-server.service
systemctl list-units --type service



########################################## 

#!/bin/bash

ping -c 4 yahoo.com >>/dev/null 2> /dev/null
if [[ $? -eq 0 ]]
then
        echo "Connected to the Internet, OK!."
else
        echo "your server is not connected to the Internet, Fail."
fi
sleep 1

#################################################

cat >> /etc/systemd/system/net-check.service << EOF

[Unit]
Description="When calling this app, it check net connectivity of your server."
After=network.target



[Service]
User=root
ExecStart=/root/1-check-net-connectivity.sh
#Restart=always


[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemd-analyze verify net-check.service
systemctl enable net-check.service --now
systemctl status net-check.service
journalctl -u net-check.service
journalctl -f -u net-check.service



## now create a timer
vim /etc/systemd/system/net-check.timer

#############
[Timer]
OnCalendar=*-*-* *:*:00/20
Unit=net-check.service
#############


systemd-analyze verify net-check.timer
systemctl daemon-reload
systemctl start net-check.timer

```

#### example-2

```
######################################
#!/bin/bash

PERCENTAGE=80

disk_usage=`df -Ph | egrep '/dev/mapper' | awk '{print $5}' | sed s/%//g`

if [ $disk_usage -ge $PERCENTAGE ];
then
	echo "the root location approximately full"
else
	echo "ok"
fi
##########################################



cat >> /etc/systemd/system/disk-usage.service << EOF

[Unit]
Description="When calling this app, it check the root disk usage"
After=network.target



[Service]
User=root
ExecStart=/root/disk-check.sh
#Restart=always


[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemd-analyze verify disk-usage.service
systemctl enable disk-usage.service --now
systemctl status disk-usage.service
journalctl -u disk-usage.service
journalctl -f -u disk-usage.service



## now create a timer
cat >> /etc/systemd/system/disk-usage.timer << EOF
[Timer]
OnCalendar=*-*-* *:*:00/20
Unit=disk-usage.service
EOF

systemd-analyze verify disk-usage.timer
systemctl daemon-reload
systemctl start disk-usage.timer


dd if=/dev/zero of=/root/file1 bs=1M count=5000

```

#### example-3-python

```
##########################

#!/usr/bin/env /root/vevn/bin/python


import shutil
from hurry.filesize import size
from colorama import Fore
du = shutil.disk_usage("/")
print(du)
total = int(size(du.total).replace("G", ""))
used = int(size(du.used).replace("G", ""))


print(f"total disk is: {total}G")
print(f"total disk usage is {used}G")
if total - used < 10:
    print(Fore.RED + 'Pay attention, your root partition is going to be full !!!!!!!!')
else:
    print(Fore.GREEN + f"feel free, your root partition is free. you have {total-used}G free")

##########################


cat >> /etc/systemd/system/disk-usage-python.service << EOF
[Unit]
Description="When calling this app, it check total disk usage."
After=network.target



[Service]
User=root
ExecStart=/root/app.py
#Restart=always


[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemd-analyze verify disk-usage-python.service
systemctl enable disk-usage-python.service --now
systemctl status disk-usage-python.service
journalctl -u disk-usage-python.service
journalctl -f -u disk-usage-python.service



## now create a timer
cat >> /etc/systemd/system/disk-usage-python.timer << EOF
[Timer]
OnCalendar=*-*-* *:*:00/20
Unit=disk-usage-python.service
EOF



systemd-analyze verify disk-usage-python.timer
systemctl daemon-reload
systemctl start disk-usage-python.timer


```


## find

```

# we have two option for finding a file in linux: 1-locate, 2-find
# 'locate' is faster than a 'find', because it use a database which we need update it constantly


# locate
apt install mlocate                             # install locate
sudo updatedb                                   # update database

locate file_name
locate admin

locate -i file_name                             # it isn't case sensetive



# find ----> find search in realtime, therefor it is more slower than locate

find . -name file.txt                           # search "file.txt" in . directory
find . -iname file.txt                          # case insensetive
find . -name "file.*" -delete                   # find "file.*" and delete all of them
find /etc/ -name shadow                         # search for "shadow" in /etc/ directory


find /etc/ -type d                              # show all directory in /etc
find /etc/ -type d -maxdepth 2                  # show directory in /etc/ which have depth=2
find /etc/ -type d -maxdepth 2 -perm 755        # find by permision
find /etc/ -type d -size +100K -ls              # find the dirctory more than 100K size
find /etc/ -type d -size +10M -ls
find /etc/ -type f -size +5M -size -10M

find /var/ -type f -mtime 0 -ls                 # show file which modified in one day past
find /var/ -type f -mtime 1 -ls                 # show file which modified in two day past
find /var/ -type f -mmin -60 -ls                 # show file which modified in 60 minute past
find /var/ -type f -user iman -ls
find /etc/ -type f -not -group root -ls



find / -size +10M

```


## redierct

```

ssh -V &> version.txt



```



## how to import another bash-script in another file

```
in the destination bash-script file use `source ~/app/old-bash.sh`


!#/bin/bash

source ~/home/test/app.sh



a=1
b=3
```



## tr 

```
echo "Iman Jowkar" | tr "[:lower:]" "[:upper:]"
 echo "Ila;sdfj@#4sldkfjar" | tr -dc "a-zA-Z0-9"


```


## array

```
arr=(iman sama hos fat)

for names in ${arr[@]};
do 
	echo $names
done


```

## random number

```
 echo $(( RANDOM%5 )) # get random number between 0 5


 echo $(( RANDOM%6 )) # get random number between 0 6

```


## menu

```
#!/bin/bash

PS3="Choose fruits: "
select fruit in Apple Benana x y "this is " Quit
do
	echo "fruit is $fruit"
	echo "Reply is $REPLY"

	case $REPLY in
		1)
			echo "You love Apple"
			;;
		2)
			echo "You love Benana"
			;;
		3)
			echo "you love x"
			;;
		4)
			echo "you love y"
			;;
		5)
			echo "you love sdf"
			;;
		6)
			echo "Quitting"
			sleep 1
			break
			;;
		*)
			echo "bad input!!!"
			;;
	esac
done 




```

## options

```
# getopts


```



## parameter expantion

```
#!/bin/bash
var1=${1:-66}
echo "this is var: $var1"


echo "the number of aurgument which you enter it: "$#

var2=${2:?"Enter 2 argument"}
echo "The second element is : $var2"




echo "the length of second argument is: ${#2}"


```





## awk

```
awk '{print $0}' date-rand.txt      # print all things in this file
awk '{print $1}' date-rand.txt      # print column 1
awk '{print $2"\t"$1}' date-rand.txt      # print column 2

awk -v var=$USER 'BEGIN{printf "%s\n", var}' random-num-str.txt


# run when awk command stored in a file
awk -f com random-num-str.txt

# send variable into the awk
awk -v var1="value1" -v var2="value2" '{ print var1, var2, $0 }' input_file.txt



# find most cpu usage
threshold=60
ps -ax --sort=-%cpu --format pid,ppid,%cpu,%mem,cmd | awk -v threshold=$threshold '$3 > threshold { print $0 }'




cat >> input_file.txt << EOF
3 3 4 6 8 54 23
2 3 456 65 45 45 32
3 3 2 6 8 24 29
2 3 45 65 75 45 32
3 3 4 6 8 54 23
2 3 76 65 46 45 32
3 3 4 6 8 54 23
2 3 45 65 45 4 32
EOF


cat input_file.txt  | awk '{ if ( $6 >= 50 ) print $0 }'



# find duplicated files and remove them in a directory
find . -type f -exec sha1sum {} + | sort | awk '{if($1 == previous){print $2} else{previous=$1}}' | xargs rm -f


```


## grep 

```
cat input_file.txt | grep -e "patter2" -e "pattern1"

```







## curl 

```
servername=https://google.com
response=$(curl --write-out '%{http_code}' --silent --output /dev/null $servername)
echo $response

```


## sed

```




```



# most bash-script question interview

1. how you would use awk to process a text file and extract specific columns of data.

```
cat >> input_file.txt << EOF
3 3 4 6 8 54 23
2 3 456 65 45 45 32
3 3 2 6 8 24 29
2 3 45 65 75 45 32
3 3 4 6 8 54 23
2 3 76 65 46 45 32
3 3 4 6 8 54 23
2 3 45 65 45 4 32
EOF


cat input_file.txt  | awk '{ if ( $6 >= 50 ) print $0 }'



```

2. Describe the difference between `$@` and `$*` in a Bash script.

```

echo "$*" # is a string representation of all positional arguments: $1, $2, $3
echo $@   # same as above

```

3. How can you run a command in the background and capture its output to a variable?

```
output=$(cat /etc/passwd &)

```

4. Explain how you would handle errors in a Bash script.

```
resize2fs /dev/myvg/mylv
if [ $? -ne 0 ]; then
    echo "Command failed"
    exit 1
fi


```

5. How would you check if a file exists and is writable in Bash?

```
if [ -f "$file" ] && [ -w "$file" ]; then
    echo "File exists and is writable"
fi


```

6. how to pass an array to a function in Bash.

```
my_function() {
    local -n arr=$1
    echo "${arr[@]}"
}
arr=(1 2 3)
my_function arr


```

7. How can you append text to a file only if the text doesn't already exist in the file?

```
grep -qxF 'text' file.txt || echo 'text' >> file.txt


```

8. How do you ensure that a script runs with root privileges?

```
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi


```