services_py=$(find services/**_py/schemas.txt)
services_rs=$(find services/**_rs/schemas.txt)
cd schemas
for service in $services_py; do
    if [ -d ../$(dirname $service)/_schemas ]; then rm -rf ../$(dirname $service)/_schemas; fi;
    mkdir ../$(dirname $service)/_schemas;
    cat ../$service | xargs protoc --python_out ../$(dirname $service)/_schemas;
    touch ../$(dirname $service)/_schemas/__init__.py;
done
for service in $services_rs; do
    if [ -d ../$(dirname $service)/src/_schemas ]; then rm -rf ../$(dirname $service)/src/_schemas; fi;
    mkdir ../$(dirname $service)/src/_schemas;
    echo "" > ../$(dirname $service)/src/_schemas.rs;
    cat ../$service | xargs protoc --rust_out ../$(dirname $service)/src/_schemas;
    for proto in $(cat ../$service); do
        echo $proto
        echo "pub mod $(basename $proto);" >> ../$(dirname $service)/src/_schemas.rs;
    done
done