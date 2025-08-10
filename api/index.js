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
import express from 'express';
import serverless from 'serverless-http';
import cors from 'cors';
import bodyParser from 'body-parser';

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello from Vercel backend!' });
});

export const handler = serverless(app);
