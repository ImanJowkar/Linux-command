# Linux Hardening

* Ensure physical Security.
* BIOS protection.
* Disable Booting from external media devices(such as CD/DVD and USB).
* Boot Loader protection
* Keep the OS update(only from trusted source)
* check the installed packages and remove the unnecessary packages
* Check the open ports and stop unnessary services (netstat)
* Enforce Password policy
* Do not use root account on regular basis

# secure ssh

```
vim /etc/ssh/sshd_config

# add or uncomment these lines
Port 2285

PermitRootLogin no

# before this add public-key
PasswordAuthentication no

AllowUsers kuber ali jack
----

iptables -A INPUT -p tcp --dport 2278 -s IP_Allowd -j ACCEPT
iptables -A INPUT -p tcp --dport 2278 -j DROP



```
* use non standard port
* disable direct root loging
* disable password authuntication and enable public key authuntication
* enable firewall
* user ssh version 2

# Secure bootloader(Grub2)

```
grub-mkpasswd-pbkdf2
# copy this line

grub.pbkdf2.sha512.10000.3FE5C7D9523AEB8FA298F508522E24C915A0C01B7CB9AC42480D81782E5085E007E8A9B40FCF6C0A531FB0BB71FC4F76A6EB46EFDB4EEF3E4B063277B43658A1.F3C3B7E09B0FBC4AA1E9E8B5A9D7214FB30F9CE8DBE6B9663934DF137C030F73FDAC00E58EF5DB994DA4353016A80D8E47807AC654AA61B0DD0D9D9A26ED9B6B


# above command will generate a password for grub
# go to the below file and add the above password
# add the folowing line in this file
vim /etc/grub.d/40_custom

set superusers="root"
password_pbkdf2 root grub.pbkdf2.sha512.10000.3FE5C7D9523AEB8FA298F508522E24C915A0C01B7CB9AC42480D81782E5085E007E8A9B40FCF6C0A531FB0BB71FC4F76A6EB46EFDB4EEF3E4B063277B43658A1.F3C3B7E09B0FBC4AA1E9E8B5A9D7214FB30F9CE8DBE6B9663934DF137C030F73FDAC00E58EF5DB994DA4353016A80D8E47807AC654AA61B0DD0D9D9A26ED9B6B



# now update grub2
sudo update-grub2
```

# Disable a user
```
sudo passwd --lock ali
# above command add ! to /etc/shadow for ali user, which means the user cant login via password, but can be login via ssh

sudo passwd --status ali
# L > means the this user is locked.

su - ali

# for unlock 
sudo passwd -u ali

```

# sudo group

```
grep sudo /etc/group

sudo usermod -aG sudo ali
newgrp sudo


```

# change sudo permision
```
vim /etc/sudoers
visudo 

# for change default visudo editor
sudo update-alternatives --config editor


visudo
# add this
ali ALL=(root)	/usr/bin/ls,/usr/bin/cat,NOPASSWD:/usr/bin/apt

sudo -k # clear cache credentials



----

User_Alias MYADMIN=dan,john
Cmnd_Alias FILE=/usr/bin/cp,/usr/bin/ls,/usr/bin/touch,/usr/bin/rm

MYADMIN ALL=(root)	/usr/bin/netstat,FILE





```
