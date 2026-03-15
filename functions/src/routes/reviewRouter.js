import { Router } from "express";
import { addReviews } from "./../controllers/reviewController.js";

const reviewRouter = Router();

reviewRouter.post("/add-reviews", addReviews);

export default reviewRouter;
