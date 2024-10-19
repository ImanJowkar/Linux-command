# Linux services



## Unit service
for adding a service in linux, create a file in below directory
```
sudo vim /etc/systemd/system/check-net.service
# simply add below content to it
###############

[Service]
ExecStart=/home/user/linux-service/check-internet-connectivity.sh

#############


systemd-analyze verify check-net.service
systemctl daemon-reload
systemctl status check-net.service
journalctl -u check-net.service -f


```



## Unit timer

```
sudo vim /etc/systemd/system/check-net.timer
# simply add below content to it
###############

[Timer]
OnCalendar=*-*-* *:*:00
Unit=check-net.service

#############


# run below command
systemd-analyze verify check-net.service
systemctl daemon-reload
systemctl status check-net.start
systemctl start check-net-timer
```



# disk usage
```
disk_usage=`df -TH | grep "sda2" | tr -s ' ' | cut -d' ' -f6 | tr -d -c 0-9`

```