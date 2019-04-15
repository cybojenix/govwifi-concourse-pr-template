#!/bin/bash

# Launches the docker daemon, and loads our cached images from the `docker-cache` folder.

source /docker-helpers.sh
start_docker

function load_layers() {
  
  [[ ! -d 'docker-cache' ]] && return 0

  echo "loading docker layer cache"
  pids=

  index=0
  for cached_image in docker-cache/*/image.tar; do
    docker load -qi "${cached_image}" & pids[${index}]=$!
    index="$(( "${index}" + 1 ))"
  done

  for pid in ${pids[*]}; do
    wait "$pid"
  done
}
load_layers
