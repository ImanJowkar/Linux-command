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
# install on ubuntu
sudo apt update
sudo apt install postgresql postgresql-contrib



# install on debain
apt install postgresql postgresql-client



# in debain config file stored in `/etc/postgresql/...`
```

## install on Reocky linux

[ref](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-rocky-linux-9)

```sh
# Install the repository RPM:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql

# Install PostgreSQL:
sudo dnf install -y postgresql17-server

# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-17/bin/postgresql-17-setup initdb
sudo systemctl enable postgresql-17
sudo systemctl start postgresql-17


firewall-cmd --add-service=postgresql  --permanent
firewall-cmd --reload



sudo su - postgres
psql -c "alter user postgres with password 'test222'"
psql

select version();
select current_user;
\du # list of roles

select datname from pg_database; # list all databases;
\l   # list all database too with details


```

```sql
create database zbx;
select oid, datname FROM pg_database;
\q
```
```sh
cd /var/lib/pgsql/17/data/base
ls -lah 

```
![datadir](img/1.png)

```sh
vim /var/lib/pgsql/17/data/postgresql.conf
-------
listen_addresses = '192.168.96.141'
# listen_addresses = '*'
-------

vim /var/lib/pgsql/17/data/pg_hba.conf
------
# Accept from anywhare
#host    all     all             0.0.0.0/0                 md5

# Accept from trusted subnets
host    all     all             192.168.96.0/24                 md5
------

systemctl restart postgresql-17.service


psql -h 192.168.96.141 -p 5432 -U postgres

psql -h 192.168.96.141 -p 5432 -d database-name -U username  -W
psql -h 192.168.96.141 -p 5432 -d postgres -U postgres  -W  -c "select current_time"

```

## SETUP PG-admin

```sh

docker run -p 80:80 --name mypgadmin \
    -e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
    -e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
    -e 'PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION=True' \
    -e 'PGADMIN_CONFIG_LOGIN_BANNER="Authorised users only!"' \
    -e 'PGADMIN_CONFIG_CONSOLE_LOG_LEVEL=10' \
    -d hub.hamdocker.ir/dpage/pgadmin4:9.8.0
```




```yaml
version: "3.9"
services:
  pgadmin:
    image: hub.hamdocker.ir/dpage/pgadmin4:9.8.0
    container_name: pgadmin
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com   # change to your email
      PGADMIN_DEFAULT_PASSWORD: admin          # change to a strong password
      PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION: True
    ports:
      - "8080:80"   # access pgAdmin at http://localhost:8080
    volumes:
      - pgadmin_data:/var/lib/pgadmin  # persistent storage for pgAdmin
volumes:
  pgadmin_data:


```




## Setup pgcli
```sh
mkdir python-pgcli && cd python-pgcli

python -m venv venv
source venv/bin/activate

pip install -U pgcli

pgcli postgres://postgres:test222@192.168.96.141:5432/

pgcli -h 192.168.96.141 -p 5432 -d postgres -U postgres  -W

select version();



```
## Work with postgresql
```sh
\d table_name
\du   # list all user and roles

\s   # list history
\s myhistory.sql  # save history into a file


\e   # give you the file editor and insert you sql syntax and close the file it will run for us.

```

### Database administration

```sh
pgcli -h 192.168.96.141 -p 5432 -d postgres -U postgres  -W
```
```sql
select name, setting FROM pg_settings where category = 'File Locations';



```




### Basic configuration
```sh

psql
pg_isready
pg_lsclusters

sudo su postgres
psql
psql -U <username> -P <port> -h <IP-address> -d <db-name>  -W

help
\q                  # for quit
\conninfo           # show to connection information
\l                  # list databases
\dt                 # list tables
\c <database-name>  # connect to database



create database mydb;
drop database mydb1;




```
`template0` is a pristine template that is read-only and should not be modified.

`template1` is a template database that can be modified. It is used as a base for creating new databases and can include common schema objects or settings that you want to be present in all new databases.


```sh

create database test template template0;

create database mydb;
\c mydb;
create table users(id integer not null , username varchar(40), lastnme varchar(64));

