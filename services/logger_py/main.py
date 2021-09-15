from pynats import NATSClient

from _schemas import log_pb2

if __name__ == "__main__":
    with NATSClient() as client:
        client.connect()

        def logger_callback(message):
            msg = log_pb2.Log()
            msg.ParseFromString(message.payload)

            print("[LOG] [Service: {}]: {}".format(msg.sender, msg.message))

        client.subscribe("logger", callback=logger_callback)

        client.wait()
