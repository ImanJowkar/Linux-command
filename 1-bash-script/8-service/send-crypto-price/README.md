vim /etc/systemd/system/send-crypto.service 

```
[Service]
ExecStart=/home/user/bash/8-service/send-crypto-price/main.py

```


vim /etc/systemd/system/send-crypto.timer

```
[Timer]
OnCalendar=*-*-* *:*:00
Unit=send-crypto.service

```