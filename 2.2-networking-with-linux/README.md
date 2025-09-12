# inter-vlan routing
![img](img/1.png)

## On Ubuntu Server

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



iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE

```

## On Rocky Linux

```bash
sysctl -w net.ipv4.ip_forward=1

echo "net.ipv4.ip_forward = 1" |  tee -a /etc/sysctl.conf
sysctl -p

modprobe 8021q

echo "8021q" | tee /etc/modules-load.d/8021q.conf


nmcli connection add type vlan con-name vlan10 dev eth1 id 10 ip4 10.10.10.1/24
nmcli connection add type vlan con-name vlan30 dev eth1 id 30 ip4 10.10.30.1/24

nmcli con up vlan10
nmcli con up vlan30

ip -brief addr show



iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

```