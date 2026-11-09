```sh
sudo sysctl -w vm.max_map_count=262144

echo "vm.max_map_count=262144" | \
sudo tee /etc/sysctl.d/99-graylog.conf



openssl rand -hex 48 # store output in GRAYLOG_PASSWORD_SECRET

echo -n 'YourAdminPassword' | sha256sum # store output in GRAYLOG_ROOT_PASSWORD_SHA2
vim .env
-----
GRAYLOG_PASSWORD_SECRET=d3af33fa99796acd197297dbb75b2aec6854fa0d77abb8bf6a06e3a746654c12202cf25aaec3bda1816e33f896d24d4d
GRAYLOG_ROOT_PASSWORD_SHA2=8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
-----


vim docker-compose.yml
----

# change
GRAYLOG_HTTP_EXTERNAL_URI: "http://192.168.85.74:9000/"
----
docker pull hub.hamdocker.ir/mongo:7.0
docker pull hub.hamdocker.ir/graylog/graylog:7.2
docker pull hub.hamdocker.ir/graylog/graylog-datanode:7.2



docker compose config --quiet
docker compose up -d

```


# config cisco router
```sh

configure terminal
service timestamps log datetime msec localtime show-timezone
logging on
logging host 192.168.85.74 transport udp port 5140
logging trap informational
end


configure terminal
clock timezone IRST 3 30
no clock summer-time
service timestamps log datetime msec localtime show-timezone year
end
write memory


configure terminal
ntp server <NTP_SERVER_IP>
end



sudo tcpdump -i any -nn -s 0 -A 'udp dst port 5140'

send log 5 Graylog-Test

send log 9 Graylog-Test


configure terminal
logging on
logging trap informational
login on-failure log
login on-success log
end

conf t
interface Loopback100
description Graylog-Test
shutdown
no shutdown
exit
end


login block-for 60 attempts 10 within 60
login on-failure log
login on-success log


# microtik
system/logging/action/add name=graylog target=remote remote=192.168.85.74 remote-port=5140

/system logging add topics=info action=graylog
/system logging add topics=warning action=graylog
/system logging add topics=error action=graylog
/system logging add topics=critical action=graylog

/log info "Graylog MikroTik Info Test"
/log warning "Graylog MikroTik Warning Test"
/log error "Graylog MikroTik Error Test"


# search
source:router.iman.test\:
source:192.168.85.155
level:3
message:*LOGIN_FAILED*


message:LOGIN_FAILED*
message:login
login
message:login failed
source:router.iman.test\: AND level:3
level:[2 TO 4]



```


# create dashboard
```sh
name : Network Devices Overview


```