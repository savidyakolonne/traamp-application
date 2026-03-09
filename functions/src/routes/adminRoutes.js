import express from "express";
import { getDashboardStats, getAllGuides ,getTouristStats, getAllTourists} from "../controllers/adminController.js";

const router = express.Router();

// Dashboard stats
router.get("/dashboard-stats", getDashboardStats);

// Guide management
router.get("/guides", getAllGuides);
router.get("/tourists", getAllTourists);
router.get("/tourists-stats", getTouristStats);

export default router;