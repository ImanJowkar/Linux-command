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


```

## Handlers and notify
```sh
# Handlers in Ansible = Like functions
# notify = how you call that “function”
----
- hosts: webservers
  become: yes

  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: latest
      notify: restart apache   

  handlers:
    - name: restart apache    
      service:
        name: httpd
        state: restarted
----


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
ansible-vault edit playbook1.yaml
ansible-vault encrypt playbook1.yaml
ansible-vault encrypt playbook1.yaml
ansible-vault encrypt --vault-id devops@prompt  playbook1.yaml
ansible-vault encrypt --vault-id devops@pass  playbook1.yaml  # we have to have a file called pass which stored passowrd on it.

ansible-vault decrypt --vault-id devops@prompt  playbook1.yaml



ansible-vault rekey playbook-install-node-exporter.yaml
ansible-vault view playbook1.yaml

ansible-playbook playbook1.yaml --ask-vault-pass





```