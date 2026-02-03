## elastic search cluster with 3 node

```sh
# node1
hostnamectl set-hostname elk-node1 

swapoff -a
sed -i '/swap/d' /etc/fstab


cat <<EOF >/etc/security/limits.d/elasticsearch.conf
elasticsearch soft nofile 65535
elasticsearch hard nofile 65535
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited
EOF


cat <<EOF >/etc/sysctl.d/99-elasticsearch.conf
vm.max_map_count=262144
EOF
sysctl -p
sysctl --system

rpm -i elasticsearch-9.2.4-x86_64.rpm

vim /etc/elasticsearch/elasticsearch.yml
-----

cluster.name: elk-cluster
node.name: elk-node1
bootstrap.memory_lock: true  # disable swap for elasticsearch
network.host: 0.0.0.0
http.port: 9200
transport.port: 9300


discovery.seed_hosts:
  - 10.0.0.11
  - 10.0.0.12
  - 10.0.0.13

cluster.initial_master_nodes:
  - elk-node1
  - elk-node2
  - elk-node3





-----



```