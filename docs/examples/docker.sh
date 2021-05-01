#!/usr/bin/env bash

# Check the `docker-compose.yml` file for comments on what to change

docker run \
    jmuchovej/zerodns:latest \
    -n zerodns --rm \
    --restart unless-stopped \
    --cap-add NET_ADMIN --cap-add SYS_ADMIN \
    --device /dev/net/tun \
    -p 5053:5053/udp -p 5053:5053/tcp \
    -v "/path/to/zerodns/config:/config" \
    -e PUID=1000 -e PGID=1000 -e TZ="America/New_York" \
    -e ACCESS_TOKEN="SomeSuperDuperSecretToken" \
    --dns 127.0.0.1 --dns 1.1.1.1 --dns 1.0.0.1
