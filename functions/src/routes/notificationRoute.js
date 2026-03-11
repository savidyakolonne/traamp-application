import { Router } from "express";
import {
  getNotifications,
  deleteNotifications,
  updateNotifications,
  clearNotifications,
} from "./../controllers/notificationController.js";

const notificationRouter = Router();

notificationRouter.post("/getNotifications", getNotifications);
notificationRouter.delete("/deleteNotifications", deleteNotifications);
notificationRouter.put("/updateNotifications", updateNotifications);
notificationRouter.delete("/clearNotifications", clearNotifications);

export default notificationRouter;
