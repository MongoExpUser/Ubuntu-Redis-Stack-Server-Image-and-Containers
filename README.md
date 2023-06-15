# Ubuntu-Redis-Stack-Server-Image-and-Container
## Redis Stack Server with Auto Failover 

<strong> Create Image and Deploy Containers for Redis Stack Servers (1 Primary and 2 Replicas) with Auto Failover for an IOT Application.</strong>
<br><br>


### 1) Build Image:                                                                                             
     * Build
     sudo docker build --no-cache -t iot/ubuntu-22.04-redis-stack-server-6.2.6-v7:latest .                                                  
     
 ### 2) Deploy Container:                                                                                             
     * Deploy containers with docker compose
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" up -d

     * stop and remove containers with related network
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" down

     * stop services
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" stop

     * start services
     set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" start

      * logs: view output from containers
      set PWD=%cd% && sudo docker compose -f docker-compose-redis.yml --project-directory $PWD --project-name "iot-app" logs 
      
 ### 3) Check Logs From Inside the Host - <strong> FIRST CHECK AFTER DEPOYMENT</strong>:                                                                                             
     * Redis Nodes
       * aa
       * bb 
     * Sentinel Nodes   
       * aa
       * bb 
 ### 4) Interact with Containers:                                                                                             
       * Redis Nodes
       * aa
       * bb <br>
     * Sentinel Nodes   
       * aa
       * bb <br>
  ### 5) Connect to Redis and Sentinel Servers Inside the Container:                                                                                          
       * Redis Nodes
       * aa
       * bb <br>
     * Sentinel Nodes   
       * aa
       * bb <br>
  ### 6) Check Configuration Information: Run Directly with Bash                                                                                                                    
     * Redis Nodes
       * aa
       * bb <br>
     * Sentinel Nodes   
       * aa
       * bb <br>


# License

Copyright © 2023. MongoExpUser

Licensed under the MIT license.
