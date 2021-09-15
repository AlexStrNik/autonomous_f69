from pynats import NATSClient
import math
import pyrealsense2 as rs

from _schemas import vector2_pb2, points_pb2

POINTS_N = 50
HOI = 5
HOI_SHIFT = -20
FOV = 86.0

pipeline = rs.pipeline()

config = rs.config()
config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)

pipeline.start(config)

if __name__ == "__main__":
    with NATSClient() as client:
        client.connect()

        while True:
            frames = pipeline.wait_for_frames()

            depth = frames.get_depth_frame()

            if not depth:
                continue

            dx = int(640 / POINTS_N)
            ddx = dx / HOI
            da = FOV / POINTS_N

            y = int((480 - HOI) / 2) - HOI_SHIFT

            angle = -FOV / 2.0
            x = 0

            frame = points_pb2.Points()

            for _ in range(POINTS_N):
                median_len = 0
                for i in range(HOI):
                    median_len += depth.get_distance(x + dx * i, y + i)
                median_len /= HOI

                # TODO: filter

                rads = math.radians(angle)
                px = math.cos(rads + math.pi / 2.0) * median_len
                py = math.sin(rads + math.pi / 2.0) * median_len

                point = vector2_pb2.Vector2()
                point.x = px
                point.y = py

                frame.points.append(point)

                x += dx
                angle += da

            client.publish(
                "points", payload=frame.SerializeToString())
