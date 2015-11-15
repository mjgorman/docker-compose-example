# Docker-compose example
This example shows how to setup a scalable application backed by a redis server all balanced behind an HAProxy server.

#Requirements

Docker 1.9

Docker Machine on OSX(Minor changes to compose file needed to run on true cluster)

Docker swarm setup with at least 3 nodes for true test (https://docs.docker.com/swarm/install-w-machine/)

I've included a script called swarminate.sh to setup the swarm in docker machine with consule for multihost networking.

#Usage

##Running the cluster(With Multi-host networking) in the foreground

docker-compose --x-networking up

##Running the cluster(With Multi-host networking) in the background

docker-compose --x-networking up -d

##Checking the status of the containers

docker-compose ps

## Scaling the app(across multiple servers)
docker-compose --x-networking scale backend=n(number of servers you'd like)

##Acces the app

Using docker-compose ps find the IP address (ex: 192.168.99.102:80->80/tcp). Setup your hosts file with the ip you found and the names swarm and python.swarm.demo for the host. You can access the haproxy stats page (http://swarm/haproxy?stats) with login stats and password interlock. This will show all detected backends. Something to note is that interlock isn't limited to a single backend app. You can scale a single app or setup multiple simply by having other servers with differnt host and domain environment information as seen in the current docker-compose.yml.

To see the application the http://python.swarm.demo/ url in your favorite browser. Using you browser's built in tools view the cookie storage, there will be a cookie set with the container id of the backend application server you have accessed. 

The application simply acceses redis and increments a counter. Swarm is used for service discovery, Interlock's HAProxy loadbalances round robin between the backends it finds with matching hostnames/domains. Each refresh you should observe the cookie changing to another backend server id. You can match these container IDs to output from the docker ps command.

##Shutting down

docker-compose stop
