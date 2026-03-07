import express from "express";
import {
  getAllPlaces,
  getPlaceById,
  getNearbyPlaces
} from "../controllers/placeController.js";

const router = express.Router();

// Routes
router.get("/", getAllPlaces);
router.get("/nearby", getNearbyPlaces);
router.get("/:id", getPlaceById);

export default router;