import firebaseAdmin from "../config/firebaseAdmin.js";
import admin from "firebase-admin";

const { db } = firebaseAdmin;

export const setFavorite = async (req, res) => {
  try {
    const { uid, packageId } = req.body;

    const favoriteRef = await db.collection("favorites").doc();
    await favoriteRef.set({
      favoriteId: favoriteRef.id,
      uid,
      packageId,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).json({
      msg: "successfully added to favorite.",
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: "Error while adding to favorite.",
    });
  }
};

export const clearFavorite = async (req, res) => {
  try {
    const { favoriteId } = req.body;

    if (!favoriteId) {
      return res.status(400).json({ msg: "favoriteId is required" });
    }

    await db.collection("favorites").doc(favoriteId).delete();

    res.status(200).json({
      msg: "Data cleared successfully",
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      msg: "Error while deleting data",
    });
  }
};

export const getFavorites = async (req, res) => {
  try {
    const { uid } = req.body;

    const favorite_ref = db.collection("favorites");
    const favoriteQuery = favorite_ref.where("uid", "==", uid);

    const snapshot = await favoriteQuery.get();
    const favorites = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    console.log(favorites);

    res.status(200).json({
      msg: "Successfully retrieved data",
      favorites: favorites,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      msg: "Error while retrieved data",
    });
  }
};

export const getFavoritesPackages = async (req, res) => {
  try {
    const { favoriteList } = req.body;
    const favoritePackageList = [];
    // iterate through the array to get packageId
    for (let i = 0; i < favoriteList.length; i++) {
      const packageRef = db
        .collection("guide_packages")
        .doc(favoriteList[i]["packageId"]);

      const doc = await packageRef.get();
      if (doc.exists) {
        favoritePackageList.push(doc.data());
      } else {
        console.log("No such document exists.");
      }
    }
    console.log("favoritePackageList: ", favoritePackageList);

    res.status(200).json({
      msg: "successfully retrieved all packages.",
      favoritePackageList: favoritePackageList,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      msg: "Error while retrieving packages.",
    });
  }
};
