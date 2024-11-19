# FTP
set up ftp server on ubuntu 
[ref](https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-20-04)
```
sudo apt update
sudo apt install vsftpd -y

sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.backup


sudo adduser ftpuser
sudo mkdir /home/ftpuser/ftpFiles
sudo chown nobody:nogroup /home/ftpuser/ftpFiles
sudo chmod a-w /home/ftpuser/ftpFiles


sudo mkdir /home/ftpuser/ftpFiles/share
sudo chown ftpuser: /home/ftpuser/ftpFiles/share



sudo vim /etc/vsftpd.conf
---------------------------------


anonymous_enable=NO

# only ipv4
listen=YES
# disable on ipv6
listen_ipv6=NO

local_enable=YES
write_enable=YES
chroot_local_user=YES



# add at the end of the ftp

user_sub_token=$USER
local_root=/home/$USER/ftpFiles



pasv_min_port=40000
pasv_max_port=41000



userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO



----------------------------------


echo "ftpuser" | sudo tee -a /etc/vsftpd.userlist





sudo systemctl restart vsftpd

```
## Disabling Shell Access 

```

vim /bin/ftponly
-------------------------
#!/bin/sh
echo "This account is limited to FTP access only."
-------------------------

sudo chmod a+x /bin/ftponly


sudo nano /etc/shells
-----------------------------------
/bin/ftponly
-----------------------------------


sudo usermod ftpuser -s /bin/ftponly



```