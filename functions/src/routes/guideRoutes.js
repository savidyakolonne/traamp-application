import express from 'express' ; 
import { getAllGuides, getGuideById } from '../controllers/guideController.js';
import {getGuideProfile,updateGuideProfile} from "../controllers/guideController.js";
import mockAuthMiddleware from "../middleware/mockAuth.middleware.js";

const router = express.Router();

router.get("/", getAllGuides) ; 
router.get("/:id", getGuideById) ; 

// GUIDE ROUTES
const checkGuideRole = (req, res, next) => {
  if (req.user.role !== "guide") {
    return res.status(403).json({
      success: false,
      message: "Guide role required"
    });
  }
  next();
};

router.use(mockAuthMiddleware);
router.use(checkGuideRole);

router.get("/profile", getGuideProfile);
router.put("/profile", updateGuideProfile);

export default router ; 