schemas=$(find schemas/*.proto)
if [ -d build/schemas ]; then rm -rf build/schemas; fi
mkdir -p build/schemas
protoc --python_out build --rust_out build $schemas