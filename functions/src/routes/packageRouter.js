import { Router } from "express";
import multer from "multer";
import {
  addPackage,
  getAllPackages,
  getPackageByUserId,
  deletePackage,
} from "../controllers/packageController.js";

const packageRouter = Router();

// configure multer
const upload = multer({ storage: multer.memoryStorage() });

packageRouter.post(
  "/add-package",
  upload.fields([
    { name: "coverImage", maxCount: 1 },
    { name: "images", maxCount: 50 },
  ]),
  addPackage,
);

packageRouter.get("/get-all-packages", getAllPackages);

packageRouter.post("/get-package-by-user-id", getPackageByUserId);

packageRouter.delete("/delete-package", deletePackage);

export default packageRouter;
