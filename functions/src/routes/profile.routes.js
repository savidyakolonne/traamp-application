import express from "express";
import firebase from "../config/firebase.js";

const router = express.Router();

// GET /api/profile - Get user profile (protected)
router.get("/", firebase.firebaseAuth, (req, res) => {
  try {
    // Mock profile data based on role
    const mockProfiles = {
      guide: {
        id: req.user.uid,
        name: "Kasun Perera",
        email: "kasun@example.com",
        role: "guide",
        bio: "Passionate about sharing the hidden gems of Sri Lanka.",
        rating: 4.9,
        totalTours: 250,
        experience: "8 Years"
      },
      tourist: {
        id: req.user.uid,
        name: "Alex Chen",
        email: "alex@example.com",
        role: "tourist",
        bio: "Travel enthusiast exploring Sri Lanka",
        memberSince: "2023",
        savedGuides: 3
      }
    };

    const profile = mockProfiles[req.user.role];

    res.json({
      success: true,
      message: "Profile fetched successfully",
      data: profile
    });

  } catch (error) {
    console.error('Profile fetch error:', error);
    res.status(500).json({
      success: false,
      error: "Server Error",
      message: "Failed to fetch profile"
    });
  }
});

export default router;