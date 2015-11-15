# Docker-compose example
This example shows how to setup a scalable application backed by a redis server all balanced behind an HAProxy server.

#Requirements

Docker 1.9
Docker Machine on OSX(Minor changes to compose file needed to run on true cluster)
Docker swarm setup with at least 3 nodes for true test (https://docs.docker.com/swarm/install-w-machine/)

#Usage

##Running the cluster in the foreground

docker-compose up

##Running the Cluster in the background

docker-compose up -d

##Checking the status of the containers

docker-compose ps

##Acces the app

Using docker-compose ps find the IP address (ex: 192.168.99.102:80->80/tcp). Setup your hosts file with the ip you found and the name python.swarm.demo for the host. Open that host url in your favorite browser. Using you browser's built in tools view the cookie storage, there will be a cookie set with the container id of the backend application server you have accessed. The application simply acceses redis and increments a counter. Swarm is used for service discovery, Interlock's HAProxy loadbalances round robin between the backends it finds with matching hostnames/domains. Each refresh you should observe the cookie changing to another backend server id. You can match these container IDs to output from the docker ps command.

##Shutting down

docker-compose stop
