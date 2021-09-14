import { useEffect, useState } from "react";
import {
  connect,
  Msg,
  NatsConnection,
  NatsError,
} from "../../node_modules/nats.ws/lib/src/mod.js";
import { MovementRequest, MovementResponse } from "../_schemas/movement";

export default function MovementController({
  nc,
}: {
  nc: NatsConnection | undefined;
}) {
  const [speedValue, setSpeedValue] = useState(0.0);
  const [steerValue, setSteerValue] = useState(0.0);

  useEffect(() => {
    nc?.request(
      "movement_controller",
      MovementRequest.encode({
        speedNull: false,
        speedValue: speedValue / 100.0,
        steeringNull: false,
        steeringValue: steerValue / 100.0,
      }).finish()
    )
      .then((_) => {})
      .catch((err) => console.log(err));
    console.log("sent", speedValue / 100.0, steerValue / 100.0);
  }, [speedValue, steerValue]);

  return (
    <div className="movement-controller">
      <input
        className="vertical-input"
        type="range"
        min="-100"
        max="100"
        value={speedValue}
        onChange={(event) => setSpeedValue(parseInt(event.target.value))}
      />
      <p>Speed value: {speedValue / 100.0}</p>
      <input
        type="range"
        min="-100"
        max="100"
        value={steerValue}
        onChange={(event) => setSteerValue(parseInt(event.target.value))}
      />
      <p>Steer value: {steerValue / 100.0}</p>
    </div>
  );
}
