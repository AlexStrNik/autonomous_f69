#!/bin/bash
cat >~/.config/nats.conf <<EOF
websocket: {
  port: 4223
  no_tls: true
}
EOF
killall nats-server &>/dev/null
nats-server -c ~/.config/nats.conf