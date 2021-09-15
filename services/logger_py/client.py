from pynats import NATSClient

from _schemas import log_pb2


if __name__ == "__main__":
    client = NATSClient("nats://192.168.50.165:4222")
    client.connect()

    user_msg = log_pb2.Log()
    user_msg.message = (input("request: "))

    client.publish("logger", payload=user_msg.SerializeToString())
