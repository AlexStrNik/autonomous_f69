services_py=$(find services/**_py/schemas.txt)
services_rs=$(find services/**_rs/schemas.txt)
cd schemas
for service in $services_py; do
    cat ../$service | xargs protoc --python_out ../$(dirname $service);
done
for service in $services_rs; do
    cat ../$service | xargs protoc --rust_out ../$(dirname $service);
done