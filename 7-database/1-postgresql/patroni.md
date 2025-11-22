## setup patroni on debian-12

# Postgresql
[End of life postgresql](https://endoflife.date/postgresql)

[installation](https://www.postgresql.org/download/)

## install on debain
[ref](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart)



```sh
apt install iotop sysstat lsof dstat bash-completion vim nano tar zip unzip wget
dnf install iotop sysstat lsof dstat bash-completion vim nano tar zip unzip  wget

```

```sh
apt install sudo

sudo apt install -y vim nano curl wget git unzip tar zip net-tools traceroute htop iftop tcpdump lsof  iotop sysstat lsof dstat bash-completion rsync jq



# add postgresql repository 
sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

sudo apt install postgresql-18




sudo su - postgres
psql -c "alter user postgres with password 'test222'"
psql

select version();
select current_user;
\du # list of roles

select datname from pg_database; # list all databases;
\l   # list all database too with details


vim /etc/postgresql/18/main/postgresql.conf
-------
# listen_addresses = '127.0.0.1'
listen_addresses = '0.0.0.0'
-------


vim /etc/postgresql/18/main/pg_hba.conf
------
# Accept from anywhare
#host    all     all             0.0.0.0/0                 md5

# Accept from trusted subnets
host    all     all             192.168.96.0/24                 md5
------

systemctl restart postgresql


psql -h 192.168.96.141 -p 5432 -U postgres

psql -h 192.168.96.141 -p 5432 -d database-name -U username  -W
psql -h 192.168.96.141 -p 5432 -d postgres -U postgres  -W  -c "select current_time"



# increase postgres security by forcing anyone to provide password when login
vim /etc/postgresql/18/main/pg_hba.conf
# comment the peer and change to md5 like below
------
# local   all             postgres                                peer
local   all             postgres                                md5
------



```


# Setup patroni

* node1 : 192.168.85.71
* node2 : 192.168.85.72
* node3 : 192.168.85.73


# node1
```sh

systemctl stop postgresql
systemctl disable postgresql



wget https://github.com/etcd-io/etcd/releases/download/v3.5.14/etcd-v3.5.14-linux-amd64.tar.gz
tar -xvf etcd-v3.5.14-linux-amd64.tar.gz
sudo cp etcd-v3.5.14-linux-amd64/etcd* /usr/local/bin/
etcd --version
sudo useradd --system --home /var/lib/etcd --shell /sbin/nologin etcd

sudo mkdir -p /var/lib/etcd
sudo chown etcd:etcd /var/lib/etcd
sudo chown -R etcd:etcd /var/lib/etcd
sudo chmod -R 700 /var/lib/etcd
sudo rm -rf /var/lib/etcd/*


sudo nano /usr/lib/systemd/system/etcd.service
-----
[Unit]
Description=etcd key-value store
Documentation=https://etcd.io/docs/
After=network.target

[Service]
Type=notify
User=root
ExecStart=/usr/local/bin/etcd \
  --name node1 \
  --listen-peer-urls http://192.168.85.71:2380 \
  --listen-client-urls http://192.168.85.71:2379,http://127.0.0.1:2379 \
  --initial-advertise-peer-urls http://192.168.85.71:2380 \
  --advertise-client-urls http://192.168.85.71:2379 \
  --initial-cluster node1=http://192.168.85.71:2380 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster-state new \
  --data-dir /var/lib/etcd

Restart=on-failure
RestartSec=5s
StartLimitIntervalSec=60s
StartLimitBurst=3
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
-----


sudo systemctl stop etcd
sudo pkill -f etcd
sudo systemctl daemon-reload
sudo systemctl enable etcd

sudo systemctl restart etcd
sudo systemctl status etcd

```

## install patroni
```sh

sudo useradd --system --home /var/lib/patroni-cluster --shell /sbin/nologin patroni-cluster
sudo mkdir -p /var/lib/patroni-cluster
cd /var/lib/patroni-cluster
apt install python3-venv
python3 -m venv venv
source venv/bin/activate
pip3 install psycopg2-binary
pip3 install "patroni[etcd]"
deactivate


sudo chown -R patroni-cluster:patroni-cluster /var/lib/patroni-cluster
sudo chmod -R 770 /var/lib/patroni-cluster
# sudo usermod -aG <groupname> <username>
sudo usermod -aG patroni-cluster postgres


systemctl start postgresql
su postgres
psql
CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicator_pass';
\q

systemctl stop postgresql


# config patroni
sudo nano /etc/patroni.yml
----
scope: postgres_cluster
log:
  level: DEBUG
namespace: /db/
name: node1

restapi:
  listen: 192.168.85.71:8008
  connect_address: 192.168.85.71:8008
etcd3:
  hosts:
    - 192.168.85.71:2379
    #- 192.168.85.72:2379   
    #- 192.168.85.73:2379   
postgresql:
  listen: 192.168.85.71:5432
  connect_address: 192.168.85.71:5432
  data_dir: /var/lib/postgresql/18/main
  bin_dir: /usr/lib/postgresql/18/bin/
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: test222
  parameters:
    unix_socket_directories: '/var/run/postgresql'
----


# systemd unit file for patroni
sudo nano /usr/lib/systemd/system/patroni.service
------
[Unit]
Description=Patroni PostgreSQL HA Cluster Node
After=network.target

[Service]
Type=simple
User=postgres
Group=postgres
ExecStart=/var/lib/patroni-cluster/venv/bin/patroni /etc/patroni.yml
KillMode=process
Restart=on-failure
LimitNOFILE=262144

[Install]
WantedBy=multi-user.target
------

systemctl daemon-reload
systemctl enable --now patroni.service


patronictl -c /etc/patroni.yml list
patronictl -c /etc/patroni.yml failover


curl http://192.168.85.71:8008/ | jq
journalctl -u patroni -f


psql -h 192.168.85.71 -p 5432 -U postgres -c "SELECT pg_is_in_recovery();"   # if returns: f -> leader
                                                                             # if returns: t -> replica


deactivate

```

## install haproxy

```sh

apt install haproxy
cd /etc/haproxy
cp haproxy.cfg haproxy.cfg.backup

vim /etc/haproxy/haproxy.cfg
----
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

defaults
    mode                    tcp
    log                     global
    option                  tcplog
    timeout connect         10s
    timeout client          3m
    timeout server          3m
    retries                 3

# Frontend for write connections (primary only)
frontend pgsql_write_front
    bind *:15432
    default_backend pgsql_write_back

# Frontend for read connections (replicas only)
frontend pgsql_read_front
    bind *:15433
    default_backend pgsql_read_back

# Backend for writes - primary node only
backend pgsql_write_back
    mode tcp
    balance first
    option httpchk GET /primary
    http-check expect status 200
    default-server inter 5s fall 5 rise 2 on-marked-down shutdown-sessions
    server node1 192.168.85.71:5432 check port 8008
    server node2 192.168.85.72:5432 check port 8008
    server node3 192.168.85.73:5432 check port 8008

# Backend for reads - replicas only
backend pgsql_read_back
    mode tcp
    balance roundrobin
    option httpchk GET /replica
    http-check expect status 200
    default-server inter 5s fall 5 rise 2 on-marked-down shutdown-sessions
    server node1 192.168.85.71:5432 check port 8008
    server node2 192.168.85.72:5432 check port 8008
    server node3 192.168.85.73:5432 check port 8008

# HAProxy status panel
frontend stats
    bind *:8080
    mode http
    stats enable
    stats uri /stats
    stats refresh 30s
    stats admin if TRUE
----


haproxy -c -f /etc/haproxy/haproxy.cfg

sudo systemctl enable haproxy
sudo systemctl restart haproxy
sudo systemctl status haproxy.service


# open in web browser:    --->  http://192.168.85.71:8080/stats


```

### install keepalived
```sh
sudo apt install keepalived

ip a
sudo nano /etc/keepalived/check_patroni.sh
----
#!/bin/bash

NODE_IP="192.168.85.71"

STATUS=$(curl -sf http://$NODE_IP:8008/health)
IS_RUNNING=$(echo "$STATUS" | jq -r .state)
ROLE=$(echo "$STATUS" | jq -r .role)

echo "STATE: $IS_RUNNING"
echo "ROLE: $ROLE"

if [ "$IS_RUNNING" = "running" ] && [ "$ROLE" = "primary" ]; then
  echo "✅ This node is the LEADER (primary) and is RUNNING."
  exit 0
else
  echo "❌ This node is NOT the leader or is not running."
  exit 1
fi
----

sudo nano /etc/keepalived/keepalived.conf
------
global_defs {
   notification_email {
     imanjowkar@gmail.com
   }
   notification_email_from imanjowkar@gmail.com
   smtp_server 192.168.200.1
   router_id my_router
   script_user root
   enable_script_security
}

vrrp_script chk_patroni {
    script "/etc/keepalived/check_patroni.sh"
    interval 3
    fall 2
    rise 1
}

vrrp_instance VI_1 {
    state BACKUP                # All start as BACKUP
    interface ens33            # Change to your real interface, if different
    virtual_router_id 51
    priority 100               # Same priority for all
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.85.199
    }
    track_script {
        chk_patroni
    }
}
------


sudo chmod +x /etc/keepalived/check_patroni.sh
sudo systemctl restart haproxy
sudo systemctl enable keepalived
sudo systemctl restart keepalived

sudo systemctl status haproxy
sudo systemctl status keepalived


# clone the machine
sudo systemctl stop patroni
sudo systemctl stop haproxy
sudo shutdown -h now

```
##### clone the machine ok.

# node2

```sh
# on node 85.72
# 1. change ip address

# 2. change hostname
hostnamectl set-hostname node2
vim /etc/hosts
----
127.0.1.1       node2
----



systemctl stop haproxy.service
systemctl stop keepalived.service
systemctl stop patroni.service
systemctl stop etcd
systemctl stop postgresql



# 3. remove the datadir in second node
rm -rf /var/lib/etcd/member/
rm -rf /var/lib/postgresql/18/main/*



# on node 85.71
# 4. add member in etcd
etcdctl --endpoints="http://192.168.85.71:2379" member add node2 --peer-urls="http://192.168.85.72:2380"



# on node node2
nano /usr/lib/systemd/system/etcd.service
-----
[Unit]
Description=etcd key-value store
Documentation=https://etcd.io/docs/
After=network.target

[Service]
Type=notify
User=root
ExecStart=/usr/local/bin/etcd \
  --name node2 \
  --listen-peer-urls http://192.168.85.72:2380 \
  --listen-client-urls http://192.168.85.72:2379,http://127.0.0.1:2379 \
  --initial-advertise-peer-urls http://192.168.85.72:2380 \
  --advertise-client-urls http://192.168.85.72:2379 \
  --initial-cluster node1=http://192.168.85.71:2380,node2=http://192.168.85.72:2380 \
  --initial-cluster-state existing \
  --data-dir /var/lib/etcd

Restart=on-failure
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
-----

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
sudo systemctl status etcd


#  Validate the cluster
etcdctl --endpoints="http://192.168.85.71:2379,http://192.168.85.72:2379" endpoint status --write-out=table



# config patroni

vim /etc/patroni.yml
----
scope: postgres_cluster
log:
  level: DEBUG
namespace: /db/
name: node2

restapi:
  listen: 192.168.85.72:8008
  connect_address: 192.168.85.72:8008
etcd3:
  hosts:
    - 192.168.85.71:2379
    - 192.168.85.72:2379
    #- 192.168.85.73:2379
postgresql:
  listen: 192.168.85.72:5432
  connect_address: 192.168.85.72:5432
  data_dir: /var/lib/postgresql/18/main
  bin_dir: /usr/lib/postgresql/18/bin/
  config_dir: /etc/postgresql/18/main
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: test222
  parameters:
    unix_socket_directories: '/var/run/postgresql'
----


# in ALL node
## add replicator in All node in pg_hba.conf
vim /etc/postgresql/18/main/pg_hba.conf
-----
host    replication     replicator      192.168.85.0/24          md5
-----


# in node 1 uncomment second node like this
vim  /etc/patroni.yml
------------
scope: postgres_cluster
log:
  level: DEBUG
namespace: /db/
name: node1

restapi:
  listen: 192.168.85.71:8008
  connect_address: 192.168.85.71:8008
etcd3:
  hosts:
    - 192.168.85.71:2379
    - 192.168.85.72:2379
    #- 192.168.85.73:2379
postgresql:
  listen: 192.168.85.71:5432
  connect_address: 192.168.85.71:5432
  data_dir: /var/lib/postgresql/18/main
  bin_dir: /usr/lib/postgresql/18/bin/
  config_dir: /etc/postgresql/18/main
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: test222
  parameters:
    unix_socket_directories: '/var/run/postgresql'
----------


systemctl restart patroni.service
systemctl status patroni.service


patronictl -c /etc/patroni.yml list

# backup to node 2

systemctl start haproxy.service

sudo nano /etc/keepalived/check_patroni.sh
------
NODE_IP="192.168.85.71"
------

systemctl start keepalived.service

```

# node3

```sh
# 1. change ip address

# 2. change hostname
hostnamectl set-hostname node2
vim /etc/hosts
----
127.0.1.1       node2
----



systemctl stop haproxy.service
systemctl stop keepalived.service
systemctl stop patroni.service
systemctl stop etcd
systemctl stop postgresql



# 3. remove the datadir in second node
rm -rf /var/lib/etcd/member/
rm -rf /var/lib/postgresql/18/main/*




# 4. add member in etcd
# find the leader using below command and use the leader ip address


patronictl -c /etc/patroni.yml list
+ Cluster: postgres_cluster (7574304059501439600) --+-------------+-----+------------+-----+
| Member | Host          | Role    | State     | TL | Receive LSN | Lag | Replay LSN | Lag |
+--------+---------------+---------+-----------+----+-------------+-----+------------+-----+
| node1  | 192.168.85.71 | Replica | streaming |  9 |   0/3000690 |   0 |  0/3000690 |   0 |
| node2  | 192.168.85.72 | Leader  | running   |  9 |             |     |            |     |
+--------+---------------+---------+-----------+----+-------------+-----+------------+-----+

etcdctl --endpoints="http://192.168.85.72:2379" member add node3 --peer-urls="http://192.168.85.73:2380"


nano /usr/lib/systemd/system/etcd.service
-----
[Unit]
Description=etcd key-value store
Documentation=https://etcd.io/docs/
After=network.target

[Service]
Type=notify
User=root
ExecStart=/usr/local/bin/etcd \
  --name node2 \
  --listen-peer-urls http://192.168.85.72:2380 \
  --listen-client-urls http://192.168.85.72:2379,http://127.0.0.1:2379 \
  --initial-advertise-peer-urls http://192.168.85.72:2380 \
  --advertise-client-urls http://192.168.85.72:2379 \
  --initial-cluster node1=http://192.168.85.71:2380,node2=http://192.168.85.72:2380 \
  --initial-cluster-state existing \
  --data-dir /var/lib/etcd

Restart=on-failure
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
-----

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
sudo systemctl status etcd


#  Validate the cluster
etcdctl --endpoints="http://192.168.85.71:2379,http://192.168.85.72:2379" endpoint status --write-out=table



# config patroni

vim /etc/patroni.yml
----
scope: postgres_cluster
log:
  level: DEBUG
namespace: /db/
name: node2

restapi:
  listen: 192.168.85.72:8008
  connect_address: 192.168.85.72:8008
etcd3:
  hosts:
    - 192.168.85.71:2379
    - 192.168.85.72:2379
    #- 192.168.85.73:2379
postgresql:
  listen: 192.168.85.72:5432
  connect_address: 192.168.85.72:5432
  data_dir: /var/lib/postgresql/18/main
  bin_dir: /usr/lib/postgresql/18/bin/
  config_dir: /etc/postgresql/18/main
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: test222
  parameters:
    unix_socket_directories: '/var/run/postgresql'
----


# in ALL node
## add replicator in All node in pg_hba.conf
vim /etc/postgresql/18/main/pg_hba.conf
-----
host    replication     replicator      192.168.85.0/24          md5
-----


# in node 1 uncomment second node like this
vim  /etc/patroni.yml
------------
scope: postgres_cluster
log:
  level: DEBUG
namespace: /db/
name: node1

restapi:
  listen: 192.168.85.71:8008
  connect_address: 192.168.85.71:8008
etcd3:
  hosts:
    - 192.168.85.71:2379
    - 192.168.85.72:2379
    #- 192.168.85.73:2379
postgresql:
  listen: 192.168.85.71:5432
  connect_address: 192.168.85.71:5432
  data_dir: /var/lib/postgresql/18/main
  bin_dir: /usr/lib/postgresql/18/bin/
  config_dir: /etc/postgresql/18/main
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: test222
  parameters:
    unix_socket_directories: '/var/run/postgresql'
----------


systemctl restart patroni.service
systemctl status patroni.service


patronictl -c /etc/patroni.yml list

# backup to node 2

systemctl start haproxy.service

sudo nano /etc/keepalived/check_patroni.sh
------
NODE_IP="192.168.85.71"
------

systemctl start keepalived.service

```