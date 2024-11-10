## Dockerfile Best Practice

```
# Never use docker images which has all the utility which are not needed, and use alpine images or distroless images, like nginx:alpine
# "Distroless" images contain only your application and its runtime dependencies. They do not contain package managers, shells or any other programs you would expect to find in a standard Linux distribution.

FROM ubuntu:latest              # Bad Practice, because you used latest tag. and always use official images


# always create a user and run command with this user, otherwise all process run with root privileges which is not recommended.
# but if you switch to another user it will fail because that user doesn't allow to apt install, before CMD, ENTRYPOINT switch to another user.

USER root


# Before COPY, specify WORKDIR and always use COPY after RUN apt update and ... if it is posible
WORKDIR /app


# don't use multiple RUN after each other, and use && 
RUN apt update -y && \
    apt install curl -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \   # always remove /var/lib/apt/lists for reduce the size of image
    curl -k https://IP 


COPY *.txt .

# don't pass username and password as an Environment variable in Dockerfile, 
# you can pass it when running the container, like this:

docker run --name database -e PASSWORD=7574 postgresql


# always use the right binary of the specific program and delete /bin/bash
RUN rm -rf /bin/bash


USER dev
CMD ["google.com"]
ENTRYPOINT ["/bin/ping"]  

# above command will run "/bin/ping google.com"









# Multi-stage Builds in complier language 

ARG TAG=1.2
FROM golang:$TAG as BUILD
/app/demo

# RUN your app
FRIM ubuntu:$TAG
WORKDIR /app
COPY --from=BUILD /app/demo .

USER dev
CMD ["./demo"]



```


# For scan image Vulnerability you can use trivy binary
[refrenece](https://aquasecurity.github.io/trivy/v0.18.3/installation/)
```

sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

trivy image image_name
trivy image clang:normal
```


# if you want know about docker occupied your disk space : 
```
docker system df
 
```
