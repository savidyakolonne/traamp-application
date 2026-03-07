import express from "express";
import { getAllActivities, getActivityById } from "../controllers/activityController.js";

const router = express.Router();

// Routes
router.get("/", getAllActivities);
router.get("/:id", getActivityById);

export default router;