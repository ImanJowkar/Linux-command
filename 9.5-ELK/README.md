# ELK
```sh

# setup repository in rocky linux
# use below repository
---
https://repo.iut.ac.ir/
https://repo.iut.ac.ir/repo/repofiles/iutepel9.repo
https://repo.iut.ac.ir/repo/repofiles/iutrocky9.repo
---

# go to this website and download the elastic package
https://www.elastic.co/downloads/


dnf install lsof bash-completion vim nano tar zip unzip wget curl git net-tools traceroute htop tcpdump rsync jq tree tmux iperf3
 

# you can use official repository 
vim /etc/yum.repos.d/elasticsearch.repo
----
[elasticsearch]
name=Elasticsearch repository for 9.x packages
baseurl=https://artifacts.elastic.co/packages/9.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
type=rpm-md

----

dnf repolist
dnf makecache
sudo dnf install --enablerepo=elasticsearch elasticsearch
sudo dnf install elasticsearch-<SPECIFIC.VERSION.NUMBER>


# or you can download the rpm or deb file directly
this is the sha file
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.5-x86_64.rpm
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.5.5-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-9.5.5-x86_64.rpm.sha512
sudo rpm --install elasticsearch-9.5.5-x86_64.rpm



# Configure Elasticsearch as a Single Node
vim /etc/elasticsearch/elasticsearch.yml
-----
#  Add the following configuration:
discovery.type: single-node
#  Comment the following setting if it exists:
# cluster.initial_master_nodes: ["localhost"]

network.host: 192.168.85.140
http.port: 9200
# Verify the data and log paths:
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch


-----
systemctl enable --now elasticsearch.service 
systemctl restart elasticsearch.service



# Check Elasticsearch cluster health
curl -k -u elastic https://localhost:9200/_cluster/health?pretty

curl  --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic https://localhost:9200/_cluster/health?pretty

# ?v --> verbose
# List all nodes in the cluster
curl -k -u elastic https://localhost:9200/_cat/nodes?v

# List all Elasticsearch indices
curl -k -u elastic https://localhost:9200/_cat/indices?v

# List all indices, including hidden and system indices
curl -k -u elastic "https://localhost:9200/_cat/indices?v&expand_wildcards=all"


# Count all indices in Elasticsearch
curl -k -u elastic "https://localhost:9200/_cat/indices?format=json&expand_wildcards=all" | jq 'length'



# work with index
# Create a new index named students
curl -k -u elastic -X PUT "https://localhost:9200/students"



# Display the students index information
curl -k -u elastic "https://localhost:9200/_cat/indices/students?v"



# Insert a student document with ID 1
curl -k -u elastic -X PUT "https://localhost:9200/students/_doc/1?refresh=wait_for" \
-H "Content-Type: application/json" \
-d '{
  "name": "Ali",
  "age": 25,
  "course": "Elasticsearch"
}'



# Retrieve the student document by ID
curl -k -u elastic "https://localhost:9200/students/_doc/1?pretty"


# Count documents in the students index
curl -k -u elastic "https://localhost:9200/students/_count?pretty"




# Create a new student document with ID 2
curl -k -u elastic -X PUT "https://localhost:9200/students/_create/2" \
-H "Content-Type: application/json" \
-d '{
  "name": "Sara",
  "age": 23,
  "course": "Linux"
}'


curl -k -u elastic -X PUT "https://localhost:9200/students/_create/10" \
-H "Content-Type: application/json" \
-d '{
  "name": "ali",
  "age": 30,
  "course": "devops",
  "city": "shiraz"
}'

curl -k -u elastic -X PUT "https://localhost:9200/students/_create/11" \
-H "Content-Type: application/json" \
-d '{
  "name": "mohammad",
  "age": 18,
  "course": "ccna",
  "city": "darab"
}'


# Retrieve student document with ID 2
curl -k -u elastic "https://localhost:9200/students/_doc/2?pretty"


# Update the age of student with ID 2
curl -k -u elastic -X POST "https://localhost:9200/students/_update/2" \
-H "Content-Type: application/json" \
-d '{
  "doc": {
    "age": 24
  }
}'



# Delete student document with ID 2
curl -k -u elastic -X DELETE "https://localhost:9200/students/_doc/2"


# Count all documents in the students index
curl -k -u elastic "https://localhost:9200/students/_count?pretty"



# Retrieve all documents from the students index
curl -k -u elastic -X GET "https://localhost:9200/students/_search?pretty" \
-H "Content-Type: application/json" \
-d '{
  "query": {
    "match_all": {}
  }
}'



# Search for students named Ali
curl -k -u elastic -X GET "https://localhost:9200/students/_search?pretty" \
-H "Content-Type: application/json" \
-d '{
  "query": {
    "match": {
      "name": "Ali"
    }
  }
}'


# Find students between 20 and 30 years old
curl -k -u elastic -X GET "https://localhost:9200/students/_search?pretty" \
-H "Content-Type: application/json" \
-d '{
  "query": {
    "range": {
      "age": {
        "gte": 10,
        "lte": 20
      }
    }
  }
}'



# now go tho kibana and search from dev tools
# create index with mapping
PUT /students_v2
{
  "mappings": {
    "properties": {
      "name": { "type": "text" },
      "age": { "type": "integer" },
      "email": { "type": "keyword" },
      "created_at": { "type": "date" }
    }
  }
}


```


