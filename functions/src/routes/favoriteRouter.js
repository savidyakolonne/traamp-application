import { Router } from "express";
import {
  setFavorite,
  clearFavorite,
  getFavorites,
  getFavoritesPackages,
} from "./../controllers/favoriteController.js";

const favoriteRouter = Router();

favoriteRouter.post("/set-favorite", setFavorite);
favoriteRouter.delete("/clear-favorite", clearFavorite);
favoriteRouter.post("/get-favorites", getFavorites);
favoriteRouter.post("/get-favorites-packages", getFavoritesPackages);

export default favoriteRouter;
