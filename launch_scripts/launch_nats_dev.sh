cat >~/.config/nats.conf <<EOF
websocket: {
  port: 4223
  no_tls: true
}
EOF
nats-server -c ~/.config/nats.conf