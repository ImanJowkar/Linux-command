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
firewall-cmd --add-port=53/tcp --permanent
firewall-cmd --reload

# on client to test 
sudo dnf install bind-utils -y

dig yahoo.com
dig google.com @8.8.8.8
dig NS imanjowkar.ir



#### This is the root hints dns servers
cat /var/named/named.ca
```


## Authoritative (master and slave) DNS servers
| Record    | Name / Purpose                                                                      | Example                                            |
| --------- | ----------------------------------------------------------------------------------- | -------------------------------------------------- |
| **A**     | Maps a hostname to an IPv4 address                                                  | `example.com → 93.184.216.34`                      |
| **AAAA**  | Maps a hostname to an IPv6 address                                                  | `example.com → 2606:2800:220:1:248:1893:25c8:1946` |
| **MX**    | Mail Exchange – defines mail servers for a domain                                   | `example.com → mail.example.com (priority 10)`     |
| **SOA**   | Start of Authority – contains domain metadata (primary DNS, serial, refresh timers) | Zone start info (who’s authoritative)              |
| **CNAME** | Canonical Name – alias to another domain                                            | `www.example.com → example.com`                    |
| **TXT**   | Text record – arbitrary text, often used for SPF, DKIM, DMARC                       | `v=spf1 include:_spf.google.com ~all`              |
| **PTR**   | Pointer – reverse DNS (IP → hostname)                                               | `34.216.184.93.in-addr.arpa → example.com`         |


| Record                  | Name / Purpose                                                            | Example                                         |
| ----------------------- | ------------------------------------------------------------------------- | ----------------------------------------------- |
| **NS**                  | Nameserver – delegates authority for a zone                               | `example.com → ns1.example.net`                 |
| **SRV**                 | Service locator – defines services like SIP, XMPP                         | `_sip._tcp.example.com → sipserver.example.com` |
| **CAA**                 | Certificate Authority Authorization – restricts which CAs can issue certs | `example.com → 0 issue "letsencrypt.org"`       |
| **NAPTR**               | Naming Authority Pointer – used with SRV for advanced service discovery   | Mostly telecom/VoIP                             |
| **DNSKEY / RRSIG / DS** | DNSSEC records for signing and validation                                 | Secure DNS chain of trust                       |

```sh
vim /etc/named.conf
-----
listen-on port 53 { any; };
listen-on-v6 port 53 { none; };
allow-query     { localhost; 192.168.96.0/24; };
recursion no;


# add at the end of the file

zone "imanjowkar.ir" IN {
        type master;
        file "imanjowkar.ir.db";
        allow-transfer { 192.168.96.11; };
};
-----

named-checkconf
echo $?


rpm -ql bind | grep sample | grep localhost 
cat   $(rpm -ql bind | grep sample | grep localhost) > /var/named/imanjowkar.ir.db

vim /var/named/imanjowkar.ir.db
----------
$TTL 1D
imanjowkar.ir.  IN SOA  ns1.imanjowkar.ir. admin.imanjowkar.ir. (
                                        0       ; serial
                                        60      ; refresh
                                        10      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
        NS      ns1
        NS      ns2
        A       127.0.0.1
        AAAA    ::1

ns1     A       192.168.96.150
ns2     A       192.168.96.11

zabbix  A       192.168.96.100

@       MX      10      mail1
@       MX      20      mail2

mail1   A       192.168.1.1
mail2   A       192.168.20.1
ftp     A       192.168.4.2

www     CNAME   zabbix
ww      CNAME   zabbix
----------

named-checkzone imanjowkar.ir /var/named/imanjowkar.ir.db


#################################### Secondary ####################################
## setup salve or secondary dns server
# setup another server and install the bind9 package on it

dnf install bind bind-utils bind-chroot

vim /etc/named.conf
-----
listen-on port 53 { any; };
listen-on-v6 port 53 { none; };
allow-query     { localhost; 192.168.96.0/24; };
recursion no;


# add at the end of the file
zone "imanjowkar.ir" IN {
        type slave;
        file "imanjowkar.ir.db";
        masters { 192.168.96.150; };
};

-----

named-checkconf
echo $?



```





## Forwarders

```sh




```