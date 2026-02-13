# Ansible

![img](img/1.png)

## Ansible installation
```bash
sudo apt install python3.10-venv

python3 -m venv venv

source venv/bin/activate
pip install ansible


# another way to install ssh

dnf update && dnf install python3-venv

```





## create ssh-keygen and copy it to the remote server
```bash
ssh-keygen
ssh-copy-id user@192.168.1.1

```

## Order of Ansible Config file location
* define a variable called ANSIBLE_CONFIG
* ansible.cfg
* ~/.ansible.cfg
* /etc/ansible/ansible.cfg


```sh
ansible --version # you can see the location of ansible-config from the output of this
```
 

## Ansible ad-hoc commands
```sh
ansible-doc service
ansible-doc apt

ansible-config view
ansible all -m ping
ansible all --list-hosts
ansible all -m gather_facts
ansible all -m gather_facts --limit 192.168.93.151
ansible all -m gather_facts | grep -i distribution



ansible servers -m command -a uptime
ansible servers -m command -a who
ansible servers -m command -a "apt install nginx" --become --ask-become-pass  
ansible all -m command -a "cat /etc/os-release" --user=iman --become --ask-become-pass --become-user=root

# gathering facts
ansible servers -m setup
ansible servers -m setup -a "filter=ansible_all_ipv4_addresses"
ansible all -m setup -a "filter=ansible_distribution,ansible_distribution_version"
ansible all -m setup -a "filter=ansible_distribution*"



ansible all -m apt -a update_cache=true
ansible all -m apt -a update_cache=true --become --ask-become-pass
ansible all -m apt -a name=vim-nox --become --ask-become-pass
ansible all -m apt -a name=nginx --become --ask-become-pass

ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root --ask-become-pass cluster.yml
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root --ask-become-pass upgrade-cluster.yml

ansible-playbook playbook.yaml --step   # ask you in each task
ansible-playbook playbook.yaml --list-tasks   # print all tasks in this playbook

# you can set extra-vars when running playbook
ansible-playbook playbook.yaml -e "name=iman"
ansible-playbook playbook.yaml --syntax-check

ansible-playbook playbook.yaml  --check  # dry-run check

ansible-playbook playbook.yaml --start-at-task "the task name"



```


## play

```sh
### A play is a set of tasks that run on a group of hosts.
# Example playbook with multiple plays

------
# Example Playbook with 3 Plays

# Play 1: Configure Web Servers
- name: Configure Web Servers
  hosts: webservers
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Start Nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Copy website index file
      copy:
        src: files/index.html
        dest: /var/www/html/index.html

# Play 2: Configure Database Servers
- name: Configure Database Servers
  hosts: dbservers
  become: yes
  tasks:
    - name: Install PostgreSQL
      apt:
        name: postgresql
        state: present
        update_cache: yes

    - name: Ensure PostgreSQL service is running
      service:
        name: postgresql
        state: started
        enabled: yes

    - name: Create a database
      postgresql_db:
        name: myappdb

# Play 3: Configure Load Balancer Servers
- name: Configure Load Balancers
  hosts: loadbalancers
  become: yes
  tasks:
    - name: Install HAProxy
      apt:
        name: haproxy
        state: present
        update_cache: yes

    - name: Copy HAProxy configuration
      template:
        src: templates/haproxy.cfg.j2
        dest: /etc/haproxy/haproxy.cfg
        owner: root
        group: root
        mode: 0644

    - name: Ensure HAProxy service is running
      service:
        name: haproxy
        state: started
        enabled: yes

-------


```

## Serial and Forks
```sh
# forks and serial
# forks: Default = 5
# serial: specifiy 
tail -f /var/log/apt/history.log
ansible all -m apt -a "upgrade=dist" --become --ask-become-pass


ansible-playbook playbook.yaml -u iman -f 2   # change forks  (how many SSH connections Ansible opens simultaneously.)

# change serial
----
- name: Rolling update of Apache web servers
  hosts: webservers
  serial: 1
  tasks:
    - name: task1
      shell: "sleep 5"

    - name: task2
      shell: "sleep 5"
----

ansible-playbook playbook-serial-forks.yaml -u root -f 2  # change forks=2


```

