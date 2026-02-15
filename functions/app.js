import express from "express";
import cors from "cors";
import placesRouter from "./routes/places.routes.js";
import activityRouter from "./routes/activity.routes.js";
import userRouter from "./routes/users.mjs";

const app = express();

app.use(cors({ origin: true }));

app.use(express.json());

app.get("/", (_, res) => res.send("Server is running..."));

app.use("/api/places", placesRouter);
app.use("/api/users", userRouter);
app.use("/api/activity", activityRouter);

export default app;
