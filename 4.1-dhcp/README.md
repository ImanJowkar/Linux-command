
```
vim /etc/dhcp/dhcpd.conf
```


# add 
```
default-lease-time 600;
max-lease-time 7200;
   
subnet 10.10.10.0 netmask 255.255.255.0 {
 range 10.10.10.150 10.10.10.200;
 option routers 10.10.10.1;
 option domain-name-servers 10.10.40.12;

}



subnet 10.10.20.0 netmask 255.255.255.0 {
 range 10.10.20.150 10.10.20.200;
 option routers 10.10.20.1;
 option domain-name-servers 10.10.40.12;
 
}




subnet 10.10.40.0 netmask 255.255.255.0 {
 range 10.10.40.150 10.10.40.200;
 option routers 10.10.40.1;
 option domain-name-servers 10.10.40.12;
 
}

###################



vim /etc/default/isc-dhcp-server
#######
INTERFACESv4="ens3"
##########



sudo systemctl restart isc-dhcp-server.service

dhcp-lease-list

```