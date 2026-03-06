import express from "express";
import mockAuthMiddleware from "../middleware/mockAuth.middleware.js";
import {
  getGuideProfile,
  updateGuideProfile
} from "../controllers/guide.controller.js";

const router = express.Router();

const checkGuideRole = (req, res, next) => {
  if (req.user.role !== 'guide') {
    return res.status(403).json({
      success: false,
      error: 'Forbidden',
      message: 'Access denied. Guide role required.'
    });
  }
  next();
};

router.use(mockAuthMiddleware);
router.use(checkGuideRole);

router.get('/profile', getGuideProfile);
router.put('/profile', updateGuideProfile);

export default router;