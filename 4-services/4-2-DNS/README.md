# Setup DNS-server
[ref](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-20-04)

### `we have 3 types of dns server: `
* `cache only dns server (recursive)`
* `Authoritative (master and slave)`
* `forwarders`


`port number: 53/udp for dns query, 53/tcp for zone transfer`

## Cache Only DNS on rocky linux
```sh
# apt install bind9 bind9utils bind9-doc
dnf install bind bind-utils bind-chroot

rpm -ql bind    # show you the files added by bind package

dpkg -L nginx     # show you the files added by nginx
dpkg -L haproxy   # show you the files added by haproxy


vim /etc/named.conf
------
listen-on port 53 { any; };
listen-on-v6 port 53 { none; };
allow-query     { localhost; 192.168.96.0/24; };
recursion yes;
------
systemctl restart named


firewall-cmd --add-port=53/udp --permanent
firewall-cmd --reload

# on client to test 
sudo dnf install bind-utils -y

dig yahoo.com
dig google.com @8.8.8.8
dig NS imanjowkar.ir



#### This is the root hints dns servers
cat /var/named/named.ca
```