\d users;


select * from users;
```



### User Management
```sh
\du     # list all roles in postgres
create role iman with login ;
create role iman1 with login superuser;



alter user iman with password 'pass'; # change user password for user iman

\password iman1   # another way to change password for a user

alter user iman1 with nosuperuser ;


psql -U iman1 -h localhost  -d postgres -W


# change the pg_hba.conf

host    all             iman1           192.168.56.1/32         md5



```






# Create a database and user and restore database
[ref](https://www.w3schools.com/postgresql/postgresql_insert_into.php)
```sh
create database store;
\c store;


CREATE TABLE cars (
  brand VARCHAR(255),
  model VARCHAR(255),
  year INT
);

INSERT INTO cars (brand, model, year)
VALUES
  ('Volvo', 'p1800', 1968),
  ('BMW', 'M1', 1978),
  ('Toyota', 'Celica', 1975);


\dt
select * from cars;






# pg_dump     # allows you to backup from  a database
# pg_dumpall  # allows you to backup from all database
# pg_restore  # for restore

pg_dump -U <user> <database>

pg_dump -U test store > store-backup.sql
# or you can use bellow option
pg_dump -U test -f store-backup.sql store



# for restore, you have two option:
# 1) go to the postgres console: 

psql -U <user>
\i store-backup.sql



#### store output with another format
pg_dump -U <user> -Fc -f store-backup.backup <db_name>  # store in binary format


pg_restore -U test -C -d postgres store-backup.backup



pg_dump -U <user> -Ft -f store-backup.tar <db_name>  # store in tar format

pg_restore -U test -C -d postgres store-backup.tar




pg_dump -U <user> -Fd -f store-backup-directory <db_name>  # store in directory format

pg_restore -U test -C -d postgres store-backup-directory/ # -C means create database , -d means connect to database and create database


```



## Create Table
```sql

