# Setup 


### install nexus

```sh
tree .
.
├── docker-compose.yaml
├── .env
└── nginx
    ├── certs
    │   ├── nexus.crt
    │   └── nexus.key
    ├── nginx.conf
    └── templates
        └── nexus.conf.template


cd nginx/certs

openssl genrsa -out nexus.key 4096

openssl req -new -x509 -key nexus.key -out nexus.crt -days 3650 -subj "/C=US/ST=YourState/L=YourCity/O=YourCompany/OU=IT/CN=repo.nexus.org"




docker compose up -d

```


# Rocky linux mirrors
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


# Alma Linux Repo
```sh


```