# Setup NFS Storage class on kubernetes
[ref](https://hbayraktar.medium.com/how-to-setup-dynamic-nfs-provisioning-in-a-kubernetes-cluster-cbf433b7de29)


# on nfs server
```
sudo apt-get update
sudo apt-get install nfs-common nfs-kernel-server -y


sudo mkdir -p /data/nfs
sudo chown nobody:nogroup /data/nfs
sudo chmod 2770 /data/nfs


echo -e "/data/nfs\t192.168.229.0/24(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

sudo exportfs -av


sudo systemctl restart nfs-kernel-server
sudo systemctl status nfs-kernel-server


```




# on all kubernetes nodes
```
sudo apt update
sudo apt install nfs-common -y



```


# on kubernetes master node

```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner




helm install nfs-subdir-external-provisioner \
nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=192.168.229.14 \
--set nfs.path=/data/nfs \
--set storageClass.onDelete=true



# set default storage class 
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## this is the output

```

nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=192.168.229.14 \
--set nfs.path=/data/nfs \
--set storageClass.onDelete=true
NAME: nfs-subdir-external-provisioner
LAST DEPLOYED: Fri Apr 25 05:31:19 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None


```