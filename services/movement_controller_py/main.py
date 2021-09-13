from pynats import NATSClient
import serial
import math

from _schemas import movement_pb2

CONTROLLER_PORT = "/dev/ttyACM0"

controller = None
try:
    controller = serial.Serial(
        port=CONTROLLER_PORT, baudrate=115200, timeout=5)
except Exception as e:
    print(e)
    ...


def turn_wheels(ratio: float) -> None:
    if not (-1 <= ratio <= 1):
        raise Exception("Ratio for steering is out of [-1, 1]")
    valuesRange = 80  # we have 80 values to determine position of steering wheel
    speed = int((ratio + 1.0) * valuesRange / 2)
    s_code = 115    # s
    controller.write(bytearray([s_code, speed]))


def run_motors(ratio: float) -> None:
    if not (-1 <= ratio <= 1):
        raise Exception("Ratio for motors speed is out of [-1, 1]")
    if ratio < 0:
        # range for reverse is from 0 to 130
        speed = math.floor((ratio + 1.0) * 130)
    elif ratio == 0:
        # 131 is full stop
        speed = 131
    elif ratio > 0:
        # range for forward is from 131 to 211
        speed = math.ceil(131 + (ratio * 80))

    r_code = 114    # r
    controller.write(bytearray([r_code, speed]))


if __name__ == "__main__":
    with NATSClient() as client:
        client.connect()

        def movement_callback(message):
            global controller

            movement_request = movement_pb2.MovementRequest()
            movement_request.ParseFromString(message.payload)

            if not controller:
                # try to reconnect
                try:
                    controller = serial.Serial(
                        port=CONTROLLER_PORT, baudrate=115200, timeout=5)
                except:
                    controller = None

            if controller:
                # send values only if we are connected
                if not movement_request.steering_null:
                    turn_wheels(movement_request.steering_value)
                if not movement_request.speed_null:
                    run_motors(movement_request.speed_value)

            movement_response = movement_pb2.MovementResponse()
            movement_response.success = controller != None

            client.publish(
                message.reply, payload=movement_response.SerializeToString())

        client.subscribe("movement_controller", callback=movement_callback)

        client.wait()
