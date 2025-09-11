# inter-vlan routing
![img](img/1.png)

### on ubuntu server

```sh


vim /etc/sysctl.conf
---------
net.ipv4.ip_forward=1
--------

sysctl -p



apt install vlan


modprobe 8021q
lsmod | grep 8021q
echo "8021q" | sudo tee /etc/modules-load.d/8021q.conf



vim /etc/netplan/inter-vlan-routing.yaml 
----------
network:
  version: 2
  ethernets:
    ens3:
      dhcp4: no
  vlans:
    vlan10:
      id: 10
      link: ens3
      addresses: [10.10.10.1/24]
    vlan30:
      id: 30
      link: ens3
      addresses: [10.10.30.1/24]
----------

chmod 600 inter-vlan-routing.yaml

netplay apply

```