import express from 'express';
import { 
  saveGuide, 
  removeSavedGuide, 
  checkIfGuideSaved, 
  getSavedGuides,
  getSavedGuidesCount 
} from '../controllers/savedGuidesController.js';

const router = express.Router();

// Save a guide to favorites
router.post('/save', saveGuide);

// Remove a saved guide
router.post('/remove', removeSavedGuide);

// Check if a guide is saved
router.get('/check', checkIfGuideSaved);

// Get all saved guides for a tourist
router.get('/:touristUid', getSavedGuides);

// Get saved guides count for a tourist
router.get('/:touristUid/count', getSavedGuidesCount);

export default router;