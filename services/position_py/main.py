from pynats import NATSClient
import pyrealsense2 as rs

from _schemas import position_pb2, vector3_pb2

cfg = rs.config()
cfg.enable_stream(rs.stream.pose)

if __name__ == "__main__":
    pipe = rs.pipeline()
    pipe.start(cfg)

    with NATSClient() as client:
        client.connect()

    try:
        while True:
            frames = pipe.wait_for_frames()
            pose = frames.get_pose_frame()

            if pose:
                data = pose.get_pose_data()

                frame = position_pb2.Position()
                frame.position = vector3_pb2.Vector3()

                frame.position.x = data.translation.x
                frame.position.y = data.translation.y
                frame.position.z = data.translation.z

                client.publish("position", payload=frame)
    finally:
        pipe.stop()
