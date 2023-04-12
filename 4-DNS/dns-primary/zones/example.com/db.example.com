;
; BIND data file for local loopback interface
;
$TTL    1200
$ORIGIN example.com.


@       IN      SOA     ns1.example.com. admin.example.com. (
                              11         ; Serial (used for zone transfer)
                         604800         ; Refresh (how long secondary server check master server for sync) 
                          86400         ; Retry (how long secondary server retry master server if refresh faild)
                        2419200         ; Expire ()
                         604800 )       ; Negative Cache TTL
;


; name servers - NS records

@       IN      NS      ns1.example.com.
@       IN      NS      ns2.example.com.
@	IN	NS	ns3.example.com.
; name servers - A records

ns1             IN      A       172.16.12.30
ns2             IN      A       172.16.12.31
ns3		IN	A	172.16.12.15

; 172.16.12.0/24 - A records

web             IN      A       172.16.12.32
client2         IN      A       172.16.12.33
dhcp            IN      A       172.16.12.40
fw              IN      A       172.16.12.50
mail		IN	A	172.16.12.80
ff		IN	A	172.16.12.81
fff		IN	A	172.16.12.82
ffff		IN	A	172.16.12.83
test1		IN	A	172.16.12.84
test2		IN	A	172.16.12.85
@		MX	10	mail.example.com.



; CNAME records

www             IN      CNAME   web
dh		IN	CNAME	dhcp
