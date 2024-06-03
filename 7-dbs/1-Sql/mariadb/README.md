## Mariadb


```

sudo apt update
sudo apt install mariadb-server mariadb-client
sudo systemctl status mariadb.service
sudo systemctl enable mariadb.service
sudo mysql_secure_installation


# create user
CREATE USER 'iman1'@'localhost' IDENTIFIED BY 'test';
CREATE USER 'iman1'@'%' IDENTIFIED BY 'test';
GRANT ALL ON *.* TO 'iman1'@'localhost';
GRANT ALL ON *.* TO 'iman1'@'%';
FLUSH PRIVILEGES;




 mariadb -u root -p
 use mysql;
 select host,user,password from user;






```


