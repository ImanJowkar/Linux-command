# How to run

you have to install python3 on your system.
then run below command in the terminal

```
pip3 install -r requirement.txt
uvicorn main:app --reload


```


## How to write a service for running this app on linux

```
 vim /etc/systemd/system/my-service.service
# add below config
### 

[Unit]
Description="When calling this app, it get you a random number."
After=network.target



[Service]
User=root
ExecStart=/root/venv/bin/python /root/main.py
Restart=always


[Install]
WantedBy=multi-user.target


###


```


systemctl daemon-reload
systemctl start my-service.service
systemctl status my-service.service
