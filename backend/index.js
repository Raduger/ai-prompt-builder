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
