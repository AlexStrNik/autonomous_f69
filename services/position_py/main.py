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

                    position = vector3_pb2.Vector3()
                    position.x = data.translation.x
                    position.y = data.translation.y
                    position.z = data.translation.z

                    frame.position.CopyFrom(position)

                    client.publish(
                        "position", payload=frame.SerializeToString())
        finally:
            pipe.stop()
