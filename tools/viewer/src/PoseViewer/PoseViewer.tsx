import { Container, useTick, SimpleRope, Graphics } from "@inlet/react-pixi";
// import { Point } from "@pixi/math";
import { Point } from "pixi.js";
import { useEffect, useMemo, useRef, useState } from "react";
import { isNumber } from "util";
import { Position } from "../_schemas/position";

const width = 500;
const height = 240;

// function draws a sequence of points
const PointsView = ({ points }: { points: Point[] }) => {
  return (
    <Graphics
      x={30}
      y={height / 2}
      scale={0.4}
      draw={(g) => {
        if (points.length == 0) return;
        g.clear();
        g.lineStyle(2, 0xffc2c2);
        g.moveTo(points[0].x, points[0].y);

        for (let i = 1; i < points.length; i++) {
          g.lineTo(points[i].x, points[i].y);
        }

        for (let i = 1; i < points.length; i++) {
          g.beginFill(0xff0022);
          g.drawCircle(points[i].x, points[i].y, 10);
          g.endFill();
        }
      }}
    />
  );
};

export default function PoseViewer({
  lastPoint,
}: {
  lastPoint: Position | undefined;
}) {
  const i = useRef(0);

  const trailLen = 25;
  const ropeLen = 45;

  const initialPoints = useMemo(() => {
    const points = [];
    for (let i = 0; i < trailLen; i++) {
      points.push(new Point(i * ropeLen, 0));
    }
    return points;
  }, []);

  const [points, setPoints] = useState(initialPoints);

  useEffect(() => {
    if (lastPoint === undefined) return;
    // console.log("pose viewer point changed to", lastPoint);

    const np = [...points];
    const latestPoint = np.shift();
    if (
      latestPoint?.x !== undefined &&
      latestPoint?.y !== undefined &&
      lastPoint.position !== undefined
    ) {
      latestPoint.x = lastPoint.position.x;
      latestPoint.y = lastPoint.position.y;
      np.push(latestPoint);
    }
    setPoints(np);
  }, [lastPoint]);

  return (
    <Container interactive={true}>
      <PointsView points={points} />
    </Container>
  );
}
