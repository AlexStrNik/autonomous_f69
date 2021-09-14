cat >/etc/nats.conf <<EOF
websocket: {
  port: 4223
  no_tls: true
}
EOF
cat >/etc/systemd/system/nats.service <<EOF
[Unit]
Description=NATS server
After=network.target

[Service]
ExecStart=/usr/bin/nats-server -c /etc/nats.conf
User=$(id -un)
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl enable nats
systemctl restart nats