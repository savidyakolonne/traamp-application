import { Router } from "express";
import {
  addReviews,
  getReviewsById,
} from "./../controllers/reviewController.js";

const reviewRouter = Router();

reviewRouter.post("/add-reviews", addReviews);
reviewRouter.post("/get-reviews-by-id", getReviewsById);

export default reviewRouter;
