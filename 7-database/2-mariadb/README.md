# Mariadb
### installation
[ref](https://mariadb.org/download/?t=repo-config&d=24.04+%22noble%22&v=11.4&r_m=Kernel-ir) 

Partitioning the system
* don't use swap (disable permanently)
* create seperated partition for /data, /binlog, /backup

```sh

# disable swap 
swapoff -a
# disable permanently in /etc/fstab
vim /etc/fstab

# comment the line start with /swap.img


/data
/binlog
/backup
/scripts

fdisk /dev/sdb  # change type to linux lvm
pvcreate /dev/sdb1
vgcreate mariadb /dev/sdb1

lvcreate -n data -L 10g mariadb
lvcreate -n binlog -L 10g mariadb
lvcreate -n scripts -L 10g mariadb
lvcreate -n backup -l 100%FREE mariadb
ll /dev/mariadb/

mkfs.ext4 /dev/mariadb/data
mkfs.ext4 /dev/mariadb/binlog
mkfs.ext4 /dev/mariadb/backup
mkfs.ext4 /dev/mariadb/scripts

vim /etc/fstab
---------
/dev/mariadb/data   /data   ext4    defaults        0       0
/dev/mariadb/binlog   /binlog   ext4    defaults        0       0
/dev/mariadb/backup   /backup   ext4    defaults        0       0
/dev/mariadb/scripts   /backup   ext4    defaults        0       0
-----

mkdir /{data,binlog,backup,scripts}
systemctl daemon-reload
mount -a
lsblk



```



```bash

sudo apt-get install apt-transport-https curl
sudo mkdir -p /etc/apt/keyrings
sudo curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'


vim /etc/apt/sources.list.d/mariadb.sources
------------
# MariaDB 11.4 repository list - created 2025-11-02 11:59 UTC
# https://mariadb.org/download/
X-Repolib-Name: MariaDB
Types: deb
# deb.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
# URIs: https://deb.mariadb.org/11.4/ubuntu
URIs: https://mirror.kernel.ir/mariadb/repo/11.4/ubuntu
Suites: noble
Components: main main/debug
Signed-By: /etc/apt/keyrings/mariadb-keyring.pgp
-------------------

sudo apt update
sudo apt-get install mariadb-server


# mysql_secure_installation


mariadb
show variables like '%default_storage%';
show variables like '%datadir%';

exit

# change directory
systemctl stop mariadb.service
cp -RTp /var/lib/mysql/ /data/

# change datadir in directory
vim /etc/mysql/mariadb.conf.d/50-server.cnf
---------
[mariadbd]

datadir                 = /data
---------

systemctl restart mariadb.service

mariadb
show variables like "%datadir%";
+---------------+--------+
| Variable_name | Value  |
+---------------+--------+
| datadir       | /data/ |
+---------------+--------+
1 row in set (0.001 sec)




## binariy log

show variables like "%log_bin%";
+---------------------------------+-------+
| Variable_name                   | Value |
+---------------------------------+-------+
| log_bin                         | OFF   |



```
### install mycli 
[ref](https://github.com/dbcli/mycli)
```sh
python -m venv venv
pip install -U 'mycli[all]'
```

```sh
mycli -h 192.168.1.1 -P 33060 -u username -p
mariadb -h 192.168.1.1 -P 2222 -u username -p

show character set;
show collation;



create database zabbix;
# create user

# allow from localhost
CREATE USER 'iman1'@'localhost' IDENTIFIED BY 'test';
GRANT ALL ON *.* TO 'iman1'@'localhost';
FLUSH PRIVILEGES;


# allow from specific host
CREATE USER 'iman2'@'192.168.1.1' IDENTIFIED BY 'test';
GRANT ALL ON *.* TO 'iman1'@'localhost';
FLUSH PRIVILEGES;

# allow from subnet
CREATE USER 'iman3'@'192.168.1.%' IDENTIFIED BY 'test';
GRANT ALL ON *.* TO 'iman1'@'localhost';
FLUSH PRIVILEGES;


# allow from anywhere
CREATE USER 'iman1'@'%' IDENTIFIED BY 'test';
GRANT ALL ON zabbix.* TO 'iman1'@'%';
FLUSH PRIVILEGES;


# change root password
alter user 'root'@'localhost' identified by 'root';



mariadb -u root -p
use mysql;
select host,user,password from mysql.user;



# Role
# A role is like a template or group of privileges that can be assigned to one or more users.
-- Create a role
CREATE ROLE 'read_only';

-- Grant privileges to the role
GRANT SELECT ON company.* TO 'read_only';

-- Assign the role to a user
GRANT 'read_only' TO 'john'@'localhost';

-- Activate the role for the user
SET DEFAULT ROLE 'read_only' TO 'john'@'localhost';


## server system variables
# Change a variable temporarily (until restart)

# For the current session:
SET SESSION variable_name = value;
SET SESSION sql_mode = 'STRICT_ALL_TABLES';

# For all sessions (temporarily):
set global log_bin_trust_function_creators = 1;
set global log_bin_trust_function_creators = 0;
SET GLOBAL max_connections = 200;

# Change a variable permanently
vim /etc/mysql/mariadb.conf.d/50-server.cnf
----
[mysqld]
max_connections = 200
sql_mode = STRICT_ALL_TABLES

----
sudo systemctl restart mariadb





```


### enable slow query log and log error 
```sh
vim /etc/mysql/mariadb.conf.d/50-server.cnf
----
slow_query_log = 1
log_slow_query_file    = /var/log/mysql/mariadb-slow.log
log_error = /var/log/mysql/error.log

----
# change binlog
vim /etc/mysql/mariadb.conf.d/50-server.cnf
----------
server-id              = 1
log_bin                = /binlog/mariadb-bin.log
expire_logs_days        = 10
max_binlog_size        = 200M
binlog_format          = mixed
----------

chown -R mysql: /binlog/
systemctl restart mariadb.service
```







# Stored Procedure

```sql
-------------------------without input-----------------------------------
DELIMITER $$

create procedure getcustore()
begin
	select * from customer;
end$$
DELIMITER ;

call getcustore();


----------------------------------with input -------------------------

DELIMITER $$
create procedure get_customer_detail(IN fname varchar(255))
begin
	select * 
    from customer
    where first_name = fname;
end$$
DELIMITER ;

call get_customer_detail('LINDA');

---------------------------------with-intput-and-output---------------------------------

DELIMITER $$
create procedure get_sum_amount_by_customer_id(IN cus_id int, OUT total float)
begin
	select sum(amount) into total  
    from payment where customer_id = cus_id; 
end$$
DELIMITER ;

call get_sum_amount_by_customer_id(200, @total);
select @total 



```



# View

```sql
create view `movie_rate_with_G_flag` as
	select * 
	from film
    where rating = 'G';

select * from movie_rate_with_G_flag;
select count(*) from movie_rate_with_G_flag;

```


