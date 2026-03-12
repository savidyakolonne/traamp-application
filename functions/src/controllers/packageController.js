import admin from "firebase-admin";
import firebaseAdmin from "../config/firebaseAdmin.js";

const { bucket, db } = firebaseAdmin;

export const addPackage = async (req, res) => {
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

    // setup a notification
    const notificationDocRef = db.collection("notifications").doc();
    console.log("notificationDocRef: ", notificationDocRef);
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "package-added",
      packageTitle,
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
};

export const getAllPackages = async (_, res) => {
  try {
    const snapshot = await db.collection("guide_packages").get();
    const allPackages = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    // Shuffle and take up to 50
    const shuffled = allPackages.sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, 50);

    console.log(selected);
    res.status(200).json({
      msg: "Successfully retrieved data",
      packages: selected,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: error,
    });
  }
};

export const getPackageByUserId = async (req, res) => {
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
};

export const deletePackage = async (req, res) => {
  const { packageId, coverImage, images, uid, packageTitle } = req.body;
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

    const id = db.collection("guide_packages").doc(packageId).get();

    // deleting the package
    await db.collection("guide_packages").doc(packageId).delete();
    console.log("Successfully deleted the package.");

    // setup a notification
    const notificationDocRef = db.collection("notifications").doc();
    console.log("notificationDocRef: ", notificationDocRef);
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "package-removed",
      packageTitle,
    });

    res.status(200).json({
      msg: "Successfully deleted the package.",
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: error,
    });
  }
};
