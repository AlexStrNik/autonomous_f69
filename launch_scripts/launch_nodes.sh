services_py=$(find services/**_py/main.py)
services_rs=$(find services/**_rs/Cargo.toml)
for service in $services_py; do
    service_name=$(basename $(dirname $service))
    systemctl stop $service_name
done
for service in $services_rs; do
    service_name=$(basename $(dirname $service))
    systemctl stop $service_name
done
for service in $(cat $1); do
    systemctl restart service
done