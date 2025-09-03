# Linux Hardening
### Memory Attacks

##### sysctl parameters
```sh
vim /etc/sysctl.conf
--------------

kernel.randomize_va_space = 2
--------------


sysctl -p
```
