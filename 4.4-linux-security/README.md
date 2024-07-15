# Linux security


## Users
![img](img/1.png)

```
iman@my-deb-iman:~$ id
uid=1000(iman) gid=1000(iman) groups=1000(iman),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),100(users),106(netdev)


root@my-deb-iman:~# id
uid=0(root) gid=0(root) groups=0(root)


iman1@my-deb-iman:~$ ls
iman1@my-deb-iman:~$ id
uid=1001(iman1) gid=1001(iman1) groups=1001(iman1),100(users)




# adding a user
adduser iman1


# on debain based : > sudo group
# on redhat based : > wheel group



# change password of a user

passwd user


# generate password with openssl
openssl passwd -6 # sha512

openssl rand -base64 24

openssl rand -hex 24
openssl rand -hex  -out password.txt 24


# set password policy for a specific user

chage iman


# set password policy globally
vim /etc/login.defs
# in this file you have very option example: 
----
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   0
PASS_WARN_AGE   7


----

```



## security of Grub

```
# when your system is booting up , press c to go to the grub


grub2-mkpasswd-pbkdf2


PBKDF2 hash of your password is grub.pbkdf2.sha512.10000.9EA21449FDF5E1F933A69E716FADC56779E36A23A378988FC766EAB593702A654C495219DB4870A887C781F3CC9ACD5AF4F4F214B4D571CE8B81EABD420C7A1E.89D6B7772FA5CD6BDE47A6415BBACB633DCA60622D5D197458CFD7558B3B9C644F90ADDFD7523276FAF04C672105E0D790B69A45991176A6DB08C3212E33AE62


# copy below section only
grub.pbkdf2.sha512.10000.9EA21449FDF5E1F933A69E716FADC56779E36A23A378988FC766EAB593702A654C495219DB4870A887C781F3CC9ACD5AF4F4F214B4D571CE8B81EABD420C7A1E.89D6B7772FA5CD6BDE47A6415BBACB633DCA60622D5D197458CFD7558B3B9C644F90ADDFD7523276FAF04C672105E0D790B69A45991176A6DB08C3212E33AE62


# now go to the below file and change this file like this

 vim /etc/grub.d/40_custom
 ---------------
set superusers="root"
password_pbkdf2 root grub.pbkdf2.sha512.10000.9EA21449FDF5E1F933A69E716FADC56779E36A23A378988FC766EAB593702A654C495219DB4870A887C781F3CC9ACD5AF4F4F214B4D571CE8B81EABD420C7A1E.89D6B7772FA5CD6BDE47A6415BBACB633DCA60622D5D197458CFD7558B3B9C644F90ADDFD7523276FAF04C672105E0D790B69A45991176A6DB08C3212E33AE62


 ----------------
 
# in debain based  run below command
update-grub

# in redhat based run below command
grub2-mkconfig -o /boot/grub2/grub.cfg


```



## PKI

```

# genrate Private key
openssl genrsa -aes128 -out private.pem 2048

# generate public key
openssl req -utf8 -new -key private.pem -x509 -days 1000 -out certifacte.crt

# show public key
openssl x509 -in certifacte.crt -text -noout




```


