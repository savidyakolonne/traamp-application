import express from "express";
import { getDashboardStats ,getTouristStats, getAllTourists} from "../controllers/adminController.js";
import { getAllGuides} from "../controllers/guideController.js"
import {
  getPendingVerifications,
  getVerificationById,
  approveVerification,
  rejectVerification,
} from "../controllers/adminVerificationController.js";
const router = express.Router();

// Dashboard stats
router.get("/dashboard-stats", getDashboardStats);

// Guide management
// router.get("/guides", getAllGuides);
router.get("/guides", getAllGuides)

// tousirt managment
router.get("/tourists", getAllTourists);
router.get("/tourists-stats", getTouristStats);

router.get("/verifications", getPendingVerifications);
router.get("/verifications/:id", getVerificationById);
router.put("/verifications/:id/approve", approveVerification);
router.put("/verifications/:id/reject", rejectVerification);

export default router;