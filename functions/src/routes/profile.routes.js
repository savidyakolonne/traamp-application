import express from "express";
import firebase from "../config/firebase.js";
import { getTouristProfile } from "../controllers/tourist.controller.js";
import { getGuideProfile } from "../controllers/guideController.js";

const router = express.Router();

// GET /api/profile - Get user profile (protected)
router.get("/", firebase.firebaseAuth, async (req, res) => {
  try {
    const uid = req.user.uid;

    // Fetch user from Firestore to check type
    const userDoc = await firebase.db.collection("users").doc(uid).get();

    if (!userDoc.exists) {
      return res.status(404).json({
        success: false,
        error: "Not Found",
        message: "User not found in database"
      });
    }

    const userType = userDoc.data().type;

    // Route to correct controller based on type
    if (userType === "guide") {
      return getGuideProfile(req, res);
    }

    if (userType === "tourist") {
      return getTouristProfile(req, res);
    }

    // Unknown type
    return res.status(400).json({
      success: false,
      error: "Bad Request",
      message: `Unknown user type: ${userType}`
    });

  } catch (error) {
    console.error("Profile fetch error:", error);
    res.status(500).json({
      success: false,
      error: "Server Error",
      message: "Failed to fetch profile"
    });
  }
});

export default router;