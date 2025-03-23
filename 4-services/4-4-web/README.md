# Nginx as a Web Servers

web server is an application which map `URL` to a `path` on the local server

http: 80
https: 443


packages:
        * debian-based: apache2,nginx,
        * RHEL : httpd,nginx


URL=>   protocol://<domain>:<port>/path/to/local/file/?var1=val1&var2=val2

# basic Setup Linux server
```
sudo apt update
sudo apt install net-tools
sudo hostnamectl set-hostname web-server
netstat -ntlp

# Stop unnecessary services
systemctl stop nginx




```



# Installation
```




sudo apt update                 # update the repository index
sudo apt install apache2        # install the apache web-server
sudo apt install nginx          # install nginx web server








```


# Lets Begin

```
NGINX
------

	WebServer
	Load Balancer
	Reverse Proxy


HTTP  Request Type (Request Method)

1. GET      
2. POST     
3. PUT	    
4. DELETE   

            


HTTP  Response: (Status Code, Reponse code)

1. 1XX ----> Informational Message
2. 2XX ----> Success
3. 3XX ----> Redirection
4. 4XX ----> Client Error
5. 5XX ----> Server Error




1. *200 OK
2. *301 Move Permanently 
3. *302 Move Temporary
4. *400 Bad Request (Malformed request , wrong syntax)
5. *401 UnAuthorized
6. *403 Forbidden
7.*404 Not Found
8. 405 Method not allowed
9. 407 Proxy Authentication Required
10. 408 Request Timeout
11.*500 Internal Server Error
12. *502 Bad gateway 
13. *503 Service Unavailable
14. 504*  Gateway timeout






curl http://192.168.56.10/
curl http://192.168.56.10:82/file2


cd /etc/nginx
ls
vim nginx.conf

ps -auxf | grep nginx | grep -v grep


```


 