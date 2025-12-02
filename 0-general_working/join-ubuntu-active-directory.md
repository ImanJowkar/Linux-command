# Join ubuntu to active directory
```sh

sudo apt install sssd-ad sssd-tools realmd adcli

pam-auth-update  # mark the `Create home directory on login`


sudo realm join --user i.family tech.com

realm list # must return output

# now go to the sssd configuration

vim /etc/sssd/sssd.con
-----
cache_credentials = False
fallback_homedir = /home/%u
use_fully_qualified_names = False
access_provider = simple
simple_allow_users = i.user1, b.user2, c.user3
dyndns_update = false
-----


systemctl restart sssd


# add your user in visudo
visudo
-----
i.user1  ALL=(ALL)  ALL
b.user2  ALL=(ALL)  ALL
c.user3  ALL=(ALL)  ALL
-----

```
