import express from "express";
import admin from "../config/firebaseAdmin.js";
import {
  getTouristProfile,
  updateTouristProfile
} from "../controllers/tourist.controller.js";

const router = express.Router();

const checkTouristRole = (req, res, next) => {
  if (req.user.role !== 'tourist') {
    return res.status(403).json({
      success: false,
      error: 'Forbidden',
      message: 'Access denied. Tourist role required.'
    });
  }
  next();
};

router.use(admin.firebaseAuth);
router.use(checkTouristRole);

router.get('/profile', getTouristProfile);
router.put('/profile', updateTouristProfile);

export default router;