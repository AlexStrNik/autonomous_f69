#!/bin/bash
services_py=$(find services/**_py/schemas.txt)
services_rs=$(find services/**_rs/schemas.txt)
cd schemas
for service in $services_py; do
    if [ -d ../$(dirname $service)/_schemas ]; then rm -rf ../$(dirname $service)/_schemas; fi;
    mkdir ../$(dirname $service)/_schemas;
    cat ../$service | xargs protoc --python_out ../$(dirname $service)/_schemas;
    touch ../$(dirname $service)/_schemas/__init__.py;
    find ../$(dirname $service)/_schemas/*_pb2.py | xargs sed -i -E "s/import ([a-z0-9]+_pb2) as ([a-z0-9]+__pb2)/from . import \1 as \2/g"
done
for service in $services_rs; do
    if [ -d ../$(dirname $service)/src/_schemas ]; then rm -rf ../$(dirname $service)/src/_schemas; rm ../$(dirname $service)/src/_schemas.rs; fi;
    mkdir ../$(dirname $service)/src/_schemas;
    cat ../$service | xargs protoc --rust_out ../$(dirname $service)/src/_schemas;
    for proto in $(cat ../$service); do
        proto_file=$(basename $proto);
        echo "pub mod ${proto_file%.*};" >> ../$(dirname $service)/src/_schemas.rs;
    done
done
if [ -d ../tools/viewer/src/_schemas ]; then rm -rf ../tools/viewer/src/_schemas; fi;
mkdir ../tools/viewer/src/_schemas
cat ../tools/viewer/schemas.txt | xargs protoc --ts_proto_opt esModuleInterop=true --ts_proto_out ../tools/viewer/src/_schemas