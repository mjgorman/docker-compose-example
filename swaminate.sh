#!/bin/sh
#source: https://gist.github.com/cpuguy83/79ad11aaf8e78c40ca71

set -e

create() {
  echo Setting up kv store
  docker-machine create -d virtualbox kvstore > /dev/null && \
  docker $(docker-machine config kvstore) run -d --net=host progrium/consul --server -bootstrap-expect 1

  # store the IP address of the kvstore machine
  kvip=$(docker-machine ip kvstore)

  echo Creating cluster nodes
  docker-machine create -d virtualbox \
    --engine-opt "cluster-store consul://${kvip}:8500" \
    --engine-opt "cluster-advertise eth1:2376" \
    --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.9.0/boot2docker.iso \
    --swarm \
    --swarm-master \
    --swarm-image swarm:1.0.0 \
    --swarm-discovery consul://${kvip}:8500 \
    swarm-demo-1 > /dev/null &

  for i in 2 3; do
    docker-machine create -d virtualbox \
      --engine-opt "cluster-store consul://${kvip}:8500" \
      --engine-opt "cluster-advertise eth1:2376" \
      --swarm \
      --swarm-discovery consul://${kvip}:8500 \
      --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.9.0/boot2docker.iso \
      swarm-demo-$i > /dev/null &
  done
  wait
}

teardown() {
  docker-machine rm kvstore &
  for i in 1 2 3; do
    docker-machine rm -f swarm-demo-$i &
  done
  wait
}

case $1 in
  up)
    create
    ;;
  down)
    teardown
    ;;
  *)
    echo "I literally can't even..."
    exit 1
    ;;
esac
