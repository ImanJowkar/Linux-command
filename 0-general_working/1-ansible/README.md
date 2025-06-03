## linux hardening wiht ansible

mkdir ~/harden
```sh
ansible-galaxy install git+https://github.com/ansible-lockdown/UBUNTU22-CIS.git

cd ~/.ansible/roles/UBUNTU22-CIS
cp ~/.ansible/roles/UBUNTU22-CIS/site.yml ~/harden


cd ~/harden

vim site.yml
----------


---
- name: Apply ansible-lockdown hardening
  hosts: all
  become: true
  roles:
    - role: "UBUNTU22-CIS"
---------


vim inventory.ini
--------------
192.168.229.10

[all:vars]
ansible_connection=ssh
ansible_user=iman
-------------

ansible-playbook -i inventory.ini site.yml --ask-become-pass

```

