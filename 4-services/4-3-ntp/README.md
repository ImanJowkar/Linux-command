# ntp
```
dnf install chrony


vim /etc/chrony.conf
# add
pool 10.10.10.1 iburst

systemctl enable chronyd --now
timedatectl set-ntp true
chronyc  sources -v
chronyc sourcestats

```