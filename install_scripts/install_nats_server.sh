#!/bin/bash
tag=$(curl -s https://github.com/nats-io/nats-server/releases/latest | grep -o "v[0-9.]\+")
curl -L https://github.com/nats-io/nats-server/releases/download/$tag/nats-server-$tag-linux-arm64.zip -o nats-server.zip
unzip nats-server.zip -d nats-server
cp nats-server/nats-server-$tag-linux-arm64/nats-server /usr/bin
rm -rf nats-server
rm -rf nats-server.zip