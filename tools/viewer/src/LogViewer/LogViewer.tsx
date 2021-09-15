import { useEffect, useState } from "react";
import { Log } from "../_schemas/log";

export default function LogViewer({ logs }: { logs: Log[] | undefined }) {
  return (
    <div className="log-viewer">
      {logs?.map((value) => (
        <p>
          {value.sender} : {value.message}
        </p>
      ))}
    </div>
  );
}
