from pynats import NATSClient

from _schemas import movement_pb2

if __name__ == "__main__":
    client = NATSClient()
    client.connect()

    movement_request = movement_pb2.MovementRequest()
    movement_request.steering_value = float(input("request steering angle: "))
    movement_request.speed_null = True

    response = client.request("movement_controller",
                              payload=movement_request.SerializeToString())

    pong_response = movement_pb2.MovementResponse()
    pong_response.ParseFromString(response.payload)
    print("response:", pong_response.success)
