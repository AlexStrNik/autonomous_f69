from pynats import NATSClient
import pyrealsense2 as rs

from _schemas import position_pb2, vector3_pb2, quaternion_pb2

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

                    rotation = quaternion_pb2.Quaternion()
                    rotation.x = data.rotation.x
                    rotation.y = data.rotation.y
                    rotation.z = data.rotation.z
                    rotation.w = data.rotation.w

                    frame.position.CopyFrom(position)
                    frame.rotation.CopyFrom(rotation)

                    client.publish(
                        "position", payload=frame.SerializeToString())
        finally:
            pipe.stop()
