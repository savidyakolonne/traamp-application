import { Router } from "express";
import firebaseAdmin from "../firebaseAdmin.js";

const packageRouter = Router();
const { auth, db } = firebaseAdmin;

packageRouter.post("/add-package", async (req, res) => {
  try {
    const createdAt = new Date();
    const {
      uid,
      packageTitle,
      category,
      shortDescription,
      description,
      location,
      languages,
      duration,
      availableDays,
      season,
      price,
      minGuests,
      maxGuests,
      havePrivateTourOption,
      haveGroupDiscounts,
      startLocation,
      endLocation,
      stops,
      packageInclude,
      packageExclude,
    } = req.body;

    // generate Id for the document
    const docRef = await db.collection("guide_packages").doc();

    await docRef.set({
      packageId: docRef.id,
      uid,
      packageTitle,
      category,
      shortDescription,
      description,
      location,
      languages,
      duration,
      availableDays,
      season,
      price,
      minGuests,
      maxGuests,
      havePrivateTourOption,
      haveGroupDiscounts,
      startLocation,
      endLocation,
      stops,
      packageInclude,
      packageExclude,
      createdAt,
    });

    res.status(201).json({
      msg: "Guide package created successfully.",
    });
  } catch (error) {
    console.log(error);
    res.status(400).json({
      msg: error.message,
    });
  }
});

packageRouter.post("/get-package-by-user-id", async (req, res) => {
  try {
    const { uid } = req.body;

    const guide_package_ref = db.collection("guide_packages");
    const packageQuery = guide_package_ref.where("uid", "==", uid);

    const snapshot = await packageQuery.get();
    const packages = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    console.log(packages);
    res.status(200).json({
      msg: "Successfully retrieved data",
      packages: packages,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: error,
    });
  }
});

packageRouter.delete("/delete-package", async (req, res) => {
  const { packageId } = req.body;
  try {
    await db.collection("guide_packages").doc(packageId).delete();
    console.log("Successfully deleted the package.");
    res.status(200).json({
      msg: "Successfully deleted the package.",
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: error,
    });
  }
});

export default packageRouter;
