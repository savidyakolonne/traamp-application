import express from "express";
import cors from "cors";
import placeRouter from "./routes/place.routes.js";
import activityRouter from "./routes/activity.routes.js";

const app = express();

// ✅ CORS for Flutter Web (Chrome)
app.use(cors({ origin: true }));

app.use(express.json());

app.get("/", (req, res) => res.send("Traamp Backend is runninggggggg!!!"));

app.use("/api/place", placeRouter);
app.use("/api/activity", activityRouter);

export default app;
