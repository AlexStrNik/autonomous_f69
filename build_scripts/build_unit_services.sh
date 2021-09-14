#!/bin/bash
services_py=$(find services/**_py/main.py)
services_rs=$(find services/**_rs/Cargo.toml)
for service in $services_py; do
    service_name=$(basename $(dirname $service))
    cat >services/$service_name/$service_name.service <<EOF
[Unit]
Description=NATS $service_name service
After=nats.service

[Service]
WorkingDirectory=$(realpath $(dirname $service))
Environment=PYTHONPATH=:/usr/local/lib/python3.6/pyrealsense2
ExecStart=/usr/bin/python3 $(realpath $service)
User=$(id -un)
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
done;
for service in $services_rs; do
    service_name=$(basename $(dirname $service))
    service_bin=$(realpath services/$service_name/target/release/$service_name)
    cat >services/$service_name/$service_name.service <<EOF
[Unit]
Description=NATS $service_name service
After=nats.service

[Service]
WorkingDirectory=$(dirname $service_bin)
ExecStart=$service_bin
User=$(id -un)
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
done;