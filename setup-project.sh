#!/bin/bash

set -e

echo "Creating AI Prompt Builder project structure..."

mkdir -p api
mkdir -p src/components
mkdir -p public

echo "Writing package.json..."
cat > package.json << 'EOF'
{
  "name": "ai-prompt-builder",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev:backend": "vercel dev",
    "dev:frontend": "vite",
    "dev:ngrok": "ngrok http 3000",
    "dev": "concurrently -k -n backend,frontend,ngrok -c blue,green,yellow \"npm run dev:backend\" \"npm run dev:frontend\" \"npm run dev:ngrok\"",
    "build": "vite build",
    "start": "node api/index.js"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.0.0",
    "body-parser": "^1.20.2",
    "cors": "^2.8.5",
    "express": "^4.18.2",
    "i18next": "^22.4.9",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-i18next": "^12.3.1",
    "serverless-http": "^3.0.0",
    "stripe": "^12.15.0"
  },
  "devDependencies": {
    "concurrently": "^8.2.0",
    "vite": "^4.4.9"
  }
}
EOF

echo "Writing vercel.json..."
cat > vercel.json << 'EOF'
{
  "version": 2,
  "builds": [
    { "src": "api/index.js", "use": "@vercel/node" },
    { "src": "src/index.jsx", "use": "@vercel/static-build" }
  ],
  "routes": [
    { "src": "/api/(.*)", "dest": "api/index.js" },
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
EOF

echo "Writing .gitignore..."
cat > .gitignore << 'EOF'
node_modules/
.env
dist/
.vscode/
.DS_Store
EOF

echo "Writing supabase_migrations.sql..."
cat > supabase_migrations.sql << 'EOF'
create table analytics_events (
  id serial primary key,
  user_id uuid references auth.users(id),
  event_type text not null,
  event_data jsonb,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Add tables for subscriptions, prompt_history, user roles, etc. here
EOF

echo "Writing api/index.js..."
cat > api/index.js << 'EOF'
import express from "express";
import serverless from "serverless-http";
import bodyParser from "body-parser";
import Stripe from "stripe";
import cors from "cors";
import { createClient } from "@supabase/supabase-js";

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.raw({ type: 'application/json' }));

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

const adminOnly = async (req, res, next) => {
  const authHeader = req.headers.authorization || "";
  if (authHeader !== "admin-token") return res.status(403).send("Forbidden");
  next();
};

app.get("/api/hello", (req, res) => res.json({ message: "Hello from backend!" }));

app.post("/api/analytics", async (req, res) => {
  const { user_id, event_type, event_data } = req.body;
  const { error } = await supabase.from("analytics_events").insert({ user_id, event_type, event_data });
  if (error) return res.status(500).send(error.message);
  res.json({ success: true });
});

app.get("/api/admin/users", adminOnly, async (req, res) => {
  const { data, error } = await supabase.from("users").select("*");
  if (error) return res.status(500).send(error.message);
  res.json(data);
});

export const handler = serverless(app);
export default handler;
EOF

echo "Writing src/i18n.js..."
cat > src/i18n.js << 'EOF'
import i18n from "i18next";
import { initReactI18next } from "react-i18next";

const resources = {
  en: { translation: { welcome: "Welcome", subscribe: "Subscribe" } },
  fr: { translation: { welcome: "Bienvenue", subscribe: "S'abonner" } },
  de: { translation: { welcome: "Willkommen", subscribe: "Abonnieren" } }
};

i18n.use(initReactI18next).init({
  resources,
  lng: "en",
  fallbackLng: "en",
  interpolation: { escapeValue: false }
});

export default i18n;
EOF

echo "Writing src/App.jsx..."
cat > src/App.jsx << 'EOF'
import React, { useState } from "react";
import { useTranslation } from "react-i18next";
import AdminDashboard from "./components/AdminDashboard";
import PromptBuilder from "./components/PromptBuilder";

export default function App() {
  const { t, i18n } = useTranslation();
  const [isAdmin, setIsAdmin] = useState(false);

  return (
    <div>
      <header>
        <h1>{t("welcome")}</h1>
        <select onChange={e => i18n.changeLanguage(e.target.value)} defaultValue="en">
          <option value="en">English</option>
          <option value="fr">Français</option>
          <option value="de">Deutsch</option>
        </select>
        <button onClick={() => setIsAdmin(!isAdmin)}>
          {isAdmin ? "User View" : "Admin View"}
        </button>
      </header>
      <main>{isAdmin ? <AdminDashboard /> : <PromptBuilder />}</main>
    </div>
  );
}
EOF

echo "Writing src/components/AdminDashboard.jsx..."
cat > src/components/AdminDashboard.jsx << 'EOF'
import React, { useEffect, useState } from "react";

export default function AdminDashboard() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    fetch("/api/admin/users", { headers: { Authorization: "admin-token" } })
      .then(res => res.json())
      .then(setUsers)
      .catch(console.error);
  }, []);

  return (
    <div>
      <h2>Admin Dashboard</h2>
      <ul>
        {users.map(u => (
          <li key={u.id}>{u.email} - {u.subscription_status}</li>
        ))}
      </ul>
    </div>
  );
}
EOF

echo "Writing src/components/PromptBuilder.jsx..."
cat > src/components/PromptBuilder.jsx << 'EOF'
import React from "react";

export default function PromptBuilder() {
  return (
    <div>
      <h2>Prompt Builder</h2>
      <p>Build and generate your AI prompts here.</p>
      {/* Add prompt input, generation UI, history, etc. */}
    </div>
  );
}
EOF

echo "Writing src/index.jsx..."
cat > src/index.jsx << 'EOF'
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./i18n";

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<App />);
EOF

echo "Writing public/index.html..."
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>AI Prompt Builder</title>
</head>
<body>
  <div id="root"></div>
  <script type="module" src="/src/index.jsx"></script>
</body>
</html>
EOF

echo "Setup complete! Run 'npm install' to install dependencies."
