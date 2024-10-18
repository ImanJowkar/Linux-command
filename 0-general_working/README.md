
# figlet
```
sudo apt install figlet
figlet imanjowkar
```


# vim
```
dd          # delete a line 
d5          # delete line 5
u           # undo change
gg          # go to the begining of the file
G           # go to the end of the file
shift+A     # go to the end of a specefic line
0           # go to the begining of a specific line
:%s/find/replace/g  # find and replace globally

:set number         # enable line number
:%s/foo/xxx         # find "foo" and replace with "xxx"




```

### vim Configuration:
```
vim ~/.vimrc
# paste
set number
syntax enable
set autoindent
set cursorline


```


# User Permissions

```
adduser         # more intractive for create a user
deluser         # more intractive for delete a user
addgroup
delgroup



useradd         # low-level utilities for create user
userdel
groupadd
groupdel


usermod -aG group_name user_name    # for adding a user to a group
groups                              # show the list of groups which user are join to it





chown user:group file.txt   # change ownership of a file
chgrp group_name file.txt   # change group of a file


chmod u-x file.txt
chmod g-x file.txt
chmod o-x file.txt
chmod a-x file.txt


chmod u-rx file.txt
chmod g-rwx file.txt
chmod o+rw file.txt
chmod a-x file.txt

chmod g=rx file.txt



R       W       X

2^2     2^1     2^0

chmod 724 file > user: RWX, group: W, Other: R



# umask denfine default permision for a file, umask apply to a directory and after that any file we create on that directory got the umask permision


R       W       X
0       0       0


R       -       -
0       2^1     2^0     >> 3

umask 113 dirctory_1   >>   RW-RW-R--

# for security reasons it cannot be set x permision with umask





# Special Permission: 
SUID
SGID
StickyBit


```

# modules 
```
lsmod                               # print all modules which already added to kernel
modprobe module_name                # add module and requiremnt modules to kernel
modprobe -r module_name             # remove a modlue and all dependencies
insmod module_name                  # only add module and can't load requirement modules
rmmod module_name                   # remove a module from a kernel
modinfo module_name                 # get info of modules

# if you want to permenent loaded modules, add modules to "/etc/modules-load.d"


```





# file system

```
du -hs /etc/                         # how to size of /etc/ directory
stat /etc/passwd                     # give an information about the /etc/passwd file 


# tee
who | tee who.txt                      # show in terminal and save to a file
who | tee -a who.txt                   # show in terminal and append to a file



```

# finding file and directories

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
find / -type f                                  # find all files
find / -type d                                  # find all directoris
find . -iname file.txt                          # case insensetive
sudo find /etc -type f -name "*.conf"

find . -name "file.*" -delete                   # find "file.*" and delete all of them
find /etc/ -name shadow                         # search for "shadow" in /etc/ directory



find /etc/ -type d                              # show all directory in /etc
find /etc/ -type d -maxdepth 2                  # show directory in /etc/ which have depth=2
find /etc/ -type d -maxdepth 2 -perm 755        # find by permision



find /var/ -type f -size +100K -ls              # find the dirctory more than 100K size
find /var/ -type f -size +10M -ls
find /var/ -type f -size +5M -size -10M

find / -type f -perm 777

find /var/ -type f -mtime 0 -ls                 # show file which modified in one day past
find /var/ -type f -mtime 1 -ls                 # show file which modified in two day past
find /var/ -type f -mmin -60 -ls                 # show file which modified in 60 minute past
find /var/ -type f -user iman -ls
find /etc/ -type f -not -group root -ls




# find and execute a comand on each element 

sudo find / -type f -size +5M -exec ls -lah {} \;
find . -type f -name "text*"  -exec rm -rf {} \;


find / -type f -name "*.logs" -exec grep 'iman' {} \;

```


# Text Processing
### cat, cut, sed

```
cat file
cat -E file
cat -n file     # show line number

cat file | wc -l


# cut

file
-------------------------------------
hello this is my course on linux
linux is very good
-------------------------------------

cut -c 2-4 file                 # give the character 2-4
cut -c 2-4,6,7,9-11 file        # give the character 



data.csv
----------------------------------
name,age,city
user1,32,city1
user2,22,city2
----------------------------------
cat data.csv | cut -d"," -f 2
cat data.csv | cut -d"," -f 1