CREATE TABLE IF NOT EXISTS public.movie
(
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    release_date date NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.category
(
    id bigint NOT NULL,
    name character varying(256) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.movie_category
(
    id integer NOT NULL,
    film_id integer NOT NULL,
    category_id integer NOT NULL,
    CONSTRAINT files_category_pkey PRIMARY KEY (id)
);

```


# Query

```sql
select * from film limit 15;

select * from film where id=4;

select * from film where id=4 or id=6;

select col1, col2 from file where id=4 or id=6;


select first_name || ' ' || last_name as full_name from name;

SELECT count(*) from categories;


```

# WAL
In PostgreSQL, WAL stands for Write-Ahead Logging. It is a critical component of the database's durability and crash recovery mechanisms. Here's what WAL is and how it works:

1. **Write-Ahead Logging (WAL)**: WAL is a method used by PostgreSQL to ensure that changes made to the database are durable, meaning they are permanent and survive system crashes or failures. Instead of writing data directly to the database files, PostgreSQL first writes changes to a transaction log, and then it applies these changes to the database itself.

2. **Transaction Logs**: The transaction log is a sequential file where all changes (inserts, updates, and deletes) made to the database are recorded in a detailed and sequential manner. Each record in the transaction log represents a change or action.

3. **Durability and Crash Recovery**: The use of WAL ensures that even if a crash occurs (e.g., a power failure or a system crash), PostgreSQL can recover the database to a consistent state by replaying the transactions recorded in the log. This guarantees that no committed transactions are lost and the database remains in a consistent state.

4. **Performance Benefits**: Writing changes to the transaction log is typically faster than writing directly to the database files because it involves sequential writes rather than random access writes. This can lead to improved database write performance.

5. **Archiving and Replication**: WAL logs can also be used for other purposes like database replication and point-in-time recovery. They can be archived and shipped to other servers for replication, backup, or other purposes.

In summary, Write-Ahead Logging (WAL) is a fundamental mechanism in PostgreSQL that enhances the durability, reliability, and performance of the database system. It helps ensure data consistency and recoverability in the face of system failures.




# Clustering  with patroni + HAproxy + etcd

* VIP: 192.168.96.200
* pg-1: 192.168.96.201   ( Postgresql + etcd + Patroni)
* pg-2: 192.168.96.202   ( Postgresql + etcd + Patroni)
* pg-3: 192.168.96.203   ( Postgresql + etcd + Patroni)


## type of replication in postgresql

---

### 🧱 **PostgreSQL Replication Types**

| Type                     | Level       | Description                                                                                                |
| ------------------------ | ----------- | ---------------------------------------------------------------------------------------------------------- |
| **Physical replication** | Block level | Copies WAL files from primary to standby. Used for HA and backups.                                         |
| **Logical replication**  | SQL level   | Replicates specific tables or data changes (INSERT, UPDATE, DELETE). Used for migrations or partial syncs. |

---

### ⚙️ **Patroni**

* Works at the **physical replication level** (streaming replication).
* Automates **failover**, **replica promotion**, and **cluster management** using **etcd, Consul, or Kubernetes**.
* Provides **high availability** for PostgreSQL clusters.

---

🟢 **In short:**
> PostgreSQL has **physical** and **logical** replication.
> **Patroni** manages **physical (streaming)** replication to provide automatic failover and high availability.




# node1 - postgresql-1   - 192.168.96.201
```sh

hostnmaectl set-hostname pg-1


sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql

# Install PostgreSQL:
sudo dnf install -y postgresql17-server

sudo /usr/pgsql-17/bin/postgresql-17-setup initdb
sudo systemctl enable postgresql-17
sudo systemctl start postgresql-17


firewall-cmd --add-service=postgresql  --permanent  # postgresql
firewall-cmd --add-port=8008/tcp --permanent        # patroni
firewall-cmd --reload

sudo su - postgres
psql -c "alter user postgres with password 'test222'"
psql

vim /var/lib/pgsql/17/data/pg_hba.conf
---------
host    all             all             192.168.96.0/24            scram-sha-256
---------



systemctl restart postgresql-17.service


systemctl stop postgresql-17.service
systemctl disable postgresql-17.service


# dnf install epel-release
dnf makecache
dnf install curl wget 
wget https://github.com/etcd-io/etcd/releases/download/v3.5.23/etcd-v3.5.23-linux-amd64.tar.gz
tar -xzvf etcd-v3.5.23-linux-amd64.tar.gz
cp etcd-v3.5.23-linux-amd64/etcd* /usr/local/bin/

etcd --version
useradd --system --home-dir /var/lib/etcd --shell /sbin/nologin etcd
mkdir -p /var/lib/etcd
chown -R etcd: /var/lib/etcd/
chmod -R 700 /var/lib/etcd/

# create systemd unit file
sudo vim  /etc/systemd/system/etcd.service
---------------------
[Unit]
Description=etcd key-value store
Documentation=https://etcd.io/docs/
After=network.target

[Service]
Type=notify
User=root
ExecStart=/usr/local/bin/etcd \
  --name node1 \
  --listen-peer-urls http://192.168.96.201:2380 \
  --listen-client-urls http://192.168.96.201:2379,http://127.0.0.1:2379 \
  --initial-advertise-peer-urls http://192.168.96.201:2380 \
  --advertise-client-urls http://192.168.96.201:2379 \
  --initial-cluster node1=http://192.168.96.201:2380 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster-state new \
  --data-dir /var/lib/etcd

Restart=on-failure
RestartSec=5s
# StartLimitIntervalSec=60s
StartLimitBurst=3
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
------------------

sudo systemctl daemon-reload
sudo systemctl enable --now etcd


# Installing Patroni
su - postgres
python3 -m venv venv
source venv/bin/activate
dnf install python3-pip gcc python3-devel
pip install psycopg2-binary "patroni[etcd]"



# Create a user for patroni
sudo systemctl start postgresql-17
sudo -i -u postgres
psql -U postgres

CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicator_pass';
\q
exit



systemctl stop postgresql-17.service
systemctl disable postgresql-17.service



# Create patroni config file

vim /etc/patroni.yml
------------
scope: postgres_cluster
log:
  level: DEBUG
namespace: /db/
name: node1

restapi:
  listen: 192.168.96.201:8008
  connect_address: 192.168.96.201:8008

etcd3:
  hosts:
    - 192.168.96.201:2379
#    - 192.168.96.202:2379
#    - 192.168.96.203:2379
postgresql:
  listen: 192.168.96.201:5432
  connect_address: 192.168.96.201:5432
  data_dir: /var/lib/pgsql/17/data
  bin_dir: /usr/pgsql-17/bin
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: test222
  parameters:
    unix_socket_directories: '/var/run/postgresql'
-------------



# create systemd unit file for patroni
sudo vim /etc/systemd/system/patroni.service
-------------
[Unit]
Description=Patroni PostgreSQL HA Cluster Node
After=network.target

[Service]
Type=simple
User=postgres
Group=postgres
ExecStart=/var/lib/pgsql/venv/bin/patroni /etc/patroni.yml
KillMode=process
Restart=on-failure
LimitNOFILE=262144

[Install]
WantedBy=multi-user.target

-------------

sudo systemctl daemon-reload
sudo systemctl enable patroni
sudo systemctl restart patroni
sudo systemctl status patroni


# view the log file
sudo -u postgres tail -n 20 /var/lib/pgsql/17/data/log/postgresql-*.log


sudo -u postgres /var/lib/pgsql/venv/bin/patronictl -c /etc/patroni.yml list

curl -v http://192.168.96.201:2379/version



```
Test the connection to PostgreSQL on the leader node.
If your Patroni is configured to run PostgreSQL
on port 5432 (default), test the connection with:

RUN*
```sh
psql -h 192.168.1.188 -p 5432 -U postgres -c "SELECT pg_is_in_recovery();"
```
 pg_is_in_recovery
-------------------
 f
(1 row)


If the result is false, it means you are connected to the leader node
(not in recovery mode).
If it is true, it is a secondary (standby) node.

```sh
etcdctl endpoint health

```

### config selinux

### 🧱 Step 1. Identify the current context

```bash
ls -Z /var/lib/pgsql/venv/bin/python
ls -Z /var/lib/pgsql/venv/bin/patroni
```

You’ll likely see both are `postgresql_exec_t`.

---

### ⚙️ Step 2. Change to a neutral, executable type

Use `semanage fcontext` and `restorecon` to relabel them as `bin_t`:

```bash
sudo semanage fcontext -a -t bin_t "/var/lib/pgsql/venv(/.*)?"
sudo restorecon -Rv /var/lib/pgsql/venv
```

Then verify:

```bash
ls -Z /var/lib/pgsql/venv/bin/python /var/lib/pgsql/venv/bin/patroni
```

Expected output:

```
system_u:object_r:bin_t:s0 /var/lib/pgsql/venv/bin/python
system_u:object_r:bin_t:s0 /var/lib/pgsql/venv/bin/patroni
```

---

### 🧩 Step 3. Restart Patroni safely

```bash
sudo systemctl daemon-reload
sudo systemctl restart patroni
sudo systemctl status patroni
```

---

### 🧠 Step 4 (Optional): verify SELinux no longer complains

```bash
sudo ausearch -m avc -ts recent | grep patroni
```

You should see no new denials.

---


#### install haproxy
```sh
cd  /etc/haproxy/
rm -rf haproxy.cfg
vim /etc/haproxy/haproxy.cfg
------
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
    server node1 192.168.96.201:5432 check port 8008
    server node2 192.168.96.202:5432 check port 8008
    server node3 192.168.96.203:5432 check port 8008

# Backend for reads - replicas only
backend pgsql_read_back
    mode tcp
    balance roundrobin
    option httpchk GET /replica
    http-check expect status 200
    default-server inter 5s fall 5 rise 2 on-marked-down shutdown-sessions
    server node1 192.168.96.201:5432 check port 8008
    server node2 192.168.96.202:5432 check port 8008
    server node3 192.168.96.203:5432 check port 8008

# HAProxy status panel
frontend stats
    bind *:8080
    mode http
    stats enable
    stats uri /stats
    stats refresh 30s
    stats admin if TRUE


------


haproxy -c -f /etc/haproxy/haproxy.cfg


```

##### Configuring SELinux

Change SELinux policy to allow HAProxy to make connections to PostgreSQL on ports 15432 and 15433:

**RUN:**

```sh
sudo setsebool -P haproxy_connect_any 1
```

Add ports for HAProxy in SELinux (if they don't exist yet):

**RUN:**

```sh
sudo semanage port -a -t postgresql_port_t -p tcp 15432
sudo semanage port -a -t postgresql_port_t -p tcp 15433
sudo semanage port -m -t postgresql_port_t -p tcp 15432
sudo semanage port -m -t postgresql_port_t -p tcp 15433
```

**RUN:**

```sh
sudo systemctl enable haproxy
sudo systemctl restart haproxy
sudo systemctl status haproxy.service
```


## keepalived

```sh
sudo dnf install keepalived

```

configuration of keepalived 

```sh

sudo vim /etc/keepalived/check_patroni.sh
-----
#!/bin/bash

NODE_IP="192.168.96.201"

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
-----


sudo vim /etc/keepalived/keepalived.conf
----------
global_defs {
   notification_email {
     youremail@example.com
   }
   notification_email_from youremail@example.com
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
    interface ens160            # Change to your real interface, if different
    virtual_router_id 51
    priority 100               # Same priority for all
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.96.200
    }
    track_script {
        chk_patroni
    }
}

----------

sudo chmod +x /etc/keepalived/check_patroni.sh
sudo systemctl enable keepalived --now
sudo systemctl status keepalived

ip a  # you can see the 192.168.96.200   is set on your NIC 


ss -nltp | grep -E "15432|15433"
firewall-cmd --add-port=15432/tcp --permanent
firewall-cmd --add-port=15433/tcp --permanent
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

curl http://192.168.96.200:8080/stats

```


# node2 - postgresql-2    - 192.168.96.202

```sh

hostnmaectl set-hostname pg-1


sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql

# Install PostgreSQL:
sudo dnf install -y postgresql17-server

sudo /usr/pgsql-17/bin/postgresql-17-setup initdb
sudo systemctl enable postgresql-17
sudo systemctl start postgresql-17


firewall-cmd --add-service=postgresql  --permanent  # postgresql
firewall-cmd --add-port=8008/tcp --permanent        # patroni
firewall-cmd --reload

sudo su - postgres
psql -c "alter user postgres with password 'test222'"
psql

vim /var/lib/pgsql/17/data/pg_hba.conf
---------
host    all             all             192.168.96.0/24            scram-sha-256
---------



systemctl restart postgresql-17.service


systemctl stop postgresql-17.service
systemctl disable postgresql-17.service

sudo rm -rf /var/lib/pgsql/17/data/*



# dnf install epel-release
dnf makecache
dnf install curl wget 
wget https://github.com/etcd-io/etcd/releases/download/v3.5.23/etcd-v3.5.23-linux-amd64.tar.gz
tar -xzvf etcd-v3.5.23-linux-amd64.tar.gz
cp etcd-v3.5.23-linux-amd64/etcd* /usr/local/bin/

etcd --version
useradd --system --home-dir /var/lib/etcd --shell /sbin/nologin etcd
mkdir -p /var/lib/etcd
chown -R etcd: /var/lib/etcd/
chmod -R 700 /var/lib/etcd/

```


### node1 - 192.168.96.201

```sh

etcdctl --endpoints="http://192.168.96.201:2379" member add node2 --peer-urls="http://192.168.96.202:2380"


etcdctl endpoint health

```

### node2
```sh
# create systemd unit file
sudo vim  /etc/systemd/system/etcd.service
---------------------
[Unit]
Description=etcd key-value store
Documentation=https://etcd.io/docs/
After=network.target

[Service]
Type=notify
User=root
ExecStart=/usr/local/bin/etcd \
  --name node2 \
  --listen-peer-urls http://192.168.96.202:2380 \
  --listen-client-urls http://192.168.96.202:2379,http://127.0.0.1:2379 \
  --initial-advertise-peer-urls http://192.168.96.202:2380 \
  --advertise-client-urls http://192.168.96.202:2379 \
  --initial-cluster node1=http://192.168.96.201:2380,node2=http://192.168.96.202:2380 \
  --initial-cluster-state existing \
  --data-dir /var/lib/etcd

Restart=on-failure
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
------------------

sudo systemctl daemon-reload
sudo systemctl enable --now etcd

etcdctl --endpoints="http://192.168.96.201:2379,http://192.168.96.202:2379" endpoint status --write-out=table


# Installing Patroni
su - postgres
python3 -m venv venv
source venv/bin/activate
dnf install python3-pip gcc python3-devel
pip install psycopg2-binary "patroni[etcd]"



# Create patroni config file

vim /etc/patroni.yml
------------
scope: postgres_cluster

log:
  level: DEBUG
namespace: /db/

# CORRECTED: unique node name
name: node2

restapi:
  listen: 192.168.96.202:8008
  connect_address: 192.168.96.202:8008

etcd3:
  hosts:
    - 192.168.96.201:2379
    - 192.168.96.202:2379
    # - 192.168.96.203:2379   # Uncomment when node 190 is active

postgresql:
  listen: 192.168.96.202:5432
  connect_address: 192.168.96.202:5432
  data_dir: /var/lib/pgsql/17/data
  bin_dir: /usr/pgsql-17/bin
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: postgres123
  parameters:
    unix_socket_directories: '/var/run/postgresql'
-------------



# create systemd unit file for patroni
sudo vim /etc/systemd/system/patroni.service
-------------
[Unit]
Description=Patroni PostgreSQL HA Cluster Node
After=network.target

[Service]
Type=simple
User=postgres
Group=postgres
ExecStart=/var/lib/pgsql/venv/bin/patroni /etc/patroni.yml
KillMode=process
Restart=on-failure
LimitNOFILE=262144

[Install]
WantedBy=multi-user.target

-------------

sudo systemctl daemon-reload
sudo systemctl enable patroni
sudo systemctl restart patroni
sudo systemctl status patroni


# config selinux
sudo dnf install policycoreutils-python-utils -y

ls -Z /var/lib/pgsql/venv/bin/python
ls -Z /var/lib/pgsql/venv/bin/patroni

sudo semanage fcontext -a -t bin_t "/var/lib/pgsql/venv(/.*)?"
sudo restorecon -Rv /var/lib/pgsql/venv
ls -Z /var/lib/pgsql/venv/bin/python /var/lib/pgsql/venv/bin/patroni

sudo systemctl daemon-reload
sudo systemctl restart patroni
sudo systemctl status patroni

sudo ausearch -m avc -ts recent | grep patroni


```


### node1
```sh
vim /var/lib/pgsql/17/data/pg_hba.conf
------
host    replication     all             192.168.96.0/24            scram-sha-256
------

sudo systemctl restart patroni


```

### node2
```sh

sudo systemctl restart patroni

ls -lah /var/lib/pgsql/17/data/


```

### node1
```sh

vim /etc/patroni.yml
-----------
scope: postgres_cluster
log:
  level: DEBUG
namespace: /db/
name: node1

restapi:
  listen: 192.168.96.201:8008
  connect_address: 192.168.96.201:8008

etcd3:
  hosts:
    - 192.168.96.201:2379
    - 192.168.96.202:2379
#    - 192.168.96.203:2379

postgresql:
  listen: 192.168.96.201:5432
  connect_address: 192.168.96.201:5432
  data_dir: /var/lib/pgsql/17/data
  bin_dir: /usr/pgsql-17/bin
  authentication:
    replication:
      username: replicator
      password: replicator_pass
    superuser:
      username: postgres
      password: test222
  parameters:
    unix_socket_directories: '/var/run/postgresql'

-----------
systemctl restart patroni.service

```


### node2
```sh

sudo -u postgres /var/lib/pgsql/venv/bin/patronictl -c /etc/patroni.yml list

curl -v http://192.168.96.201:2379/version


```