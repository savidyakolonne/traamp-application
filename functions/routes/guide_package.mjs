import { Router } from "express";
import firebaseAdmin from "../firebaseAdmin.js";
import multer from "multer";

const packageRouter = Router();
const { bucket, db } = firebaseAdmin;

// configure multer
const upload = multer({ storage: multer.memoryStorage() });

packageRouter.post(
  "/add-package",
  upload.fields([
    { name: "coverImage", maxCount: 1 },
    { name: "images", maxCount: 50 },
  ]),
  async (req, res) => {
    try {
      const createdAt = new Date();
      const {
        uid,
        packageTitle,
        category,
        shortDescription,
        description,
        location,
        duration,
        season,
        startLocation,
        endLocation,
      } = req.body;

      // Convert numeric fields
      const price = Number(req.body.price);
      const minGuests = Number(req.body.minGuests);
      const maxGuests = Number(req.body.maxGuests);

      // Convert boolean fields
      const havePrivateTourOption = req.body.havePrivateTourOption === "true";
      const haveGroupDiscounts = req.body.haveGroupDiscounts === "true";

      // Convert arrays (if they were sent as JSON strings)
      const languages = JSON.parse(req.body.languages || "[]");
      const availableDays = JSON.parse(req.body.availableDays || "[]");
      const stops = JSON.parse(req.body.stops || "[]");
      const packageInclude = JSON.parse(req.body.packageInclude || "[]");
      const packageExclude = JSON.parse(req.body.packageExclude || "[]");

      // Upload cover image
      let coverImageUrl = null;
      if (req.files.coverImage) {
        const file = req.files.coverImage[0];
        const blob = bucket.file(
          `guide_package_media/cover_${Date.now()}_${file.originalname}`,
        );
        await blob.save(file.buffer, { contentType: file.mimetype });
        coverImageUrl = await blob.getSignedUrl({
          action: "read",
          expires: "03-01-2030",
        });
        coverImageUrl = coverImageUrl[0];
      }

      // Upload multiple images
      let imageUrls = [];
      if (req.files.images) {
        for (const file of req.files.images) {
          const blob = bucket.file(
            `guide_package_media/image_${Date.now()}_${file.originalname}`,
          );
          await blob.save(file.buffer, { contentType: file.mimetype });
          const url = await blob.getSignedUrl({
            action: "read",
            expires: "03-01-2030",
          });
          imageUrls.push(url[0]);
        }
      }

      // generate Id for the document
      const docRef = db.collection("guide_packages").doc();

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
        coverImage: coverImageUrl,
        images: imageUrls,
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
  },
);

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
  const { packageId, coverImage, images } = req.body;
  try {
    // Merge coverImage into images array safely
    let allImages = [];
    if (Array.isArray(images)) {
      allImages = images;
    } else if (typeof images === "string") {
      try {
        allImages = JSON.parse(images);
      } catch {
        allImages = [images];
      }
    }
    if (coverImage) {
      allImages.push(coverImage);
    }

    // Delete each image from Firebase Storage
    for (const img of allImages) {
      try {
        const withoutQuery = img.split("?")[0];
        let storagePath;
        if (withoutQuery.includes("/o/")) {
          storagePath = withoutQuery.split("/o/")[1];
          storagePath = decodeURIComponent(storagePath);
        } else {
          const parts = withoutQuery.split("/");
          storagePath = parts
            .slice(parts.indexOf("guide_package_media"))
            .join("/");
        }

        console.log("Deleting file:", storagePath);
        const file = bucket.file(storagePath);
        await file.delete();
      } catch (err) {
        console.log("Error deleting image:", err.message);
      }
    }

    // deleting the package
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
