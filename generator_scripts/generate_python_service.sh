service=$1_py
mkdir services/$service
echo "ping.proto" > services/$service/schemas.txt
echo "protobuf==3.17.3" > services/$service/requirements.txt
echo "nats-python==0.8.0" >> services/$service/requirements.txt
cat >services/$service/main.py <<EOF
from pynats import NATSClient

from _schemas import ping_pb2

if __name__ == "__main__":
    with NATSClient() as client:
        client.connect()

        def pong(message):
            ping_request = ping_pb2.PingRequest()
            ping_request.ParseFromString(message.payload)

            pong_response = ping_pb2.PongResponse()
            pong_response.number = ping_request.number + 1

            client.publish(
                message.reply, payload=pong_response.SerializeToString())

        client.subscribe("ping", callback=pong)

        client.wait()
EOF