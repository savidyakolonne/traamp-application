import express from "express";
import cors from "cors";
import placesRouter from "./routes/places.routes.js";
import placesRouter from "./routes/activities.routes.js";

const app = express();

// ✅ CORS for Flutter Web (Chrome)
app.use(cors({ origin: true }));

app.use(express.json());

app.get("/", (req, res) => res.send("Traamp Backend is runninggggggg!!!"));

app.use("/api/places", placesRouter);
app.use("/api/activities", placesRouter);

export default app;
