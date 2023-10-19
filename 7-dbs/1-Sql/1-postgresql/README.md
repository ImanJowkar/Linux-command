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



# Create a database and user and restore database
[ref](https://www.w3schools.com/postgresql/postgresql_insert_into.php)
```
create database store;
\c store;


CREATE TABLE cars (
  brand VARCHAR(255),
  model VARCHAR(255),
  year INT
);

INSERT INTO cars (brand, model, year)
VALUES
  ('Volvo', 'p1800', 1968),
  ('BMW', 'M1', 1978),
  ('Toyota', 'Celica', 1975);


\dt
select * from cars;



# pg_dump     # allows you to backup from  a database
# pg_dumpall  # allows you to backup from all database
# pg_restore  # for restore

pg_dump -U <user> <database>

pg_dump -U test store > store-backup.sql
# or you can use bellow option
pg_dump -U test -f store-backup.sql store



# for restore, you have two option:
# 1) go to the postgres console: 

psql -U <user>
\i store-backup.sql



#### store output with another format
pg_dump -U <user> -Fc -f store-backup.backup <db_name>  # store in binary format


pg_restore -U test -C -d postgres store-backup.backup



pg_dump -U <user> -Ft -f store-backup.tar <db_name>  # store in tar format

pg_restore -U test -C -d postgres store-backup.tar




pg_dump -U <user> -Fd -f store-backup-directory <db_name>  # store in directory format

pg_restore -U test -C -d postgres store-backup-directory/ # -C means create database , -d means connect to database and create database










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


## Create Table
```

CREATE TABLE IF NOT EXISTS public.movie
(
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    release_date date NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.category
(
    id bigint NOT NULL,
    name character varying(256) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.movie_category
(
    id integer NOT NULL,
    film_id integer NOT NULL,
    category_id integer NOT NULL,
    CONSTRAINT files_category_pkey PRIMARY KEY (id)
);

```


# Query

```
select * from film limit 15;

select * from film where id=4;

select * from film where id=4 or id=6;

select col1, col2 from file where id=4 or id=6;


select first_name || ' ' || last_name as full_name from name;

SELECT count(*) from categories;


```

# WAL
In PostgreSQL, WAL stands for Write-Ahead Logging. It is a critical component of the database's durability and crash recovery mechanisms. Here's what WAL is and how it works:

1. **Write-Ahead Logging (WAL)**: WAL is a method used by PostgreSQL to ensure that changes made to the database are durable, meaning they are permanent and survive system crashes or failures. Instead of writing data directly to the database files, PostgreSQL first writes changes to a transaction log, and then it applies these changes to the database itself.

2. **Transaction Logs**: The transaction log is a sequential file where all changes (inserts, updates, and deletes) made to the database are recorded in a detailed and sequential manner. Each record in the transaction log represents a change or action.

3. **Durability and Crash Recovery**: The use of WAL ensures that even if a crash occurs (e.g., a power failure or a system crash), PostgreSQL can recover the database to a consistent state by replaying the transactions recorded in the log. This guarantees that no committed transactions are lost and the database remains in a consistent state.

4. **Performance Benefits**: Writing changes to the transaction log is typically faster than writing directly to the database files because it involves sequential writes rather than random access writes. This can lead to improved database write performance.

5. **Archiving and Replication**: WAL logs can also be used for other purposes like database replication and point-in-time recovery. They can be archived and shipped to other servers for replication, backup, or other purposes.

In summary, Write-Ahead Logging (WAL) is a fundamental mechanism in PostgreSQL that enhances the durability, reliability, and performance of the database system. It helps ensure data consistency and recoverability in the face of system failures.


# MVCC
MVCC stands for Multi-Version Concurrency Control, and it is a critical feature of PostgreSQL and other relational database management systems (RDBMS). MVCC is used to manage concurrent access to data in a way that allows multiple transactions to read and write data without interfering with each other while maintaining data consistency and integrity.


MVCC in PostgreSQL allows for high levels of concurrency in database operations, as multiple transactions can read and write data simultaneously without waiting for locks. It also provides strong data consistency and isolation between transactions, allowing them to work independently without interfering with each other.

Different database systems implement MVCC in their own ways, but the fundamental principle of managing concurrent access through versioning data and transaction snapshots is common to most modern RDBMS, including PostgreSQL.
