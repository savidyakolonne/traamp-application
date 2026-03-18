import express from "express";
import multer from "multer";

import {
  getAllGuides,
  getGuideById,
  getGuideProfile,
  updateGuideProfile,
  submitGuideVerification,
} from "../controllers/guideController.js";
import firebaseAdmin from "../config/firebaseAdmin.js";

const { db } = firebaseAdmin;

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

const checkGuideRole = async (req, res, next) => {
  try {
    const userDoc = await db.collection("users").doc(req.user.uid).get();

    if (!userDoc.exists || userDoc.data().type !== "guide") {
      return res.status(403).json({
        success: false,
        message: "Guide role required",
      });
    }

    next();
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Failed to verify guide role",
    });
  }
};

// Public routes
router.get("/", getAllGuides);

// Protected routes
router.get("/profile", firebaseAdmin.firebaseAuth, checkGuideRole, getGuideProfile);
router.put("/profile", firebaseAdmin.firebaseAuth, checkGuideRole, updateGuideProfile);

router.post(
  "/verification/submit",
  firebaseAdmin.firebaseAuth,
  checkGuideRole,
  upload.fields([
    { name: "nicDocument", maxCount: 1 },
    { name: "sltdaCertificate", maxCount: 1 },
  ]),
  submitGuideVerification
);

// Keep last
router.get("/:uid", getGuideById);

export default router;