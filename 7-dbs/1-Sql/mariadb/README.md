## Mariadb


```

sudo apt update
sudo apt install mariadb-server mariadb-client
sudo systemctl status mariadb.service
sudo systemctl enable mariadb.service
sudo mysql_secure_installation


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


# resoter data: 
mariadb -u root -p < Chinook.sql



# afew query
SELECT * from Track WHERE Bytes > (SELECT AVG(Bytes) from Track ) ;

SELECT  * from Invoice as t1
WHERE t1.Total  > 9;




```




# Multi master replication

## node1 ubuntu
```
sudo apt update
sudo apt install mariadb-server mariadb-client
sudo systemctl status mariadb.service
sudo systemctl enable mariadb.service
sudo mysql_secure_installation


vim /etc/mysql/my.cnf

## add to end of this file
---------------------




---------------------





```




## node2 debain
```

sudo apt update
sudo apt install mariadb-server mariadb-client
sudo systemctl status mariadb.service
sudo systemctl enable mariadb.service
sudo mysql_secure_installation













```