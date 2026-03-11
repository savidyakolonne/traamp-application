import { Router } from "express";
import multer from "multer";
import {
  getGalleryByUid,
  addToGallery,
  deleteGallery,
} from "../controllers/galleryController.js";

const galleryRouter = Router();

// configure multer
const upload = multer({ storage: multer.memoryStorage() });

galleryRouter.post("/get-gallery-by-uid", getGalleryByUid);

galleryRouter.post(
  "/add-to-gallery",
  upload.fields([{ name: "images", maxCount: 50 }]),
  addToGallery,
);

galleryRouter.delete("/delete-gallery", deleteGallery);

export default galleryRouter;
