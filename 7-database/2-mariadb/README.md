## Mariadb


```bash

sudo apt update
sudo apt install mariadb-server mariadb-client
sudo systemctl status mariadb.service
sudo systemctl enable mariadb.service
sudo mysql_secure_installation
```


```sql

# create user
CREATE USER 'iman1'@'localhost' IDENTIFIED BY 'test';
GRANT ALL ON *.* TO 'iman1'@'localhost';
FLUSH PRIVILEGES;


CREATE USER 'iman1'@'%' IDENTIFIED BY 'test';
GRANT ALL ON zabbix.* TO 'iman1'@'%';
FLUSH PRIVILEGES;

# change root password
alter user 'root'@'localhost' identified by 'root';




 mariadb -u root -p
 use mysql;
 select host,user,password from user;

```


# show some variables
```sql
show variables like 'datadir';
SHOW VARIABLES LIKE 'innodb_buffer_pool%';

cd /var/lib/mysql


show variables like '%log_bin%';


change some variables in /etc/mysql/mariadb.conf.d/50-server.cnf
log_bin                = /var/log/mysql/mysql-bin.log
expire_logs_days        = 10
max_binlog_size        = 100M

innodb_buffer_pool_size = 2G



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


### Backup with mysqldump

```





```