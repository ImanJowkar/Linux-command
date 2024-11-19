# NFS (Network File System)
Network File System (NFS) is primarily used in Unix-like systems, including Linux, for sharing files over a network. However, it is possible to share files between Windows and Linux using NFS

### nfs-server 
```
sudo apt update
sudo apt install nfs-kernel-server



sudo mkdir /mnt/mydirectory
sudo chown nobody:nogroup /mnt/mydirectory





sudo vim  /etc/exports
# add below
-----------------------------
/mnt/mydirectory 10.10.1.0/24(rw,sync,no_subtree_check)
/mnt/mydirectory2 10.10.2.0/24(rw,sync,no_subtree_check)

------------------------------


sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server
```

* rw
* ro 
* sync
* async
* root_squash
* all_squash
* no_root_squash
* subtree_check
* no_subtree_check


### install on nfs-client

```
sudo mkdir /data1

sudo apt install nfs-common

sudo mount -t nfs <ip-addr-nfs-server>:/mnt/mydirectory /data1


# you can mount permanatly in /etc/fstab

vim /etc/fstab
-------------------------------

<ip-addr-nfs-server>:/mnt/mydirectory /var/backups  nfs      defaults    0       0

-------------------------------

```


### windows as a nfs client
On Windows, you need to enable the NFS client feature. Go to Control Panel > Programs > Turn Windows features on or off. Look for “Services for NFS” and check it. Click OK and wait for the installation to complete.

```

mount -o anon \\<Linux_IP_Address>\mnt\mydirectory Z:

```