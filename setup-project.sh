#!/bin/bash
set -e

# Replace this with your actual repo URL
REPO_URL="https://github.com/Raduger/ai-prompt-builder.git"

echo "Step 1: Create project structure and files..."

mkdir -p backend frontend/src

# Root package.json
cat > package.json <<EOF
{
  "name": "my-app",
  "private": true,
  "workspaces": ["frontend", "backend"]
}
EOF

# vercel.json
cat > vercel.json <<EOF
{
  "version": 2,
  "builds": [
    { "src": "backend/index.js", "use": "@vercel/node" },
    { "src": "frontend/package.json", "use": "@vercel/static-build", "config": { "distDir": "dist" } }
  ],
  "routes": [
    { "src": "/api/(.*)", "dest": "/backend/index.js" },
    { "src": "/(.*)", "dest": "/frontend/\$1" }
  ]
}
EOF

# backend/package.json
mkdir -p backend
cat > backend/package.json <<EOF
{
  "name": "backend",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "body-parser": "^1.20.2"
  }
}
EOF

# backend/index.js
cat > backend/index.js <<EOF
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();

app.use(cors());
app.use(bodyParser.json());

app.get("/api/hello", (req, res) => {
  res.json({ message: "Hello from backend API!" });
});

module.exports = app;
EOF

# frontend/package.json
mkdir -p frontend
cat > frontend/package.json <<EOF
{
  "name": "frontend",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^4.4.9",
    "@vitejs/plugin-react": "^4.0.0"
  }
}
EOF

# frontend/vite.config.js
cat > frontend/vite.config.js <<EOF
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      "/api": "http://localhost:3000"
    }
  }
});
EOF

# frontend/index.html
cat > frontend/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Maximal Frontend</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# frontend/src/main.jsx
mkdir -p frontend/src
cat > frontend/src/main.jsx <<EOF
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

# frontend/src/App.jsx
cat > frontend/src/App.jsx <<EOF
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
EOF

echo "Step 2: Initialize git and push to repo..."

# Init git if needed
if [ ! -d .git ]; then
  git init
  echo "Git initialized."
fi

# Add remote if not set
if ! git remote | grep -q origin; then
  git remote add origin $REPO_URL
  echo "Remote origin set to $REPO_URL"
fi

git add .
git commit -m "Setup Vercel-ready frontend + backend monorepo"
git branch -M main
git push -u origin main

echo "Setup complete! Your project is pushed to GitHub."
echo "Next: Connect your GitHub repo to Vercel and deploy."
