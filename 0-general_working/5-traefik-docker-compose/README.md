## Lets-ecrypt

```sh
sudo apt update
sudo apt install certbot

sudo certbot certonly --manual --preferred-challenges dns -d repo.mydomain.com



# on another terminal you can check you dns recored updated or not
dig TXT _acme-challenge.repo.mydomain.com

# if everything ok , you can check you certificate in /etc/letsencrypt/live/repo.mydomain.com/*

```
## Get wild-card certificate
```sh
sudo certbot certonly --manual --preferred-challenges dns -d "*.mydomain.com" -d mydomain.com



```




# how to use traefik as a reverse proxy

```sh

# enable basic authentication, you can use htpasswd for generating a secret password
sudo apt install apache2-utils -y
htpasswd -nbB youruser yourpassword


echo $(htpasswd -nb foo bar) | sed -e s/\\$/\\$\\$/g

```


