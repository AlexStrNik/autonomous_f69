from pynats import NATSClient
import pyrealsense2 as rs

from _schemas import depth_image_pb2

cfg = rs.config()
cfg.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)

if __name__ == "__main__":
    pipe = rs.pipeline()
    pipe.start(cfg)

    with NATSClient() as client:
        client.connect()

        try:
            while True:
                frames = pipe.wait_for_frames()
                depth = frames.get_depth_frame()

                if depth:
                    depth_image = depth_image_pb2.DepthImage()
                    depth_image.bytes = depth.get_data()

                    client.publish(
                        "position", payload=depth_image.SerializeToString())
        finally:
            pipe.stop()
