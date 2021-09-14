from pynats import NATSClient

from _schemas import movement_pb2
from typing import Union


def get_msg(speed: Union[float, None], steer: Union[float, None]) -> movement_pb2.MovementRequest:
    """Function generates movement request"""
    movement_request = movement_pb2.MovementRequest()
    movement_request.speed_null = speed is None
    movement_request.steering_null = steer is None

    if speed:
        movement_request.speed_value = speed
    if steer:
        movement_request.steering_value = steer

    return movement_request


if __name__ == "__main__":
    client = NATSClient()
    client.connect()

    movement_request = get_msg(speed=0.1, steer=1)

    response = client.request("movement_controller",
                              payload=movement_request.SerializeToString())

    pong_response = movement_pb2.MovementResponse()
    pong_response.ParseFromString(response.payload)
    print("response:", pong_response.success)
