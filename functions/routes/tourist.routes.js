// functions/routes/tourist.routes.js
import express from "express";
import mockAuthMiddleware from "../middleware/mockAuth.middleware.js";
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

router.use(mockAuthMiddleware);
router.use(checkTouristRole);

router.get('/profile', getTouristProfile);
router.put('/profile', updateTouristProfile);

export default router;