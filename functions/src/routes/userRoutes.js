import { Router } from "express";
import multer from "multer";

import {
  registerTourist,
  registerGuide,
  loginWithEmail,
  getUserData,
  updateGuideAvailability,
  logoutUser,
  updateTouristProfile,
  updateGuideProfile
} from "../controllers/userController.js";

const userRouter = Router();

const upload = multer({ storage: multer.memoryStorage() });

userRouter.post("/register-tourist", registerTourist);

userRouter.post(
  "/register-guide",
  upload.single("certificate"),
  registerGuide
);

userRouter.post("/loginWithEmail", loginWithEmail);

userRouter.post("/get-user-data", getUserData);

userRouter.put("/update-tourist-profile", updateTouristProfile);

userRouter.put("/update-guide-profile", updateGuideProfile);

userRouter.put("/update-guide-availability", updateGuideAvailability);

userRouter.post("/user-logout", logoutUser);

export default userRouter;