import express from "express";
import cors from "cors";
import guideRoutes from "./routes/guideRoutes.js";
import activityRoutes from "./routes/activityRoutes.js";
import placeRoutes from "./routes/placeRoutes.js";
import packageRouter from "./routes/packageRouter.js";
import galleryRouter from "./routes/galleryRouter.js";
import userRoutes from "./routes/userRoutes.js";
import newsRoutes from "./routes/newsRoutes.js";
import adminRoutes from "./routes/adminRoutes.js";

const app = express();

app.use(cors({ origin: true }));

app.use(express.json());

app.get("/", (_, res) => res.send("Server is running..."));

app.use("/api/places", placeRoutes);
app.use("/api/users", userRoutes);
app.use("/api/activity", activityRoutes);
app.use("/api/guidePackage", packageRouter);
app.use("/api/gallery", galleryRouter);
app.use("/api/news", newsRoutes);

//guides
app.use("/api/guides", guideRoutes);
app.use("/api/admin", adminRoutes);

export default app;
