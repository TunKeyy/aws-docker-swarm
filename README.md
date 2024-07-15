# AWS DOCKER SWARM
## Used Technologies
- Simple NodeJS and PHP Service
- NGINX
- SAMBA Storage
- Terraform
- GitHub Actions
- AWS EC2, VPS, S3 Bucket
- Docker Swarm

Main Flow:
![image](https://github.com/user-attachments/assets/d6e6b0b8-f46b-4ed5-b08e-171d422d594f)


# Terraform

Set env for terraform authentication
On Ubuntu:
```
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
```

Create VPC (Virtual Private Cloud) for 2 machines
Create Subnet, Security Group

# Docker Swarm

On Node manager:
```
docker swarm init --advertise-addr=<instance_id>
```

On Node worker:
```
docker swarm join --token SWMTKN-1-5ykjese7u9x32yisvmz24jnb300l6yxjl2xtqyzljbmnpdprm0-4y4x1qeyndau2c8fg1xn4gu0h 13.213.42.239:2377
```

Create new service on Node manager:

```
docker service create --replicas 5 -p 8085:8085 --name testservice khanguyentuan/swarmtest:node
```

Update image for services:
```
docker service update --image=khanguyentuan/swarmtest:php
```


# Docker Stack
Copy docker compose configuration from local to remote
```
scp -i "key.pem" /directory/docker-compose.yml ubuntu@<ec2-ip>:/home/ubuntu
```
Create stack running services in Docker Compose

Using stack to apply services defined in docker-compose file
```
docker stack deploy --compose-file docker-compose.yml teststack
```
or
```
docker stack deploy -c docker-compose.yml t1
```

Check services
```
docker stack services teststack
```

Remove stack
```
docker stack rm teststack
```

# Overlay network - ensure that containers in the same service can communicate with each other
![alt text](image.png)

```
docker network create -d (driver) overlay mynetwork1
docker network ls
```

Indicate a network for the service
```
docker service create --replicas 5 -p 8085:8085 --name testservice --network mynetwork1 khanguyentuan/swarmtest:node
```

Create an attachable network - network for isolated containers to connect, these containers are not created from service of node manager

```
docker network create -d overlay --attachment mynetwork2
```

# Volumes

There are 2 types of volumes:
    - Local Volume: Use in local disk scope and cannot be accessed from other server
    - Network Volume: Shared volume between services, using a certain service to store file, data, ...

Some types of network volume:
    - NFS
    - SAMBA(SMB)
    - SSH

# Note
Check logs of an instance
```
docker inspect <instance_id>
```

Create shared volume
```
docker volume create --driver local --name v2 --opt type=cifs --opt device=//54.255.208.228/data/ --opt o="username=smbuser,password=1234567,file_mode=0777,dir_mode=0777"
```
Create a docker service manually
```
docker service create --name service2 --network net2 -p 8085:8085 --mount type=volume,source=vol2,target=/d2 --replicas 5   --limit-cpu 0.5   --limit-memory 150M --reserve-cpu 0.25  --reserve-memory 50M   --restart-condition on-failure khanguyentuan/swarmtest:node
```
