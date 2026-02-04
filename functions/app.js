// functions/app.js
import express from "express";
import cors from "cors";
import firebaseAdmin from "./firebaseAdmin.js";
import profileRouter from "./routes/profile.routes.js";

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Request logging
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.path}`);
  next();
});

// Attach Firebase to request
app.use((req, res, next) => {
  req.auth = firebaseAdmin.auth;
  req.db = firebaseAdmin.db;
  next();
});

// Routes
app.use("/api/profile", profileRouter);

// Default route
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Backend is running!",
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: "Not Found",
    message: `Cannot ${req.method} ${req.path}`
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server Error:', err);
  res.status(500).json({
    success: false,
    error: "Internal Server Error"
  });
});

export default app;