data
----------------------------------
name age city
user1 32 city1
user2 22 city2
----------------------------------
cat data | cut -d" " -f 2
cat data | cut -d" " -f 1




data
----------------------------------
name-age-city
user1-32-city1
user2-22-city2
----------------------------------
cat data | cut -d"-" -f 2
cat data | cut -d"-" -f 1



data
----------------------------------
name;age;city
user1;32;city1
user2;22;city2
----------------------------------
cat data | cut -d";" -f 2
cat data | cut -d";" -f 1





# Show all users in linux
cat /etc/passwd | cut -d":" -f 1


## sed

--------------------------------
hello this is my course on linux
linux is very good
--------------------------------
sed -e 's/find/replace/g' file

sed -e 's/linux/LPIC/g' file

# this is the ouput
--------------------------------
hello this is my course on LPIC
LPIC is very good
--------------------------------


## tr 

file
----------------------------
this is test
----------------------------

cat file | tr a-z A-Z

----------------------------
THIS IS TEST
----------------------------


```



### grep (text configurations)
```
grep iman /etc/passwd
grep "pattern" /etc/shadow
grep -i "SSH" /etc/ssh/ssh_config           # case insensitive

grep -in "ssh" /etc/..                      # case insensitive and show line number too

grep -v "pattern" /etc/..                   # inverted result
grep -c "pattern" /etc/...                  # sum of the result that match the condition

grep -A 3 -B 4 "pattern" /etc/..            # show 3 line after match and 4 line before match


```

# comparing files

```

# we have three way to compare files in linux: 1-cmp, 2-diff, 3-sha256sum or other hash function

cmp file1 file2
echo $? # if return 1, it means not eqal
        # if return 0, it means eqal

sha256sum a b   

diff file1 file2            # diff only used for files
diff -B file1 file2         # ignore blank line
diff -w a b                 # ignore space
diff -i a b                 # case insensitive
diff -y a b                 # pretty output




```


## hard link and soft link
![img](img/1.png)
```
# hard link, hard link only used for files
* hardlink only work with files
* hardlink only work on the same partition
* hardlink is a pointer to the inode on the disk
ln file1.txt file2.txt          


# sof link(symbol link)
# soft link, soft link can be used for both file and directory
* work on both file and directory
* can be use on multiple partitions
* softlink is a pointer to the file or directory not direct to the inode
ls -s file1.txt file2.txt       


```


# Process management

```

ps
ps -e
ps -f
ps -ef

ps -f -u root           # only show root process

ps aux --sort=%mem
ps aux --sort=-%cpu


pgrep python3
pgrep sshd                  # get process id

pgrep -l sshd               # get process id with service name





pidof sshd
pidof chrome



nohub ./app.sh                          # or we can use tmux


```

## how to secure ssh

```

1 - change default port from 22 to something else
2 - disable root login
3 - allowed only required user to connect to server via ssh
4 - enable iptables from specific IP
5 - use ssh version2
6 - ClientAliveInterval 300 and clientAliveCountMax 0


```
# tar and zip

```
tar -cvf backup.tar file1 file2 file3                   # tar the files
tar -tvf backup.tar                                     # only show which file is in the backup.tar
tar -xvf backup.tar                                     # untar the file


tar -zcvf backup.tar.gz file2 file3
tar -zxvf backup.tar.gz


```

# compression
[refrence](https://www.rootusers.com/gzip-vs-bzip2-vs-xz-performance-comparison/) for comparing these three method for compress files.
**tip**: before compres any file, first use tar and then use compres method
```
gzip -c file.tar > file.tar.gz                  # compression rate 60~70 %  > 100GB > 40 ~ 30 GB
gzip -d file.tar.gz                             # uncompress the file


sudo apt install bzip2
bzip2 file.tar
bzip2 -d file.tar.bz2


xz file.tar
xz -d file.xz

```

# SCP (Secure COPY)
```
scp -p 22 file.tar user@172.16.2.2:/home/user/backup/                           # for scp a file or tar file
scp -r -p 22 dirctory user@172.16.2.2:/home/user/backup/                        # for scp a dirctory

scp user@172.16.2.2:/home/user/backup/backup.tar user1@172.16.2.4:/home/user1/backup/   # scp from a server to another server

# you can use WinSCP for transfer file between linux and Windows 




rsync -avz  /path/to/local/directory username@remote_host:/path/to/remote/directory
sudo rsync -avzh /etc/ /home/user/etc-backup              # if target directory does not exist, rsync will be create for us



