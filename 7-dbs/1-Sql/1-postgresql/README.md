# Postgresql

PostgreSQL, often referred to as "Postgres," is a powerful open-source relational database management system (RDBMS). It is known for its robustness, extensibility, and adherence to SQL (Structured Query Language) standards. PostgreSQL is used to store and manage structured data and is suitable for a wide range of applications, from small projects to large-scale, enterprise-level systems.

Here are some key features and characteristics of PostgreSQL:

1. **Open Source:** PostgreSQL is released under the PostgreSQL License, which is a permissive open-source license, allowing users to use, modify, and distribute it freely.

2. **Relational Database:** It is a relational database system, which means it organizes data into tables with rows and columns. These tables are related to each other through keys, allowing for efficient data retrieval and manipulation.

3. **ACID Compliance:** PostgreSQL follows the principles of ACID (Atomicity, Consistency, Isolation, Durability) to ensure data integrity and reliability even in the face of system failures.

4. **Extensibility:** PostgreSQL provides an extensible architecture that allows developers to create custom functions, operators, and data types. This makes it highly adaptable for various use cases.

5. **Advanced Data Types:** It supports a wide range of data types, including numeric, text, date/time, JSON, arrays, and more. Additionally, you can define your own custom data types.

6. **Concurrency Control:** PostgreSQL handles multiple concurrent transactions efficiently through its Multi-Version Concurrency Control (MVCC) system. This allows for high levels of concurrency without compromising data consistency.

7. **Scalability:** PostgreSQL can scale both vertically (by adding more resources to a single server) and horizontally (by distributing data across multiple servers) to handle increasing workloads.

8. **Full-Text Search:** It includes robust full-text search capabilities, making it suitable for applications that require advanced text searching and indexing.

9. **Support for Spatial Data:** PostgreSQL has support for geospatial data types and functions, making it suitable for geographic information systems (GIS) applications.

10. **Community and Ecosystem:** PostgreSQL has a large and active open-source community that continuously develops and maintains the software. There are also many third-party extensions and tools available to enhance its functionality.

11. **Security Features:** PostgreSQL offers various security features, including SSL support for encrypted connections, authentication methods, and fine-grained access control.

12. **Replication and High Availability:** PostgreSQL supports various replication methods, allowing you to set up high-availability and failover configurations for mission-critical applications.

13. **Cross-Platform Compatibility:** It is available for various operating systems, including Linux, Windows, macOS, and more.

PostgreSQL is widely used by organizations and developers for building and managing databases in a wide range of applications, including web applications, mobile apps, data warehousing, and enterprise systems. Its open-source nature, robust feature set, and active community support make it a popular choice in the database management landscape.


## install 
[ref](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart)

```
sudo apt update
sudo apt install postgresql postgresql-contrib

```


## Work with postgresql

```

psql
pg_isready
pg_lsclusters

sudo su postgres
psql -U postgres

alter user postgres with password 'iman'; # change postgres password for user postgres






\l          # list database
create database mydb1;
drop database mydb1;

psql -U postgres -d mydb   # connect to specific database




```


## Set up pgadmin with docker

```
version: '3.8'
services:
 pgadmin:
   container_name: pgadmin4_container
   image: dpage/pgadmin4:7.7
   restart: always
   environment:
     PGADMIN_DEFAULT_EMAIL: admin@admin.com
     PGADMIN_DEFAULT_PASSWORD: secret
     PGADMIN_LISTEN_PORT: 80
   ports:
     - "8080:80"
   volumes:
     - pgadmin-data:/var/lib/pgadmin
volumes:
 pgadmin-data:



```
 
for connect to your postgres instance with pgadmin, go to the `sudo vim /etc/postgresql/16/main/pg_hba.conf` and change the below line 

```
comment below line 
# host    all             all             127.0.0.1/32            scram-sha-256

# add below line instaed of above line
host    all             all             all            scram-sha-256
#

```
and restart your server
```
 sudo systemctl restart postgresql.service
```

remmeber to change the listen address to a pingable IP address instead of loopback interface in ` sudo vim /etc/postgresql/16/main/postgresql.conf`

```
listen_addresses = '192.168.5.6'            # what IP address(es) to listen on;


```