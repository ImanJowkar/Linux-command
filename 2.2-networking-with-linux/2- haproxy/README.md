# install haproxy on debian
```sh
apt update
apt install haproxy
find / -type f -iname "haproxy*"
apt install tree

cd /etc/haproxy
cp haproxy.cfg haproxy.cfg.backup


cd ~
mkdir haproxy
cd haproxy
mkdir nginx{1,2,3}
touch nginx{1,2,3}/index.html
for i in {1..3}; do echo "<h1>srv-$i</h1>" > "nginx$i/index.html"; done
docker compose up -d


haproxy -c -f /etc/haproxy/haproxy.cfg  # check the config file
```


## Basic configuration

```sh
cd /etc/haproxy
cp haproxy.cfg haproxy.cfg.backup

vim /etc/haproxy/haproxy.cfg
------


------



```