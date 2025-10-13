# Postgresql
[End of life postgresql](https://endoflife.date/postgresql)


[installation](https://www.postgresql.org/download/)

## install on debain
[ref](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart)

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


# MVCC
MVCC stands for Multi-Version Concurrency Control, and it is a critical feature of PostgreSQL and other relational database management systems (RDBMS). MVCC is used to manage concurrent access to data in a way that allows multiple transactions to read and write data without interfering with each other while maintaining data consistency and integrity.


MVCC in PostgreSQL allows for high levels of concurrency in database operations, as multiple transactions can read and write data simultaneously without waiting for locks. It also provides strong data consistency and isolation between transactions, allowing them to work independently without interfering with each other.

Different database systems implement MVCC in their own ways, but the fundamental principle of managing concurrent access through versioning data and transaction snapshots is common to most modern RDBMS, including PostgreSQL.




# Clustering  with patroni + HAproxy + etcd
---

## 🧩 Components Overview

### 1. **PostgreSQL**

* The actual **database engine**.
* Runs on multiple nodes — typically:

  * **One primary** (read/write)
  * **One or more replicas** (read-only)

### 2. **Patroni**

* A **high-availability orchestration tool** for PostgreSQL.
* Handles **automatic failover**, **replication management**, and **cluster state synchronization**.
* Communicates with a **distributed configuration store (DCS)** — e.g., **etcd** — to determine which node is the primary.
* Manages PostgreSQL instances via local control and writes cluster state info to etcd.

### 3. **etcd**

* A **distributed key-value store** used by Patroni for:

  * **Leader election**
  * **Cluster configuration**
  * **Health/status information**
* Keeps consensus among nodes (usually runs as a 3-node cluster for quorum).

### 4. **HAProxy**

* A **TCP load balancer** that routes client connections.
* Checks which PostgreSQL node is **primary** (through Patroni REST API).
* Routes:

  * Write queries → primary node
  * Read queries → replicas (if configured for read scaling)

---

## 🏗️ Architecture Diagram (Conceptual)

```
                   ┌──────────────────────────┐
                   │        Clients           │
                   │  (Apps, APIs, Tools)     │
                   └────────────┬─────────────┘
                                │
                                ▼
                     ┌────────────────────┐
                     │     HAProxy        │
                     │ - Routes traffic   │
                     │ - Health checks    │
                     └────────┬───────────┘
                              │
     ┌────────────────────────┼─────────────────────────┐
     ▼                        ▼                         ▼
┌────────────┐         ┌────────────┐           ┌────────────┐
│ PostgreSQL │         │ PostgreSQL │           │ PostgreSQL │
│  Primary   │         │  Replica 1 │           │  Replica 2 │
│ + Patroni  │         │ + Patroni  │           │ + Patroni  │
└─────┬──────┘         └─────┬──────┘           └─────┬──────┘
      │                      │                        │
      └──────────┬───────────┴──────────┬─────────────┘
                 ▼                      ▼
         ┌────────────────────────────────────┐
         │              etcd Cluster          │
         │ (3 nodes recommended for quorum)   │
         └────────────────────────────────────┘
```

---

## ⚙️ Workflow Explanation

### 1. **Cluster Initialization**

* Patroni starts on all PostgreSQL nodes.
* Each Patroni instance registers itself in **etcd**.
* One node is elected as **leader (primary)**; others become **replicas**.

### 2. **Normal Operation**

* The primary node handles **read/write** traffic.
* Replicas replicate data using **streaming replication** from the primary.
* Patroni continuously updates its status in etcd.

### 3. **Monitoring & Load Balancing**

* **HAProxy** periodically queries Patroni’s REST API (`:8008/health`) to see which node is the leader.
* It routes connections to the current primary for writes (and optionally replicas for reads).

### 4. **Failover**

* If the primary fails:

  * Patroni detects the failure (no heartbeat, or PostgreSQL down).
  * The remaining Patroni nodes coordinate via **etcd**.
  * A new leader is elected and promoted to **primary**.
  * etcd updates the cluster state.
  * HAProxy automatically redirects clients to the new primary (via updated health checks).

---

## 🧠 Key Advantages

✅ **Automatic failover** – No manual intervention needed.
✅ **Consistent cluster state** – Managed via etcd.
✅ **Centralized health checking** – via Patroni REST API.
✅ **Seamless client redirection** – via HAProxy.
✅ **Scalable** – Add replicas for load distribution.

---

## 🧩 Typical Node Setup Example

| Node     | Role                 | Components                                |
| -------- | -------------------- | ----------------------------------------- |
| node1    | PostgreSQL + Patroni | May become Primary                        |
| node2    | PostgreSQL + Patroni | Replica                                   |
| node3    | PostgreSQL + Patroni | Replica                                   |
| etcd1    | etcd                 | Member of etcd cluster                    |
| etcd2    | etcd                 | Member of etcd cluster                    |
| etcd3    | etcd                 | Member of etcd cluster                    |
| haproxy1 | HAProxy              | Routes traffic to correct PostgreSQL node |

---


we use 
# node1 - postgresql-1
```sh

hostnmaectl set-hostname pg-1


sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql

# Install PostgreSQL:
sudo dnf install -y postgresql17-server

systemctl stop postgresql-17.service
systemctl disable postgresql-17.service


dnf install epel-release
dnf makecache
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
StartLimitIntervalSec=60s
StartLimitBurst=3
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
------------------

systemctl daemon-reload
systemctl enable --now etcd


# Installing Patroni
dnf install python3-pip gcc python3-devel

pip install psycopg2-binary "patroni[etcd]"



```