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
