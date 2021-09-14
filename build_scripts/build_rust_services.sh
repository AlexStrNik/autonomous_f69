#!/bin/bash
services_rs=$(find services/**_rs/Cargo.toml)
_pwd=$(pwd)
for service in $services_rs; do
    cd $(dirname $service);
    cargo b --release;
    cd $_pwd;
done;