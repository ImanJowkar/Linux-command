### setup nfs-server 
```
sudo apt update
sudo apt install nfs-kernel-server



sudo mkdir /docker_nfs_mariadb
sudo chown -R nobody:nogroup /docker_nfs_mariadb





sudo vim  /etc/exports
# add below
-----------------------------
/docker_nfs_mariadb 10.10.1.5(rw,sync,no_subtree_check,no_root_squash)
------------------------------


sudo exportfs -av
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server


```



## test data persistence
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