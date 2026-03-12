import express from "express";
import { getDashboardStats ,getTouristStats, getAllTourists, getPendingVerificationRequests,  getVerificationRequestById, approveGuideVerification, rejectGuideVerification} from "../controllers/adminController.js";
import { getAllGuides} from "../controllers/guideController.js"
const router = express.Router();

// Dashboard stats
router.get("/dashboard-stats", getDashboardStats);

// Guide management
// router.get("/guides", getAllGuides);
router.get("/guides", getAllGuides)

// tousirt managment
router.get("/tourists", getAllTourists);
router.get("/tourists-stats", getTouristStats);

router.get("/verifications", getPendingVerificationRequests);
router.get("/verifications/:uid", getVerificationRequestById);
router.put("/verifications/:uid/approve", approveGuideVerification);
router.put("/verifications/:uid/reject", rejectGuideVerification);

export default router;