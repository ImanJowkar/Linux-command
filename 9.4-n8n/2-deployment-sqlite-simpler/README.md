```sh

sudo mkdir -p /etc/ssl/n8n
cd /etc/ssl/n8n

sudo openssl req -x509 -nodes -newkey rsa:2048 -sha256 -days 3650 \
  -keyout privkey.pem \
  -out fullchain.pem \
  -subj "/CN=n8n.linuxdevops.ir" \
  -addext "subjectAltName=DNS:n8n.linuxdevops.ir"

sudo chmod 600 privkey.pem
sudo chmod 644 fullchain.pem

```