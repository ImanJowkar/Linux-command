`remote_src: yes:` This tells Ansible that the source archive file is already present on the remote machine (the target machine where you are running the playbook). Ansible will look for the file on the remote machine and unarchive it there.

`remote_src: no` (or if you omit remote_src): This is the default behavior and tells Ansible that the source archive file is on the local machine (the machine where you are running Ansible). Ansible will transfer the archive file from the local machine to the remote machine and then unarchive it there.



#### usage

```

ansible-playbook 1-playbook-install-prometheus.yaml
ansible-playbook 2-playbook-install-exporter.yaml
ansible-playbook 3-playbook-update-config-file.yaml


```