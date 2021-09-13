cat >/etc/systemd/system/nats.service <<EOF
[Unit]
Description=NATS server
After=network.target

[Service]
ExecStart=/usr/bin/nats-server
User=$(id -un)
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl enable nats
systemctl start nats