```


## iftop

```
sudo apt install iftop
iftop # show the network send and recived

sudo apt install iotop
iotop   # show the disk R/W status

```

# Nmap
nmap is a network discovery and security auditing tool, there are a variety scans that can be perform nmap, TCP SYN scan is the default and most popular scan option for good reason

```
sudo apt install nmap  # if you want to install nmap in windows you can install zenmap which is a GUI for nmap

sudo nmap IP_address
sudo nmap -sS IP_address

# by default nmap scan most common 1000 port for each protocol
nmap -p 22,50000 -sV IP_address

# if you want to sacn all port
nmap -p- IP_address


# for UDP scan
namp -sU localhost


```

# Disk

```
echo "- - -" | tee /sys/class/scsi_host/host*/scan



dd if=/dev/zero of=file1 bs=1M count=5000
dd if=/dev/urandom of=file1 bs=1M count=5000



## distory all data in a disk
sudo dd if=/dev/zero of=/dev/sdX bs=64K status=progress


## creating a bootable usb-drive
sudo dd if=/path/to/your.iso of=/dev/sdX bs=4M status=progress


# create a big file
dd if=/dev/zero of=bigfile bs=1M count=1024 status=progress




fdisk /dev/sdb   # used for MBR partition table.
gdisk /dev/sdb   # used for GPT partition table.




```





# lvm (logical volume management)
[ref](https://www.tecmint.com/create-lvm-storage-in-linux/)
```
bc      # terminal calculator


cat /proc/swaps
swapon -s


pvcreate /dev/sd[bc][12]
pvs
vgcreate myvg /dev/sd[bc][12]
vgs


lvcreate -n lv1 -L 6gib myvg
lvcreate -n lv2 -L 9gib myvg
lvcreate -n lv3 -l 100%FREE myvg
ll /dev/myvg/


mkfs.ext4 /dev/myvg/lv1
mkfs.ext4 /dev/myvg/lv2
mkfs.ext4 /dev/myvg/lv3


# open in  vim /etc/fstab
/dev/myvg/lv1   /LVM1   ext4    defaults        0       1
/dev/myvg/lv2   /LVM2   ext4    defaults        0       1
/dev/myvg/lv3   /LVM3   ext4    defaults        0       1

mount -a


sha1sum LVM*/*.txt >  checksum
sha1sum LVM*/*.txt -c checksum



# extend vg
fdisk /dev/sdd
pvcreate /dev/sdd1
vgextend myvg /dev/sdd1
vgreduce myvg /dev/sdd1
vgdisplay myvg
vgrename myvg new-name
lvs




# extend lv
lvextend -L +4G /dev/myvg/lv2
lvextend -l +100%FREE /dev/myvg/lv1

resize2fs /dev/myvg/lv2
resize2fs /dev/myvg/lv1


## Reducing Logical Volume (LV)

* Before starting, it is always good to backup the data, so that it will not be a headache if something goes wrong.
* To Reduce a logical volume there are 6 steps needed to be done very carefully.
* While extending a volume we can extend it while the volume under mount status (online), but for reduce we must need to unmount the file system before reducing.

Let’s see what are the 5 steps below: \
* unmount the file system for reducing
* Check the file system after unmount.
* Reduce the file system
* Reduce the Logical Volume size than Current size
* Recheck the file system for error
* Remount the file-system back to stage

df -TH
umount -v /LVM1
e2fsck -ff /dev/myvg/mylv1
echo $?

resize2fs /dev/myvg/mylv1 10G
echo $?
lvreduce -L 2G /dev/myvg/lv1 # reduce to 2GB
echo $?
resize2fs /dev/myvg/mylv1
# xfs_growfs /dev/myvg/lv1	# if file system is xfs

echo $?
mount -a
lvs 
vgs



# reduce vg
vgreduce myvg /dev/sdd1


# remove pv
pvremove /dev/sdd1

partprobe

----------------------------------------------------------------------------
# full example1

pvcreate /dev/sd[bc][12]
pvs

vgcreate myvg /dev/sd[bc][12]
vgs


lvcreate -l 74%free myvg --name lv01

mkfs.ntfs /dev/myvg/lv01
mount /dev/myvg/lv01 /LVM



------------------------------------------------------------------------
# full example2

pvcreate /dev/sd[bc][12]

