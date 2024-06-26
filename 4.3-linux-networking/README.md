# Linux Networking Command

```
ip -br -c a

ip r     ##short for `ip route show `


```


## types of networking services in linux
todays linux servers used one of the three below network services. the three most common are: 
* `networking` ->  debain server
* `networkd` -> ubuntu server
* `NetworkManager` -> redhat, fedora, centos, ubuntu desktop


### networking service
![img](img/1.png)
```

systemctl status networking.service

nano /etc/network/interfaces

### set static ip
-------------------------
allow-hotplug enp0s8
iface enp0s8 inet static
        address 192.168.56.200/24
        gateway 192.168.56.1
-------------------------

#### set dynamic ip address
--------------------------

allow-hotplug enp0s3
iface enp0s3 inet dhcp

--------------------------


systemctl restart networking.service

ifdown enp0s3
ifup enp0s3
ifquery enp0s8  # show ip address , gateway, netmask


```



### networkd
![img](img/2.png)


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

![img](img/3.png)

### NetworkManager

![img](img/4.png)


```

nmtui
nmcli 




## configuration file is here:

/etc/NetworkManager/system-connections

journalctl -u NetworkManager.service

journalctl -u NetworkManager.service  | tail -10

journalctl -u NetworkManager.service  | tail -10 | column -t

```


![img](img/5.png)


# ip command

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




ip -6 route list
```


# Network testing command
![img](img/6.png)

```

ping -c 100 10.10.5.3  # send 100 icmp echo

ping -s 1000 10.10.5.3  # size of packet


traceroute 8.8.8.8



whois google.com

whois google.com -H -I



dig google.com
dig -x google.com

nslookup google.com


nmap 10.10.10.10

nmap -sn 10.10.10.0/24

nmap -sP 172.16.2.0/24





```

# DNS
![img](img/7.png)

```

hostnamectl set-hostname test.local



```

# nmcli


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


# scp and rsync

```
# scp

scp <source> <destination>

scp Rocky-9.1-x86_64-minimal.iso iman@10.10.56.200:/home/iman


scp iman@10.10.56.11:/home/iman/Rocky-9.1-x86_64-minimal.iso .



# rsync

rsync <source> <destination>

rsync -a Rocky-9.1-x86_64-minimal.iso iman@10.10.56.200:/home/iman


rsync -a iman@10.10.56.200:/home/iman/Rocky-9.1-x86_64-minimal.iso .




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


# SFTP
![img](img/8.png)

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