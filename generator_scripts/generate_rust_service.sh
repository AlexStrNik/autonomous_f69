service=$1_rs
if [ -d services/$service ]; then echo "error: service already exists" >>/dev/stderr; exit 1; fi;
cargo init services/$service
echo "ping.proto" > services/$service/schemas.txt
echo "protobuf = \"2.25.1\"" >> services/$service/Cargo.toml
echo "nats = \"0.15.1\"" >> services/$service/Cargo.toml
cat >services/$service/src/main.rs <<EOF
mod _schemas;

use protobuf::Message;
use _schemas::ping::*;

fn main() {
    let client = nats::connect("nats://127.0.0.1:4222").unwrap();

    let sub = client.subscribe("ping").unwrap();

    for msg in sub.messages() {
        let ping_request = PingRequest::parse_from_bytes(&msg.data).unwrap();

        let mut pong_response = PongResponse::new();
        pong_response.set_number(ping_request.get_number() + 1);
        let bytes = pong_response.write_to_bytes().unwrap();

        msg.respond(bytes).unwrap();
    }
}
EOF
cd ../../