# Setup kibana
```sh
rpm -i kibana-9.5.5-x86_64.rpm



# on elastic server create service token for kibana
curl -k -u elastic -X POST "https://172.16.30.240:9200/_security/service/elastic/kibana/credential/token/kibana-new"
# output is 
# {"created":true,"token":{"name":"kibana-new","value":"AAEAAWVsYXN0aWMva2liYW5hL2tpYmFuYS1uZXc6ZldZM3ExZnZSc09qUTBKbDVRT3dQUQ"}}[root@el-3


vim /etc/kibana/kibana.yml
----
server.port: 5601
server.host: "172.16.30.241"

# =================== System: Kibana Server (Optional) ===================
# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
# These settings enable SSL for outgoing requests from the Kibana server to the browser.
#server.ssl.enabled: false
#server.ssl.certificate: /path/to/your/server.crt
#server.ssl.key: /path/to/your/server.key

# =================== System: Elasticsearch ===================
# The URLs of the Elasticsearch instances to use for all your queries.
elasticsearch.hosts: ["https://172.16.30.240:9200"]
elasticsearch.serviceAccountToken: "AAEAAWVsYXN0aWMva2liYW5hL2tpYmFuYS1wcm9kOmktUkxSVkRCVFA2ZTdxcWJjeEhKbHc"
elasticsearch.ssl.verificationMode: none

# on elastic server copy ca certificate 
# ls -lah /etc/elasticsearch/certs/
# elasticsearch.ssl.certificateAuthorities: [ "/etc/kibana/certs/http_ca.crt" ]
# elasticsearch.ssl.verificationMode: full




map.includeElasticMapsService: false

map.tilemap.url: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"

map.tilemap.options.attribution: "© OpenStreetMap contributors"
map.tilemap.options.maxZoom: 19


----

systemctl enable --now kibana.service
ss -nlpt



# login with elastic user, 
```


# filebeats

```sh
rpm -i filebeat-9.5.5-x86_64.rpm

vim /etc/filebeat/filebeat.yml
----

output.elasticsearch:
  hosts: ["https://172.16.30.240:9200"]
  protocol: "https"

  username: "elastic"
  password: "YOUR_ELASTIC_PASSWORD"
  ssl.verification_mode: none

setup.kibana:
  host: "http://172.16.30.241:5601"
  username: "elastic"
  password: "QJMqrf9u56nPHR=H6mRn"

----

filebeat modules list
filebeat modules enable nginx
vim /etc/filebeat/modules.d/nginx.yml
------
- module: nginx
  # Access logs
  access:
    enabled: true
# error logs
  error:
    enabled: true
-------

# Validate Filebeat configuration
filebeat test config -e

# Test the connection to Elasticsearch
filebeat test output

filebeat setup -e
```

![img](img/1.png)

```sh

vim /etc/nginx/conf.d/app.conf
----
server {
    listen 8080;
    server_name web.test.local;

    location / {
        return 500;
    }
}
----
curl web.test.local:8080



# enable another module in filebeat
filebeat modules enable system
vim /etc/filebeat/modules.d/system.yml
----

  # Syslog
  syslog:
    enabled: true

  # Authorization logs
  auth:
    enabled: true

----

filebeat test config -e

# Test the connection to Elasticsearch
filebeat test output


```


# create dashboard in kibana
```sh



```
