import express from 'express' ; 
import { getAllGuides, getGuideById } from '../controllers/guideController.js';

const router = express.Router();

router.get("/", getAllGuides) ; 
router.get("/:id", getGuideById) ; 

export default router ; 