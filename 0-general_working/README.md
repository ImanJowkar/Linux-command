# Linux Engineering:
- [ ] Introduction
- [ ] Basic linux command
- [ ] User management and Permission
- [ ] text editor (vim)
- [ ] Basic Linux permision
- [ ] finding file and directories
- [ ] Text Processing



## two main Linux ditributions
* debain based(ubuntu(18.20,22,24), debain(10,11,12)) -->  pakage manager apt
* rhel based(centos(dead), fedora, rockey(8,9)) --> package manager yim, dnf





## file system hierarchy
![img](img/file-system-hierarchy.png)

* `/`: The root directory / is the starting point for the entire Linux filesystem hierarchical tree
* `/boot`:  is where the kernel is stored.
* `/etc`: configuration files information.
* `/dev`: its a location of a device files like: /dev/sda, /dev/sdb , /dev/nvme
* `/root`:  home directory for administrator account 
* `/home`: personal directories for each user account 
* `/proc`: system processes/resources 
* `/tmp`: temporary files purged on reboot
* `/bin`: common binary executables
* `/var`: variable and log files
* `/usr`: user related program
* `/lib`: library files (A library file in Linux is a collection of precompiled functions that programs can use to perform tasks without having to code them from scratch.)



lests start: 
download and install putty.

## basic linux command  

```
ls 
ls -lah             # long-list, hidden, human-readable
pwd
touch file1.txt     # create a file
touch .file         # create hidden file
echo "Hello world" > file1.txt
echo "Hello world" >> file1.txt
touch file{1..3}      # {} curly Brace, curly Braket
cat file1.txt

cd ~                  # ~ is home directory for user
cd .                  # . is current working directory
cd ..                 # change the current directory to the parent directory
cd                    # go to home directory

cd /home/test         # absolute pass
cd test               # relative path

mkdir dir1            # create a directory(folder)
mkdir dir{1..5} 
mkdir -p dire1/dire2


ls -lah /dev/        # block device: hard disk ,cd-rom, flash.  character device: mouse, keyboard

d > directory
l > link
c > character device
b > block device
- > regular file 

ls -li                # inode number(Each file or directory has an inode number that indicates its location on the hard disk.)
```
![img](img/ls-detail.png)
![img](img/ls-lah-detail.png)


```


sudo apt install tree
tree .

stat file
file {directory, file-name}  # give you the type of the file or dirctory or zip or ....
which pwd

tail /var/log/file.txt
tail -f /var/log/file.txt
head /var/log/file.txt
cat /var/log/file.txt


cat file.txt | wc    # show line, word, char
cat file.txt | wc -l # show only the number of line

cp <src> <dest>       # copy file and directory
cp file1 /etc/file.conf     
cp /etc/nginx/nginx.conf ~

mkdir ~/backup
cp -r /etc/ ~/backup
cp -r /etc/* ~/backup

mv <src> <dest>

rm file
rm -r directory
rm -rf directory


md5sum file
sha256sum file.tar


# redirect output and input
echo "hi" > file              # standard output   STDOUT
caaat file 2> /dev/null       # standard error    STDERR
caaaat file &2> /dev/null     # stdout, stderr
echo $?

```
## User management and Permission
`we have to main method for authenticating our user:`
* local database
* domain controller: Openldap, Active-Directory


```
adduser iman                      # This is a low-level command that creates a user account without any additional setup.
useradd iman   --> user-friendly  # This is a higher-level command, typically a script that uses useradd under the hood. It simplifies the process by providing a more interactive experience, often prompting for details like the password and home directory

cat /etc/passwd

which passwd      # a binary file for changing the user password
passwd iman
```
![img](img/passwd.png)

```
gid, uid
id -u     # show user uid
id -g     # show user gid
addgroup
delgroup

cat /etc/groups


usermod -aG <group> <user>
usermod -aG sudo iman
groups <user>   # show groups which this user joind 


usermod -L <user>   # lock(disable) a user
usermod -U <user>   # unlock a user

cat /etc/shadow

su <user>     # switch to another user but don't run scripts (.bashrc, ...) 
su - <user>   # run script (.bashrc, ...) when switch to user

```
![hidden file](img/hidden-file-home-user.png)

```
cd /etc/skel
touch /etc/skel/info.text
adduser iman1
ls -lah /home/iman1


```


