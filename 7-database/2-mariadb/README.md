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

```
# show mysql data dir
```
show variables like 'datadir';
SHOW VARIABLES LIKE 'innodb_buffer_pool%';

cd /var/lib/mysql


```


# download and import sakila database


```

unzip sakila-db.zip
cd sakila-db




```


## insert sum data
```
mysql -u root -p

create database mydatabase;
Use mydatabase;

CREATE TABLE products_tbl(product_id INT NOT NULL AUTO_INCREMENT,
                          product_name VARCHAR(100) NOT NULL, 
                          product_manufacturer VARCHAR(40) NOT NULL,
                          submission_date DATE,
                          PRIMARY KEY ( product_id )
                          );



INSERT INTO products_tbl (product_id, product_name,product_manufacturer) VALUES (1, 8150,'Nutanix');
INSERT INTO products_tbl (product_id, product_name,product_manufacturer) VALUES (2, 8170,'Nutanix');
INSERT INTO products_tbl (product_id, product_name,product_manufacturer) VALUES (3, 3150,'Nutanix');
INSERT INTO products_tbl (product_id, product_name,product_manufacturer) VALUES (4, 9150,'Nutanix');
INSERT INTO products_tbl (product_id, product_name,product_manufacturer) VALUES (5, 6150,'Nutanix');



select * from products_tbl;

```