
## Create a service 
```
vim /etc/systemd/system/net-check.service

# add below config

#######

[Unit]
Description="When calling this app, it get you a random number."
After=network.target



[Service]
User=root
ExecStart=/root/1-check-net-connectivity.sh
Restart=always


[Install]
WantedBy=multi-user.target





#######

systemctl daemon-reload
systemd-analyze verify net-check.service
systemctl enable net-check.service --now
systemctl status net-check.service
journalctl -u net-check.service
journalctl -f -u net-check.service



## now create a timer
vim /etc/systemd/system/net-check.timer

#############

OnCalendar=*-*-* *:*:00/20
unit=net-check.service
#############


systemd-analyze verify net-check.timer
systemctl daemon-reload
systemctl start net-check.timer



```