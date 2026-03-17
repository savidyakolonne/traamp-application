import express from 'express' ; 
import multer from "multer" ; 

import { getAllGuides, getGuideById } from '../controllers/guideController.js';
import {getGuideProfile,updateGuideProfile, submitGuideVerification} from "../controllers/guideController.js";
import admin from "../config/firebaseAdmin.js";

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

router.get("/", getAllGuides) ; 
router.get("/:uid", getGuideById); 

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

router.use(admin.firebaseAuth);
router.use(checkGuideRole);

router.get("/profile", getGuideProfile);
router.put("/profile", updateGuideProfile);

router.post(
  "/submit-verification",
  upload.fields([
    { name: "certificate", maxCount: 1 },
    { name: "nicDocument", maxCount: 1 },
  ]),
  submitGuideVerification
);

export default router ; 