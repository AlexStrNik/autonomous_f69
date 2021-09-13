schemas=$(find schemas/*.proto)
protoc --python_out schemas/out --rust_out schemas/out $schemas