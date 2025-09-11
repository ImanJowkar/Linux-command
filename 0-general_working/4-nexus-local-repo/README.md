# Setup 


### install nexus

```sh

docker compose up -d

```



# look for mirrors: 
[mirrors](https://mirrors.rockylinux.org/mirrormanager/)

and look for the url pattern , for example for rocky linux and this https://rockylinux.anexia.at/ url you can use below format

allways look for repository url format:  like below image



[img](img/1.png)

```sh

# base url for rocky linux - BaseOS
baseurl=http://192.168.244.20:8081/repository/dnf/$releasever/BaseOS/$basearch/os/

# base url for rocky linux - AppStream
baseurl=http://192.168.244.20:8081/repository/dnf/$releasever/AppStream/$basearch/os/

# base url for rocky linux - extras
baseurl=http://192.168.244.20:8081/repository/dnf/$releasever/extras/$basearch/os/




```