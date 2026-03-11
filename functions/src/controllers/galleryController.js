import multer from "multer";
import firebaseAdmin from "../config/firebaseAdmin.js";
import admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";

const { bucket, db } = firebaseAdmin;

// configure multer
const upload = multer({ storage: multer.memoryStorage() });

export const getGalleryByUid = async (req, res) => {
  const { uid } = req.body;

  try {
    const gallery_ref = db.collection("gallery");
    const galleryQuery = gallery_ref.where("uid", "==", uid);

    const snapshot = await galleryQuery.get();
    const galleries = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));
    console.log(galleries);
    res.status(200).json({
      msg: "Successfully retrieved data",
      data: galleries,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: error,
    });
  }
};

export const addToGallery = async (req, res) => {
  try {
    const createdAt = new Date();
    const { uid } = req.body;

    console.log("Files received:", req.files);
    console.log("UID:", req.body.uid);

    // Upload multiple images
    let imageUrls = [];
    if (req.files && req.files.images) {
      for (const file of req.files.images) {
        const blob = bucket.file(
          `gallery/image_${Date.now()}_${file.originalname}`,
        );
        try {
          await blob.save(file.buffer, { contentType: file.mimetype });
        } catch (err) {
          console.error("Storage upload failed:", err);
        }
        const url = await blob.getSignedUrl({
          action: "read",
          expires: "03-01-2030",
        });
        imageUrls.push(url[0]);
      }
    }

    // generate Id for the document
    const docRef = db.collection("gallery").doc();
    console.log("Document written:", docRef.id);
    await docRef.set({
      galleryId: docRef.id,
      uid,
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
      type: "gallery-added",
    });

    res.status(201).json({
      msg: "Gallery added successfully.",
      images: imageUrls,
    });
  } catch (e) {
    console.error(e);
    res.status(400).json({
      msg: e.message,
    });
  }
};

export const deleteGallery = async (req, res) => {
  const { galleryId, image, uid } = req.body;

  try {
    try {
      const withoutQuery = image.split("?")[0];
      let storagePath;
      if (withoutQuery.includes("/o/")) {
        storagePath = withoutQuery.split("/o/")[1];
        storagePath = decodeURIComponent(storagePath);
      } else {
        const parts = withoutQuery.split("/");
        storagePath = parts.slice(parts.indexOf("gallery")).join("/");
      }

      console.log("Deleting file:", storagePath);
      const file = bucket.file(storagePath);
      await file.delete();
    } catch (err) {
      console.log("Error deleting image:", err.message);
    }

    // Remove specific images from Firestore array
    const docRef = db.collection("gallery").doc(galleryId);
    await docRef.update({
      images: FieldValue.arrayRemove(image),
    });

    // check the document has no images
    const doc = await docRef.get();
    if (!doc.exists) {
      console.log("No such document!");
    } else {
      const data = doc.data();
      console.log("Document data:", data);
      const imageLength = data["images"].length;
      console.log("Image length:", imageLength);
      if (imageLength === 0) {
        await docRef.delete();
        console.log("Empty document deleted successfully.");
      }
    }
    console.log("Successfully removed image from gallery.");

    // setup a notification
    const notificationDocRef = db.collection("notifications").doc();
    console.log("notificationDocRef: ", notificationDocRef);
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "gallery-removed",
    });

    res.status(200).json({
      msg: "Successfully removed image from gallery.",
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      msg: error.message,
    });
  }
};