vgcreate -s 32M myvg /dev/sd[bc][12] # PE size 32MB
vgs



lvcreate -L 6G -n mylv1 myvg
lvcreate -L 6G -n mylv2 myvg
lvcreate -L 6G -n mylv3 myvg

# format lvs

mkfs.ext4 /dev/myvg/mylv1
mkfs.ext4 /dev/myvg/mylv2
mkfs.ext4 /dev/myvg/mylv3


mount /dev/myvg/mylv1 /LVM1
mount /dev/myvg/mylv2 /LVM2
mount /dev/myvg/mylv3 /LVM3

df -TH


cat /etc/mtab

# copy and paste in /etc/fstab, change rw to defaults
/dev/mapper/myvg-mylv1 /LVM1 ext4 defaults 0 0
/dev/mapper/myvg-mylv2 /LVM2 ext4 defaults 0 0
/dev/mapper/myvg-mylv3 /LVM3 ext4 defaults 0 0


 mount -av

pvscan

vgdisplay
lvextend -l +331 /dev/myvg/mylv1  # +331 is PE size
resize2fs /dev/myvg/mylv1
lvdisplay
df -TH
lsblk
```

# pvmove

```
fdisk /dev/sdf

pvcreate /dev/sdf1
vgextend myvg /dev/sdf1
pvmove /dev/sdb1 /dev/sdf1
sync


# You don't need to specify the destination PV; in this case, LVM will move the data to any available space within the VG. like this:
pvmove /dev/sdb1
sync

# now you can remove /dev/sdb1 
vgreduce myvg /dev/sdb1



# finally remove the pv
pvremove /dev/sdb1 

# You can now safely remove the disk physically.
```




# lvm snapshot
```


lvcreate --size 1G --snapshot --name lv1-snapshot /dev/myvg/lv1

# lvcreate -L 1GB -s -n lv1-snapshot /dev/myvg/lv1

lvs

# for remove
lvremove /dev/myvg/lv1-snapshot

# be-causon that the snapshot doesn't overflow, if overflow happend all data will crashed.

# It is good to create a snapshot with the exact size.
for example if lv has 20G , then create a snapshot with 20G size.

# resize snap shot before overflow
lvextend -L +2G /dev/myvg/lv1-snapshot


# resotore snapshot


umount /LVM1
df -TH

lvconvert --merge /dev/myvg/lv1-snapshot
# After the merge is completed, the snapshot volume will be removed automatically.














swapon -s               # show list of swaps
mount -a                # apply changes in /etc/fstab



```





# Nmap for searching IP in subnet

```
nmap -sP 172.16.2.0/24


```







# ufw 

```

sudo ufw enable

sudo ufw disable

sudo ufw status

sudo ufw reset



sudo ufw allow 80/tcp
sudo ufw deny 80/tcp


# Allow a Port Range:
sudo ufw allow 6000:7000/tcp


# Allow from a Specific IP Address:
sudo ufw allow from 10.10.1.10


# Allow from a Specific IP Address to a Specific Port:
sudo ufw allow from 10.10.1.10 to any port 22


# Delete a Rule:

sudo ufw delete allow 80/tcp


# Default Policies:
By default, ufw denies all incoming connections and allows all outgoing connections. You can change these policies using:

sudo ufw default allow incoming
sudo ufw default deny outgoing



# Logging:

sudo ufw logging on
sudo ufw logging off



# Application Profiles:
ufw comes with predefined profiles for common applications, which you can use to simplify rule creation. List available application profiles:

sudo ufw app list
sudo ufw allow [application_name]










```


# firewalld


```

sudo firewall-cmd --state

sudo firewall-cmd --get-zones

sudo firewall-cmd --get-active-zones

sudo firewall-cmd --zone=public --list-all



# Allow a Service:
sudo firewall-cmd --zone=public --add-service=http --permanent



# Remove a Service:
sudo firewall-cmd --zone=public --remove-service=http --permanent


# Allow a Port:
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent

# Remove a Port:
sudo firewall-cmd --zone=public --remove-port=8080/tcp --permanent

# Reload firewalld Configuration:
sudo firewall-cmd --zone=public --change-interface=eth0 --permanent




# Add an Interface to a Zone:
sudo firewall-cmd --zone=public --change-interface=eth0 --permanent


# Remove an Interface from a Zone:
sudo firewall-cmd --zone=public --remove-interface=eth0 --permanent


```
