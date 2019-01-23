#!/bin/bash

set -e

docker --version
docker-compose --version
git --version

compose_repo=$(pwd)
known_good=4f5df39bdd9ce05146da14bb60f5a17a163d5262
known_bad=0b83014ff81b68b8fde21521662339396c277ab8
mkdir -p /tmp/debug-caddy
cd /tmp/debug-caddy

test -d caddy || git clone https://github.com/mholt/caddy

cd caddy
git reset --hard origin/master
git bisect reset
git bisect start
git bisect good $known_good
git bisect bad $known_bad

function iterate {
  export caddy_revision=$(git rev-parse --short HEAD)

  echo "testing revision $caddy_revision"
  docker-compose -f $compose_repo/docker-compose.yaml build --build-arg caddy_revision=$caddy_revision
  docker-compose -f $compose_repo/docker-compose.yaml up 2>&1 | tee log

  if grep "listen tcp :443: bind: permission denied" log; then
    git bisect bad
  else
    git bisect good
  fi

  docker-compose -f $compose_repo/docker-compose.yaml rm -sf

  remaining_versions=$(git bisect visualize --oneline | wc -l)

  if [[ remaining_versions -lt 2 ]]; then
    echo "bisect finished. cuplrit is:"
    git bisect view
    exit
  fi

}


while true; do iterate; done