## Handlers and notify
```sh
# Handlers in Ansible = Like functions
# notify = how you call that “function”
----
tasks:
  - name: Update app config
    ansible.builtin.copy:
      src: app.conf
      dest: /etc/myapp/app.conf
    notify:
      - Restart MyApp
      - Send Alert

handlers:
  - name: Restart MyApp
    ansible.builtin.systemd:
      name: myapp
      state: restarted

  - name: Send Alert
    ansible.builtin.debug:
      msg: "App config was changed, please check logs."

----


### when handlers run 
# Both tasks update files on the same host.
# Both notify Restart MyApp.

# What happens:
# Even though Restart MyApp was notified twice, it runs only once at the end of the play for that host.
# This prevents unnecessary restarts and ensures efficiency.
------

tasks:
  - name: Update config A
    ansible.builtin.copy:
      src: configA.conf
      dest: /etc/myapp/configA.conf
    notify: Restart MyApp

  - name: Update config B
    ansible.builtin.copy:
      src: configB.conf
      dest: /etc/myapp/configB.conf
    notify: Restart MyApp

handlers:
  - name: Restart MyApp
    ansible.builtin.service:
      name: myapp
      state: restarted
------

# 2. When is a handler executed?
# A handler executes at the end of the play if any task notified it and the task reported a change (changed: true).
# It is not executed if no task notifies it or if the task did not change anything.


# 3. Can a handler be notified multiple times? What happens then?
# Yes, a handler can be notified multiple times.
# Ansible ensures it runs only once at the end of the play, no matter how many times it was notified.



# 5. Can a handler notify another handler? Explain with an example.
# Yes, a handler can notify another handler using notify.
-------
handlers:
  - name: Reload App Service
    ansible.builtin.systemd:
      name: myapp
      state: reloaded
    notify: Send Alert

  - name: Send Alert
    ansible.builtin.debug:
      msg: "App service was reloaded"
-------

# 6. How do you force a handler to run immediately instead of at the end of the play?
# Answer: Use meta: flush_handlers
-----
tasks:
  - name: Update config
    ansible.builtin.copy:
      src: app.conf
      dest: /etc/myapp/app.conf
    notify: Restart MyApp

  - meta: flush_handlers  # Forces immediate execution of notified handlers
-----


```

## Tags
```sh
Tags let you run or skip specific parts of a playbook — instead of running all tasks every time.
----
---
- hosts: webservers
  become: yes

  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: present
      tags: install

    - name: Start Apache
      service:
        name: httpd
        state: started
      tags: start

    - name: Stop Apache
      service:
        name: httpd
        state: stopped
      tags: stop
----

# Run only tasks tagged with "install"
ansible-playbook site.yml --tags install

# You can also run multiple tags:
ansible-playbook site.yml --tags "install,start"


# Or skip some tags:
ansible-playbook site.yml --skip-tags stop

```

## Vars and Vars_file

```sh

vim playbook.yaml
------
- name: Install and configure Nginx on web servers
  hosts: all
  become: false
  vars:
    nginx_port: 80
  vars_files:
    vars/main.yaml

  tasks:
    - name: show vars
      debug:
        msg: "{{ nginx_port }}"

    - name: show names
      debug:
        msg: "{{ names }}"

------


vim vars/config.yaml
------
names:
  - iman
  - saman
  - hossen

family: ["jowkar", "ra", "jow"]
------



```




## Jinja2 Template
```sh

{%   text    %}
{{   varialbe    }}     
{#    comment    #}




```




## Ansible Vault

```sh
ansible-vault create playbook1.yaml

# edit encrypted file
ansible-vault edit playbook1.yaml
ansible-vault encrypt playbook1.yaml
ansible-vault encrypt install-lxc.yaml

# run the playbook but ask the password first
ansible-playbook playbook1.yaml --ask-vault-pass

# decrypt the encrypted playbook 
ansible-vault decrypt playbook1.yaml



ansible-vault rekey playbook-install-node-exporter.yaml
ansible-vault view playbook1.yaml







```

## Role
```sh
.
├── ansible.cfg
├── inventory
│   └── inventory.ini
├── roles
│   └── setup-website
│       ├── defaults
│       │   └── main.yaml
│       ├── files
│       ├── handlers
│       │   └── main.yaml
│       ├── meta
│       │   └── main.yaml
│       ├── tasks
│       │   └── main.yaml
│       ├── templates
│       └── vars
│           └── main.yaml
└── setup-website.yaml
```

```sh

ansible-galaxy init my_role
ansible-galaxy init my_role1
ansible-galaxy init my_role2


ansible-playbook -i inventory/inventory.ini setup-website.yaml

ansible-playbook -i inventory/inventory.ini setup-website.yaml --tag show_ip_add
ansible-playbook -i inventory/inventory.ini setup-website.yaml --tag "show_ip_addr,sleep"
ansible-playbook -i inventory/inventory.ini setup-website.yaml --skip-tags set_hostname


ansible-playbook -i inventory/inventory.ini setup-website.yaml --step   # ask you which task have to run or not

ansible-playbook -i inventory/inventory.ini setup-website.yaml --list-tasks
ansible-playbook -i inventory/inventory.ini setup-website.yaml --syntax-check

ansible-playbook -i inventory/inventory.ini setup-website.yaml --check  # dry-run, Note: Some Ansible modules do not support check mode (--check) and may still execute changes or fail when run in this mode.


ansible-playbook -i inventory/inventory.ini setup-website.yaml --flush-cache  # remove gathering facts cache and again run gathering facts





```