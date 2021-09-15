import { Container, Graphics, Stage } from "@inlet/react-pixi";
import { Point } from "@pixi/math";
import { NatsError } from "nats.ws/lib/nats-base-client/error";
import { Msg, NatsConnection } from "nats.ws/lib/nats-base-client/types";
import { useEffect, useState } from "react";
import { Points } from "../_schemas/points";

const width = 600.0;
const height = 600.0;

const PointsView = ({ points }: { points: Point[] }) => {
  return (
    <Graphics
      scale={1}
      draw={(g) => {
        if (points.length == 0) return;
        g.clear();

        for (let i = 1; i < points.length; i++) {
          g.beginFill(0xff0022);
          g.drawCircle(points[i].x, points[i].y, 3);
          g.endFill();
        }
      }}
    />
  );
};

export default function PointsViewer({
  nc,
}: {
  nc: NatsConnection | undefined;
}) {
  useEffect(() => {
    if (nc === undefined) return;
    nc.subscribe("points", { callback: newPointsReceived });
  }, [nc]);

  const [points, setPoints] = useState<Point[]>([
    ...Array(50).fill(new Point(100, 100)),
  ]);

  const newPointsReceived = (_err: NatsError | null, msg: Msg) => {
    const pointsRawArray = Points.decode(msg.data);
    // if (pointsRawArray.points.length !== (points ?? []).length) {
    //   setPoints([...Array(pointsRawArray.points.length).fill(new Point(0, 0))]);
    // }

    let max = 0;

    const mapCoordinates = (x: number, y: number): [number, number] => {
      return [
        (width * x) / max / 2 + width / 2,
        (height * y) / max / 2 + height / 2,
      ];
    };

    pointsRawArray.points.forEach((value, idx) => {
      if (Math.abs(value.x) > max) {
        max = Math.abs(value.x);
      }
      if (Math.abs(value.y) > max) {
        max = Math.abs(value.y);
      }
    });

    max *= 1.1;

    const np = pointsRawArray.points.map((value) => {
      const [x, y] = mapCoordinates(value.x, value.y);

      return new Point(x, height - y);
    });
    setPoints(np);
  };

  return (
    <Container interactive={true}>
      <PointsView points={points} />
    </Container>
  );
}
