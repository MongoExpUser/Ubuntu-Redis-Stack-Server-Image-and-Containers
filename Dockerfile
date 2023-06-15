# ***************************************************************************************************************************************
# * Dockerfile                                                                                                                          *
#  **************************************************************************************************************************************
#  *                                                                                                                                    *
#  * @License Starts                                                                                                                    *
#  *                                                                                                                                    *
#  * Copyright © 2015 - present. MongoExpUser.  All Rights Reserved.                                                                    *
#  *                                                                                                                                    *
#  * License: MIT - https://github.com/MongoExpUser/Ubuntu-Ubuntu-Redis-Stack-Server-Image-and-Container/blob/main/LICENSE              *
#  *                                                                                                                                    *
#  * @License Ends                                                                                                                      *
#  **************************************************************************************************************************************
# *                                                                                                                                     *
# *  Project: Ubuntu-Redis-Stack-Server Image & Container Project                                                                       *
# *                                                                                                                                     *
# *  This Dockerfile creates an image based on:                                                                                         *
# *                                                                                                                                     *                                                                                                              *
# *   0)  Ubuntu Linux 22.04: Jammy                                                                                                     *
# *                                                                                                                                     *
# *   1)  Additional Ubuntu Utility Packages                                                                                            *
# *                                                                                                                                     *
# *   2)  Redis Stack Server (v6.2.6-v7) and Sentinel (v2)                                                                              *
# *                                                                                                                                     *
# *   3)  Python v3.x                                                                                                                   *
# *                                                                                                                                     *
# *   4)  Python3-pip                                                                                                                   *
# *                                                                                                                                     *
# *   5)  Boto3                                                                                                                         *
# *                                                                                                                                     *
# *   6)  Python's awscli upgrade                                                                                                       *
# *                                                                                                                                     *
# *   7)  Awscli v2                                                                                                                     *
# *                                                                                                                                     *
# *   8)  NodeJS v19.x, ExpressJS Server and NodeJS's Databases-related packages (redis, sqlite3 & duckdb)                              *
# *                                                                                                                                     *
# *   9)  Docker 23.06: docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin                                *
# *                                                                                                                                     *
# *                                                                                                                                     *
# ***************************************************************************************************************************************

# Base Image Version: Any of 22.04, jammy-20230425 and jammy.
# Ref: https://hub.docker.com/_/ubuntu
FROM ubuntu:22.04

# Labels
LABEL maintainer="MongoExpUser"
LABEL maintainer_email="info@domain.com"
LABEL company="MongoExpUser"
LABEL version="1.0"

# Create user and add it to the sudoers group
RUN apt-get -y update && apt-get -y install sudo
RUN adduser --disabled-password --gecos 'app' adminuser
RUN adduser adminuser sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Make and change to base dir
RUN cd /home/ \
  && sudo mkdir /home/base \
  && sudo mkdir /home/app \
  && cd /home/base

# Install packages
RUN sudo apt-get -y update && apt-get -y upgrade \
    # 1. additional ubuntu packages
    && sudo apt-get install -y systemd apt-utils nfs-common nano unzip zip gzip \
    && sudo apt-get install -y sshpass cmdtest snap nmap net-tools wget curl tcl-tls \
    && sudo apt-get install -y iputils-ping certbot python3-certbot-apache gnupg gnupg2 telnet \
    && sudo apt-get install -y aptitude build-essential gcc make screen snapd spamc parted openssl   \
    && sudo apt-get install -y systemd procps spamassassin \
    #  2. redis-stack-server (6.2.12) & sentinel (v2)
    #  a. redis-stack-server
    && curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg \
    && sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs)  main" | sudo tee /etc/apt/sources.list.d/redis.list \
    && sudo apt-get -y update \
    && sudo apt-get -y install redis-stack-server \
    && sudo chmod 777 /var/lib/redis-stack/ \
    && sudo chmod 777 /var/run \
    && sudo chmod 777 /var/log \
    && sudo chmod 777 /etc/redis-stack.conf \
    && sudo scp /etc/redis-stack.conf /etc/redis-stack.conf.bak \
    #  b. redis sentinel
    && sudo apt-get -y update \
    && sudo apt-get -y install redis-sentinel \
    # && sudo mkdir /run/sentinel \
    && sudo chmod 777 /run \
    # && sudo chmod 777 /run/sentinel \
    && sudo chmod 777 /var/lib/redis \
    && sudo chmod 777 /var/log/redis \
    && sudo chmod 777 /etc/redis/sentinel.conf \
    && sudo scp /etc/redis/sentinel.conf /etc/redis/sentinel.conf.bck \
    #  3. python3.x
    && sudo apt-get -y install python3  \
    #  4. python3-pip
    && sudo apt-get -y install python3-pip \
    #  5. boto3
    && sudo python3 -m pip install boto3  \
    #  6. upgrade python's awscli package
    && sudo python3 -m pip install --upgrade awscli \
    #  7.  awscli v2
    && sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip \
    && sudo chmod 777 awscliv2.zip \
    && sudo unzip awscliv2.zip \
    && sudo ./aws/install \
    #  8. node.js v19.x and related packages
    && curl -sL https://deb.nodesource.com/setup_19.x | sudo -E bash - \
    && echo -e "\n" \
    && sudo apt-get install -y nodejs \
    && echo -e "\n" \
    #  create node.js' package.json file
    && sudo echo '{ \
        "name": "Nodejs-Expressjs", \
        "version": "1.0", \
        "description": "A web server, based on the Node.js-Express.js (NE) stack", \
        "license": "MIT", \
        "main": "./app.js", \
        "email": "info@domain.com", \
        "author": "Copyright © 2023. MongoExpUser.  All Rights Reserved.", \
        "dependencies"    : \
        { \
            "express"       : "*" \
        }, \
        "devDependencies": {}, \
        "keywords": [ \
            "NodeJS", \
            "ExpressJS", \
            "Redis\"" \
        ] \
    }' > package.json \
    && sudo npm install -g npm \
    # install modules is the specified prefix path
    && sudo npm install --prefix "/" express@5.0.0-alpha.8 redis sqlite3 duckdb \
    #  9. Docker 23.06: docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    && sudo apt-get -y update \
    && sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release \
    && sudo mkdir -m 0755 -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && sudo apt-get -y update \
    && sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    # 10 . finally, clean-up
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get autoclean \
    && sudo apt-get autoremove
