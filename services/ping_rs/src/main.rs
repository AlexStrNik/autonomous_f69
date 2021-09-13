mod _schemas;

use protobuf::Message;
use _schemas::ping::*;

fn main() {
    let client = nats::connect("nats://192.168.50.165:4222").unwrap();

    let sub = client.subscribe("ping").unwrap();

    for msg in sub.messages() {
        let ping_request = PingRequest::parse_from_bytes(&msg.data).unwrap();

        let mut pong_response = PongResponse::new();
        pong_response.number = ping_request.number + 1;
        let bytes = pong_response.write_to_bytes().unwrap();

        msg.respond(bytes).unwrap();
    }
}
