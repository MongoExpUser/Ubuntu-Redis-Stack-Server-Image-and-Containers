# Ubuntu-Redis-Stack-Server-Image-and-Containers
## Redis Stack Servers with Auto Failover 

<strong> Create Image and Deploy Containers for Redis Stack Servers (1 Primary and 2 Replicas) with Auto Failover for an IOT Application.</strong>
<br><br>

## Architectural Diagram
![Image description](https://github.com/MongoExpUser/Ubuntu-Redis-Stack-Server-Image-and-Containers/blob/main/redis-stack-server-sentinel.png)

### 1) Build Image:                                                                                             
     * Build
     sudo docker build --no-cache -t iot/ubuntu-22.04-redis-stack-server-6.2.6-v7:latest .
     
 ### 2) Deploy Containers with Docker Compose:                                                                                             
     * Deploy containers 
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" up -d
     
     * stop and remove containers with related network
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" down
     
     * stop services
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" stop
     
     * start services
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" start
     
     * logs: view output from containers
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" logs 
 ### 3) Check Logs From Inside the Host -  First Check After Deployment</strong>:                                                                                             
     * Redis Nodes
     sudo docker exec -it redis-node1 /bin/bash -c "sudo tail -n 600  /var/log/redis.log"
     sudo docker exec -it redis-node2 /bin/bash -c "sudo tail -n 600  /var/log/redis.log"
     sudo docker exec -it redis-node3 /bin/bash -c "sudo tail -n 600  /var/log/redis.log"
     
     * Sentinel Nodes   
     sudo docker exec -it sentinel-node1 /bin/bash -c "sudo tail -n 600  /var/log/redis/redis-sentinel.log"
     sudo docker exec -it sentinel-node2 /bin/bash -c "sudo tail -n 600  /var/log/redis/redis-sentinel.log"
     sudo docker exec -it sentinel-node3 /bin/bash -c "sudo tail -n 600  /var/log/redis/redis-sentinel.log"
 ### 4) Interact with Containers/Connect to Containers:                                                                                             
     * Redis Nodes
     sudo docker exec -it redis-node1 /bin/bash
     sudo docker exec -it redis-node2 /bin/bash
     sudo docker exec -it redis-node3 /bin/bash
     
     * Sentinel Nodes   
     sudo docker exec -it sentinel-node1 /bin/bash
     sudo docker exec -it sentinel-node2 /bin/bash
     sudo docker exec -it sentinel-node3 /bin/bash
  ### 5) Connect to Redis and Sentinel Servers Inside the Containers:                                                                                          
     * Redis Nodes
     redis-cli --raw -h localhost -p 6379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a 

     * Sentinel Nodes   
     redis-cli --raw -h localhost -p 26379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a 
  ### 6) Check Configuration Information: Run Directly with Bash                                                                                                                    
     * Redis Nodes
     sudo docker exec -it redis-node1 /bin/bash -c "sudo redis-cli --raw -h localhost -p 6379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a password INFO"
     sudo docker exec -it redis-node2 /bin/bash -c "sudo redis-cli --raw -h localhost -p 6379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a password INFO"
     sudo docker exec -it redis-node3 /bin/bash -c "sudo redis-cli --raw -h localhost -p 6379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a password INFO"

     
     * Sentinel Nodes   
     sudo docker exec -it sentinel-node1 /bin/bash -c "sudo redis-cli --raw -h localhost -p 26379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a password INFO"
     sudo docker exec -it sentinel-node2 /bin/bash -c "sudo redis-cli --raw -h localhost -p 26379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a password INFO"
     sudo docker exec -it sentinel-node3 /bin/bash -c "sudo redis-cli --raw -h localhost -p 26379 --tls --cert /etc/ssl/certs/server.crt --key /etc/ssl/certs/server.key --cacert /etc/ssl/certs/root.crt -a password INFO"


# License

Copyright © 2023. MongoExpUser

Licensed under the MIT license.
