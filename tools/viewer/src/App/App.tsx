import { Stage } from "@inlet/react-pixi";
import {
  connect,
  Msg,
  NatsConnection,
  NatsError,
} from "../../node_modules/nats.ws/lib/src/mod.js";
import { useEffect, useState } from "react";
import PoseViewer from "../PoseViewer/PoseViewer";
import "./App.css";
import { Position } from "../_schemas/position";
import MovementController from "../MovementController/MovementController";

function App() {
  const [nc, setConnection] = useState<NatsConnection | undefined>(undefined);
  const [lastError, setError] = useState("");

  useEffect(() => {
    if (nc === undefined) {
      connect({
        servers: ["nats://192.168.50.165:4223", "ws://localhost:4223"],
      })
        .then((nc) => {
          setConnection(nc);
          // console.log("connected properly");
          nc.subscribe("position", { callback: positionCallback });
        })
        .catch((err) => setError(err));
    }
  });

  // we update newPoint with the latest point we received by nats
  const [newPoint, setNewPoint] = useState<Position | undefined>(undefined);
  const positionCallback = (_err: NatsError | null, msg: Msg) => {
    setNewPoint(undefined);
    const newlyPoint = Position.decode(msg.data);
    setNewPoint(newlyPoint);
    console.log(newlyPoint.position);
  };

  const Views = ["PoseViewer", "VideoViewer", "MovementController"];

  const [selectedView, setSelectedView] = useState<string | undefined>(
    "PoseViewer"
  );

  return (
    <div className="App">
      {nc ? <p>Connected successfully</p> : <p>{lastError.toString()}</p>}
      <select
        value={selectedView}
        onChange={(event) => setSelectedView(event.target.value)}
      >
        {Object.values(Views).map((value) => (
          <option value={value}>{value}</option>
        ))}
      </select>
      {selectedView == "PoseViewer" ? (
        <Stage options={{ backgroundColor: 0xeef1f5 }}>
          <PoseViewer lastPoint={newPoint} />
        </Stage>
      ) : (
        <></>
      )}
      {selectedView == "VideoViewer" ? <></> : <></>}
      {selectedView == "MovementController" ? (
        <MovementController nc={nc} />
      ) : (
        <></>
      )}
    </div>
  );
}

export default App;
