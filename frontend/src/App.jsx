import React, { useEffect, useState } from "react";

export default function App() {
  const [message, setMessage] = useState("");

  useEffect(() => {
    fetch("/api/hello")
      .then((res) => res.json())
      .then((data) => setMessage(data.message))
      .catch(console.error);
  }, []);

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial, sans-serif" }}>
      <h1>Maximal Frontend + Backend</h1>
      <p>Backend says: {message}</p>
    </div>
  );
}
