from pynats import NATSClient

from _schemas import ping_pb2

if __name__ == "__main__":
    client = NATSClient("nats://192.168.50.165:4222")
    client.connect()

    ping_request = ping_pb2.PingRequest()
    ping_request.number = int(input("request: "))

    response = client.request("ping", payload=ping_request.SerializeToString())

    pong_response = ping_pb2.PongResponse()
    pong_response.ParseFromString(response.payload)
    print("response:", pong_response.number)
