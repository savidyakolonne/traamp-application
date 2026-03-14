import express from "express";
import admin from "../config/firebaseAdmin.js";
import {
  saveGuide,
  removeSavedGuide,
  getSavedGuides,
} from "../controllers/savedGuidesController.js";

const router = express.Router();

// Apply auth middleware to all saved guides routes
router.use(admin.firebaseAuth);

// GET /api/saved-guides - Get all saved guides for current user
router.get("/", getSavedGuides);

// POST /api/saved-guides - Save a guide
router.post("/", saveGuide);

// DELETE /api/saved-guides/:guideId - Remove a saved guide
router.delete("/:guideId", removeSavedGuide);

export default router;