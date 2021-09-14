mod _schemas;

use protobuf::Message;
use _schemas::ping::*;

fn main() {
    let client = nats::connect("nats://127.0.0.1:4222").unwrap();

    let sub = client.subscribe("ping2").unwrap();

    for msg in sub.messages() {
        let ping_request = PingRequest::parse_from_bytes(&msg.data).unwrap();

        let mut pong_response = PongResponse::new();
        pong_response.set_number(ping_request.get_number() + 1);
        let bytes = pong_response.write_to_bytes().unwrap();

        msg.respond(bytes).unwrap();
    }
}