## text editor (vim)
```
set cursorline
:5          $ go to line 5

dd          # delete a line 
d5          # delete line 5

u           # undo change

gg          # go to the begining of the file
shift + g   # go to the end of the file

shift+A     # go to the end of a specefic line
$           # go to the end of a specefic line

0                   # go to the begining of a specific line

/text               # search text in the file

:s/find/replace/    # find first word in the current line (not in all line)
:%s/find/replace/   # find and replace first match in any line
:%s/find/replace/g  # find and replace globally


yy          # copy the line 
p           # paste the line

ggVG        # highlight all 

:set number         # show line number



# vim Configuration:
vim ~/.vimrc
# paste
set number
set cursorline

```
[document](https://devhints.io/vim)



## Basic Linux permision

```


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

sudo -H -u <user> bash -c 'cat /etc/add-route.sh'
sudo -H -u ansible bash -c 'echo "fsdf" >>  /etc/add-route.sh'

chmod g=rx file.txt

chmod -R 444 directory

R       W       X
2^2     2^1     2^0


chmod 724 file > user: RWX, group: W, Other: R





# umask

# umask denfine default permision for a directory content, umask apply to a directory and after that any file we create on that directory got the umask permision

!!! with umas we can't set execute permision 


      user                    group                      other
-----------------         --------------           -----------------
R       W       X         R       W       X        R       W       X    
1       1       0         1       1       0        0       0       0

0 0 2^0=1                  0 0 2^1=1                2^2, 2^1,2^0=7

umask 117 dirctory_1   >>   RW- RW- ---

# for security reasons it cannot be set excute permision with umask
umask only apply to new file which we create on the directory






# Special Permission: 
SUID            4
SGID            2
StickyBit       1

# SUID
ls -lah /usr/bin/passwd
chmod 4644 /usr/bin/passwd
chmod u+s /usr/bin/passwd


# SGID
chmod 2644 file
chmod g+s file




# stickeyBit   # only apply on directory
when stickeyBit is enable on a dirctory , only the owner of file can delete the file but other and gourp can't delete.

mkdir /test
chmod 1777 /test
# chmod o+t  /test
touch /test/file1
chmod 777 /test/file1

su user2
cd /test
rm -rf file1


# by default stickyBit is enable on /tmp

```







## finding file and directories

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


## Text Processing
### cat, cut, sed

```
cat file
cat -E file     # show \n too
cat -n file     # show line number

cat file | wc -l

# cut
file

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




sed       # a way to search and replace
--------------------------------
hello this is my course on linux
linux is very good
--------------------------------

sed -i 's/find/replace/' file
sed -i 's/find/replace/g' file

# -i = inplace
# s  = substitute 

sed -i '/^$/d' file    # remove empty line from file
sed 's/.*/\U&/' file   # transfer lower case to UPPER CASE



## tr (translate)

file
----------------------------
this is test
----------------------------

cat file | tr a-z A-Z
----------------------------
THIS IS TEST
----------------------------


cat file | tr 'i' 'I'               # convert `i` to `I`
cat test | tr [:lower:] [:upper:]   # this not work on zsh
cat file | tr -d 't'                # remove 't' 
cat file | tr -d 'test'             # remove 't' , 'e', 's'  
cat test | tr -d [:digit:]          # remove all digits in a file
cat test | tr -d [:space:]          # remove all spaces
cat test | tr -d ' '                # remove all spaces
cat test | tr -d [:blank:]          # remove all blank
cat test  | tr -s ' '               # delete multiple space and replace with one space

iman@iman:~$ cat file
this is               test
iman@iman:~$ cat file | tr -s ' '
this is test

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

### comparing files

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


## Package manager

```
rpm -qa  # show all program which is installed 
rpm -qa | grep nginx

apt list --installed
dpkg -l


```


## Process management

```
ps       
ps -ef        # show pid and ppid
ps -aux
ps -f -u root           # only show root process

ps aux --sort=%mem
ps aux --sort=-%cpu

ps -A -o stat,pid,ppid | grep -e '[zZ]'

pgrep python3
pgrep sshd                  # get process id

pgrep -l sshd               # get process id with service name





pidof sshd
pidof chrome



nohub ./app.sh                          # or we can use tmux


```



## modules 
```
lsmod                               # print all modules which already added to kernel
modprobe module_name                # add module and requiremnt modules to kernel
modprobe -r module_name             # remove a modlue and all dependencies
insmod module_name                  # only add module and can't load requirement modules
rmmod module_name                   # remove a module from a kernel
modinfo module_name                 # get info of modules

# if you want to permenent loaded modules, add modules to "/etc/modules-load.d"


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
## tar and zip

```
tar gather all file to a single tar file

tar -cvf backup.tar file1 file2 file3                   # tar the files
tar -tvf backup.tar                                     # only show which file is in the backup.tar
tar -xvf backup.tar                                     # untar the file

sudo tar -cvf archive.tar /etc/*




```

## compression
[refrence](https://www.rootusers.com/gzip-vs-bzip2-vs-xz-performance-comparison/) for comparing these three method for compress files.
**tip**: before compres any file, first use tar and then use compres method
```
gzip -c file  > file.gz
file file.gz
gzip -d file.gz       # uncompress the file


tar -zcvf backup.tar.gz file2 file3
tar -zcfv backup-etc.tar.gz /etc/*
tar -zxvf backup-etc.tar.gz

tar -zxvf backup-etc.tar.gz -c /data







sudo apt install bzip2
bzip2 file.tar
bzip2 -d file.tar.bz2


xz file.tar
xz -d file.xz

```

## SCP (Secure COPY)
```
scp -p 22 file.tar user@172.16.2.2:/home/user/backup/                           # for scp a file or tar file
scp -r -p 22 dirctory user@172.16.2.2:/home/user/backup/                        # for scp a dirctory

scp user@172.16.2.2:/home/user/backup/backup.tar user1@172.16.2.4:/home/user1/backup/   # scp from a server to another server

# you can use WinSCP for transfer file between linux and Windows 




rsync -avz  /path/to/local/directory username@remote_host:/path/to/remote/directory
sudo rsync -avzh /etc/ /home/user/etc-backup              # if target directory does not exist, rsync will be create for us


mkdir test1
mkdir test2

touch test1/file{1..10}

rsync test1/* test2/

# -a === incrimental copy 
# -P === progress bar
# -v === verbose

rsync -avP test1/* test2/


rsync -avP test1/* -e "ssh -p 22" iman@10.10.56.101:/home/iman/test1



rsync -avP {dir1,dire2} -e "ssh -p 22" iman@10.10.56.101:/home/iman/test1


```


## iftop

```
sudo apt install iftop
iftop # show the network send and recived

sudo apt install iotop
iotop   # show the disk R/W status

```





# Disk

```
Buffer + Cache    # part of RAM, for speed the application performace
Swap              # part of disk, act as a RAM

sync              # this command write buffer to disk


file system       # A program that manages reading and writing to the disk; 
                    when we say format the hard disk,we mean installing a new file system on it. 


1) Linux Based File system

Name                  MaxFsSize       MaxFileSize         journaling      
ext2                  2 TiB               2 TiB              no
ext3                  2 TiB               16 TiB             yes
ext4                  1 EiB               1 EiB              yes




2) non-linux file system

Name                  MaxFsSize       MaxFileSize         journaling      
NTFS                  2 TiB               256 TiB              no
XFS                   8 EiB               8 EiB                yes



bit 
Byte = 8 bit


KB    -> * 10^3               KiB    -> * 2^10 = 1024 
MB    -> * 10^6               MiB    -> * 2^20 = 1024 * 1024
GB    -> * 10^9               GiB    -> * 2^30 = 1024 * 1024 * 1024 
TB    -> * 10^12              TiB    -> * 2^40 = 1024 * 1024 * 1024 * 1024
PB    -> * 10^15              PiB    -> * 2^50 
EB    -> * 10^18              EiB    -> * 2^60 
ZB    -> * 10^21              ZiB    -> * 2^70 
YB    -> * 10^24              YiB    -> * 2^80 


fdisk /dev/sdb
mkfs.ext4 /dev/sdb1
echo $?
lsblk -f

mount /dev/sdb1 /data
mount -r /dev/sdb1 /data    # read-only mount


# open /etc/fstab
/dev/sdb1 /data ext4  defaults  0 0

/dev/sdb1 /data ext4  ro,noexec 0 0


df -TH
df -hi



umount /dev/sdb1
fsck.ext4 /dev/sdb1      # file system repair
xfs_repair  /dev/sdc1



echo "- - -" | tee /sys/class/scsi_host/host*/scan




dd if=/dev/zero of=file1 bs=1M count=5000
dd if=/dev/urandom of=file1 bs=1M count=5000


## distory all data in a disk
sudo dd if=/dev/zero of=/dev/sdb1 status=progress

## creating a bootable usb-drive
sudo dd if=/path/to/iso of=/dev/sdX bs=4M status=progress && sync


# backup /boot
lsblk
dd if=/dev/sda2 of=/data/boot status=progress
dd if=/data/boot of=/dev/sda2 status=progress


# create a big file
dd if=/dev/zero of=bigfile bs=1M count=1024 status=progress



```





# LVM (logical volume management)
[ref](https://www.tecmint.com/create-lvm-storage-in-linux/)
```
cat /proc/sys/vm/swappiness
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


vim /etc/fstab
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
# 1
umount -v /LVM1

# 2
e2fsck -f /dev/myvg/mylv1
echo $?

#3
resize2fs /dev/myvg/mylv1 10G
echo $?

#4 
lvreduce -L 10G /dev/myvg/lv1 # reduce to 10GB
echo $?

#5 
resize2fs /dev/myvg/mylv1
# xfs_growfs /dev/myvg/lv1	# if file system is xfs
echo $?

# 6
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






# Networking

## types of networking services in linux
todays linux servers used one of the three below network services. the three most common are: 
* `networking` ->  debain server
* `networkd` -> ubuntu server
* `NetworkManager` -> redhat, fedora, centos, ubuntu desktop

```

ip -br -c a
ip r     ##short for `ip route show `

# Nmap for searching IP in subnet
nmap -sP 172.16.2.0/24

```

### networking service
![img](img/networking.png)
```
systemctl status networking.service

nano /etc/network/interfaces

### set static ip
-------------------------
nano /etc/network/interfaces
# add below
allow-hotplug enp0s8
iface enp0s8 inet static
        address 192.168.56.200/24
        gateway 192.168.56.1
-------------------------

#### set dynamic ip address
--------------------------
nano /etc/network/interfaces
# add below
allow-hotplug enp0s3
iface enp0s3 inet dhcp

--------------------------


systemctl restart networking.service

ifdown enp0s3
ifup enp0s3
ifquery enp0s8  # show ip address , gateway, netmask


```

### networkd
![img](img/systemd-networkd.png)

```
systemctl status systemd-networkd



### dhcp configuration

vim /etc/netplan/00-installer-config.yaml

-----

network:
  ethernets:
    enp0s8:
      dhcp4: true
    enp0s3:
      dhcp4: true
  version: 2


------

#### Static ip addressing

-----
network:
  ethernets:
    enp0s3:
      addresses:
        - 192.168.56.101/24
      routes:
        - to: default
          via: 192.168.56.1
      nameservers:
        addresses:
          - 8.8.8.8

    enp0s8:
      dhcp4: true
  version: 2
  renderer: networkd


------


netplay try
netplan apply
networkctl
networkctl status
networkctl lldp
networkctl down enp0s3
networkctl up enp0s3



### you can set dns server info in 

vim /etc/systemd/resolved.conf

----
#DNS=
#FallbackDNS=
#Domains=

----


resolvectl
resolvectl  flush-caches
resolvectl statistics


```
![img](img/wireless.png)


### NetworkManager
![img](img/network-manager.png)

```

nmtui
nmcli 




## configuration file is here:

/etc/NetworkManager/system-connections

journalctl -u NetworkManager.service

journalctl -u NetworkManager.service  | tail -10

journalctl -u NetworkManager.service  | tail -10 | column -t

```
## ip command

```

 ip link show   === ip l  # show layer 2 of OSI-model

 ip address show === ip a  # show layer3 of OSI-model


 ip address show | sed -ne 's,^ *inet6* \([^ /]*\)/.*$,\1,p' | sort -u


ip -j address show # output json
ip -j -p address show # json pretty output

ip -j -p address show | jq

ip a | grep inet | sort -n

ip a | grep inet | sort -n | column -t


ip -o -4 a

ip -o -4 a | awk '{print $4}'



cd /sys/class/net/
cat /sys/class/net/enp0s3/statistics/tx_bytes

cat /sys/class/net/enp0s3/statistics/tx_errors

cat /sys/class/net/enp0s3/statistics/rx_errors




# ip route

ip route show

ip -c route show | column -t

ip -c route | grep default

# delete default route

sudo ip route del default


# add default route

ip route add default via 10.10.5.1

# add route
ip route add 10.10.10.0/24 dev enp0s8

ip route del 10.10.10.0/24

sudo route add -net 10.10.10.0 netmask 255.255.255.0 gw 192.168.229.173




ip -6 route list
```
## Network testing command

```

ping -c 100 10.10.5.3  # send 100 icmp echo

ping -s 1000 10.10.5.3  # size of packet


traceroute 8.8.8.8



whois google.com

whois google.com -H -I



dig google.com
dig -x google.com

nslookup google.com


### Nmap
nmap is a network discovery and security auditing tool, there are a variety scans that can be perform nmap, TCP SYN scan is the default and most popular scan option for good reason



sudo apt install nmap  # if you want to install nmap in windows you can install zenmap which is a GUI for nmap

sudo nmap IP_address
sudo nmap -sS IP_address

# by default nmap scan most common 1000 port for each protocol
nmap -p 22,50000 -sV IP_address

# if you want to sacn all port
nmap -p- IP_address


# for UDP scan
namp -sU localhost




nmap 10.10.10.10

nmap -sn 10.10.10.0/24

nmap -sP 172.16.2.0/24

```
## Iptables
* Iptables,  Netfilter is a packet filtering inside a linux kernel

![netfilter](img/netfilter.png)
![tables](img/iptables-tables.png)
![chains](img/iptables-chains.png)

```
iptables -L             # list rules in filter table

# list in specific table
iptables -t filter -L   # list rules in filter table
iptables -t mangle -L   # list rules in mangle table

iptables -t filter -nvL           # list rules with packets details


# flush a specific chain of table
iptables -t filter -F INPUT
iptables -t mangle -F
iptables -t nat -F

iptables -Z             # reset byte and counters

iptables -N custom-chain        # Create Custom chain
iptables -X custom-chain        # delete chain




iptables -t filter -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -t filter -A OUTPUT -p tcp --dport 80 -d 8.8.8.8 -j DROP



iptables -t filter -A INPUT -p tcp --dport 22 -s 10.10.10.1 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 22 -s 10.10.10.0/24 -j DROP
iptables -t filter -A INPUT -p tcp --dport 22 -s 0/0 -j DROP
iptables -t filter -A INPUT  -s 0/0 -j DROP


# multi-port

iptables -t filter -A INPUT -p tcp -m multiport --dport 22,80,3306 -s 192.168.56.0/24 -j ACCEPT
iptables -t filter -A INPUT -p tcp -m multiport --dport 22,80,3306 -s 0/0 -j DROP



# ip-range
iptables -t filter -A INPUT -p tcp --dport 80 -m iprange  --src-range 10.10.10.1-10.10.10.10 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 80 -m iprange  --src-range 10.10.10.11-10.10.10.100 -j DROP


# DROP all outgoing multicast address
iptables -t filter -A OUTPUT -m addrtype --dst-type MULTICAST -j DROP




iptables -t filter -A INPUT -p tcp --dport 22 ! -s 10.10.10.1 -j DROP



# change default policy

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
iptables -t filter -i enp0s3 -A INPUT -p tcp --dport 22 -s 172.16.2.0/24 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -o enp0s3 -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT













# iptables-save
iptables rules are stored in memory, so they are not persistent, because when the system is shutting down all rules will be deleted.


1) first option
iptables-save > rules
iptables-restore rules


2) second option
sudo apt install iptables-persistent
iptables-save > /etc/iptables/rules.v4

```

* ufw 
* firewalld




## DNS
![img](img/dns.png)


```

hostnamectl set-hostname test.local

```


## nmcli


```

nmcli connection show
nmcli connection down enp0s3
nmcli connection up enp0s3

nmcli connection edit enp0s3



# static ip addressing
nmcli connection modify enp0s8 ipv4.method manual ipv4.addresses 10.10.10.1/24 ipv4.gateway 10.10.10.254 ipv4.dns 8.8.8.8 ipv4.dns-search "xample.com"
nmcli connection down enp0s8 && nmcli connection up enp0s8



# dhcp ip addressing
nmcli connection modify enp0s8 ipv4.method auto


# scan wifi
nmcli device wifi
nmcli device wifi connect "ssid" password pass  name "wifi1-profile"

```

### ufw  and  firewalld

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

# firewalld






```

## SFTP


```
sftp user@10.10.10.1 


ls # list content of sftp server
get file.tar  # download from sftp server
reget file.tar
mkdir dir1 # create directory on sftp server
?




lls # list context of local server
put file.tar # upload to the sftp server
lmkdir # create directory on local server


```

# Additional network tools

```
# neofetch

apt install neofetch
neofetch

vim .config/neofetch/config.conf



# wget

wget google.com
wget -r site.com


# btop
apt install btop
btop


# bmon
apt install bmon
bmon


arp 
arp -a
arp --help


apt install speedtest-cli
speedtest-cli 


```



# figlet
```
sudo apt install figlet
figlet imanjowkar

bc      # terminal calculator

```