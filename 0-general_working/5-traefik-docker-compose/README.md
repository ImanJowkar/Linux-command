# how to use traefik as a reverse proxy

```sh








# enable basic authentication, you can use htpasswd for generating a secret password
sudo apt install apache2-utils -y
htpasswd -nbB youruser yourpassword


echo $(htpasswd -nb foo bar) | sed -e s/\\$/\\$\\$/g

```


