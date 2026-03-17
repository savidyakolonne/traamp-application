import firebaseAdmin from "../config/firebaseAdmin.js";
import admin from "firebase-admin";

const { auth, db, bucket } = firebaseAdmin;

// register tourist
export const registerTourist = async (req, res) => {
  try {
    const createdAt = new Date(req.body.createdAt);
    const { firstName, lastName, email, password, gender, dob, type, country } =
      req.body;

    const userRecord = await auth.createUser({
      email,
      password,
    });

    await db.collection("users").doc(userRecord.uid).set({
      uid: userRecord.uid,
      firstName,
      lastName,
      email,
      gender,
      dob,
      type,
      country,
      createdAt,
    });

    // setup a notification
    const notificationDocRef = db.collection("notifications").doc();
    console.log("notificationDocRef: ", notificationDocRef);
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid: userRecord.uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "registration",
    });

    res.status(201).json({
      msg: "Tourist registered successfully",
    });
  } catch (error) {
    res.status(400).json({ msg: error.message });
  }
};

// register guide
export const registerGuide = async (req, res) => {
  try {
    const createdAt = new Date(req.body.createdAt);
    const {
      firstName,
      lastName,
      email,
      password,
      gender,
      dob,
      type,
      phoneNumber,
      nic,
      location,
      address,
      country,
      rating,
      availability,
    } = req.body;

    const userRecord = await auth.createUser({
      email,
      password,
    });

    await db.collection("users").doc(userRecord.uid).set({
      uid: userRecord.uid,
      firstName,
      lastName,
      email,
      gender,
      dob,
      type,
      phoneNumber,
      guideCertificateType: null,
      certificateNumber: null,
      nic,
      location,
      address,
      country,
      rating,
      availability,
      languages: [],
      profilePicture: "",
      certificate: null,
      createdAt,
    });

    // setup a notification
    const notificationDocRef = db.collection("notifications").doc();
    console.log("notificationDocRef: ", notificationDocRef);
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid: userRecord.uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "registration",
    });

    res.status(201).json({ msg: "Guide registered successfully" });
  } catch (error) {
    res.status(400).json({ msg: error.message });
  }
};

// login
export const loginWithEmail = async (req, res) => {
  const { idToken } = req.body;

  try {
    const decoded = await auth.verifyIdToken(idToken);
    const uid = decoded.uid;

    const userDoc = await db.collection("users").doc(uid).get();

    if (!userDoc.exists) {
      return res.status(404).json({ msg: "User profile not found" });
    }

    res.status(200).json({
      msg: "Login successful",
      profile: userDoc.data(),
    });
  } catch (e) {
    res.status(401).json({ msg: "Invalid Username or Password" });
  }
};

// get user data
export const getUserData = async (req, res) => {
  try {
    const { idToken } = req.body;

    const decoded = await auth.verifyIdToken(idToken);
    const id = decoded.uid;

    const userDoc = await db.collection("users").doc(id).get();

    if (!userDoc.exists) {
      return res.status(404).json({ msg: "User profile does not exist." });
    }

    res.status(200).json({
      msg: "Data successfully retrieved.",
      data: userDoc.data(),
    });
  } catch (e) {
    res.status(401).json({ msg: "Invalid idToken" });
  }
};

// update guide availability
export const updateGuideAvailability = async (req, res) => {
  try {
    const { idToken, availability } = req.body;

    const decoded = await auth.verifyIdToken(idToken);
    const id = decoded.uid;

    const userDocRef = db.collection("users").doc(id);

    await userDocRef.update({ availability });

    // setup a notification
    let availabilityString;
    if (availability) {
      availabilityString = "available";
    } else {
      availabilityString = "not available";
    }

    try {
      const notificationDocRef = db.collection("notifications").doc();
      console.log("notificationDocRef: ", notificationDocRef);

      await notificationDocRef.set({
        notificationId: notificationDocRef.id,
        uid: id,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isUnread: true,
        type: "availability-status",
        msg: availabilityString,
      });

      res.status(200).json({ msg: "Successfully created a notification." });
    } catch (e) {
      console.error("Error creating notification:", e);
      res.status(400).json({ msg: "Failed to update field." });
    }

    res.status(200).json({ msg: "Successfully Updated." });
  } catch (e) {
    res.status(400).json({ msg: "Failed to update field." });
  }
};

// logout
export const logoutUser = async (req, res) => {
  try {
    const { idToken } = req.body;

    const decoded = await auth.verifyIdToken(idToken);

    await auth.revokeRefreshTokens(decoded.uid);

    res.status(200).json({
      msg: "Logged out successfully",
    });
  } catch (e) {
    res.status(400).json({ msg: e.message });
  }
};

// update tourist profile
export const updateTouristProfile = async (req, res) => {
  try {
    const {
      idToken,
      firstName,
      lastName,
      country,
      gender,
      dob,
      profilePicture,
    } = req.body;

    const decoded = await auth.verifyIdToken(idToken);
    const uid = decoded.uid;

    const userRef = db.collection("users").doc(uid);

    await userRef.update({
      firstName,
      lastName,
      country,
      gender,
      dob,
      profilePicture,
    });

    // setup a notification
    const notificationDocRef = db.collection("notifications").doc();
    console.log("notificationDocRef: ", notificationDocRef);
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid: uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "user-info-changed",
    });

    res.status(200).json({
      msg: "Profile updated successfully",
    });
  } catch (error) {
    res.status(400).json({
      msg: "Failed to update profile",
      error: error.message,
    });
  }
};

// update guide profile
export const updateGuideProfile = async (req, res) => {
  try {
    const {
      idToken,
      firstName,
      lastName,
      phoneNumber,
      address,
      location,
      gender,
      dob,
      languages,
      profilePicture,
      bio,
      skills
    } = req.body;

    const decoded = await auth.verifyIdToken(idToken);
    const uid = decoded.uid;

    const userRef = db.collection("users").doc(uid);

    const updateData = {};

    if (firstName !== undefined) updateData.firstName = firstName;
    if (lastName !== undefined) updateData.lastName = lastName;
    if (phoneNumber !== undefined) updateData.phoneNumber = phoneNumber;
    if (address !== undefined) updateData.address = address;
    if (location !== undefined) updateData.location = location;
    if (gender !== undefined) updateData.gender = gender;
    if (dob !== undefined) updateData.dob = dob;
    if (languages !== undefined) updateData.languages = languages;
    if (profilePicture !== undefined)
      updateData.profilePicture = profilePicture;
    if (bio !== undefined) updateData.bio = bio;
    if (skills !== undefined) updateData.skills = skills;

    await userRef.update(updateData);

    // setup a notification
    const notificationDocRef = db.collection("notifications").doc();
    console.log("notificationDocRef: ", notificationDocRef);
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid: uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "user-info-changed",
    });

    res.status(200).json({
      msg: "Guide profile updated successfully",
    });
  } catch (error) {
    res.status(400).json({
      msg: "Failed to update guide profile",
      error: error.message,
    });
  }
};

// Update Guide Certificate
export const updateGuideCertificate = async (req, res) => {
  try {
    const { idToken, delete: deleteCert } = req.body;

    const decoded = await auth.verifyIdToken(idToken);
    const uid = decoded.uid;

    let certificateUrl = null;

    if (deleteCert) {
      const userDoc = await db.collection("users").doc(uid).get();
      const certificateUrl = userDoc.data()?.certificate;

      if (certificateUrl) {
        const fileName = certificateUrl
          .split("guide_certificates/")[1]
          .split("?")[0];

        await bucket
          .file(`guide_certificates/${fileName}`)
          .delete()
          .catch(() => {});
      }

      await db.collection("users").doc(uid).update({
        certificate: null,
      });

      return res.status(200).json({
        msg: "Certificate deleted successfully",
      });
    }

    if (req.file) {
      const blob = bucket.file(
        `guide_certificates/${uid}_${req.file.originalname}`,
      );

      const blobStream = blob.createWriteStream({
        metadata: { contentType: req.file.mimetype },
      });

      await new Promise((resolve, reject) => {
        blobStream.on("error", reject);
        blobStream.on("finish", resolve);
        blobStream.end(req.file.buffer);
      });

      const [url] = await blob.getSignedUrl({
        action: "read",
        expires: "03-09-2491",
      });

      certificateUrl = url;
    }

    await db.collection("users").doc(uid).update({
      certificate: certificateUrl,
    });

    res.status(200).json({
      msg: "Certificate updated successfully",
      certificate: certificateUrl,
    });
  } catch (error) {
    res.status(400).json({
      msg: "Failed to update certificate",
      error: error.message,
    });
  }
};

// delete user
export const deleteUser = async (req, res) => {
  try {
    const { uid, isTourist } = req.body;

    if (isTourist) {
      // remove all notifications belongs to user
      const snapshot = await db
        .collection("notifications")
        .where("uid", "==", uid)
        .get();

      const batch = db.batch();
      snapshot.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();

      // remove favorites
      const favoriteDocRef = db.collection("favorites");
      const favoriteQuarry = favoriteDocRef.where("uid", "==", uid);
      const favoriteSnapshot = await favoriteQuarry.get();
      const favorites = favoriteSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      for (let i = 0; i < favorites.length; i++) {
        const favId = favorites[i]["favoriteId"];
        await db.collection("favorites").doc(favId).delete();
      }
      console.log("Successfully deleted favorites.");

      // remove saved guides
      const savedGuidesDocRef = db.collection("saved_guides");
      const savedGuidesQuarry = savedGuidesDocRef.where(
        "touristUid",
        "==",
        uid,
      );
      const savedGuidesSnapshot = await savedGuidesQuarry.get();
      const savedGuides = savedGuidesSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      for (let i = 0; i < savedGuides.length; i++) {
        const savedGuidesId = savedGuides[i]["id"];
        await db.collection("saved_guides").doc(savedGuidesId).delete();
      }
      console.log("Successfully deleted saved_guides.");

      // revoke the token
      await auth.revokeRefreshTokens(uid);
      // delete the document of the tourist from firebase
      await db.collection("users").doc(uid).delete();
      // delete email and password from firebase auth
      await admin.auth().deleteUser(uid);
    } else {
      // remove all notifications belongs to user
      const snapshotNotifications = await db
        .collection("notifications")
        .where("uid", "==", uid)
        .get();

      const batch = db.batch();
      snapshotNotifications.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();

      // remove all ratings
      await db.collection("ratings").doc(uid).delete();

      //remove all reviews
      const reviewDocRef = db.collection("reviews");
      const reviewQuarry = reviewDocRef.where("guideId", "==", uid);
      const reviewSnapshot = await reviewQuarry.get();
      const reviews = reviewSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      for (let i = 0; i < reviews.length; i++) {
        const reviewId = reviews[i]["reviewDocId"];
        await db.collection("reviews").doc(reviewId).delete();
      }
      console.log("Reviews deleted successfully.");

      // get all packages belongs to guide
      const guide_package_ref = db.collection("guide_packages");
      const packageQuery = guide_package_ref.where("uid", "==", uid);

      const snapshot = await packageQuery.get();
      const packages = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      // deleting each package from fireStore
      for (let i = 0; i < packages.length; i++) {
        const images = packages[i]["images"];
        const coverImage = packages[i]["coverImage"];
        const packageId = packages[i]["packageId"];

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
      }

      // delete all gallery belongs to guide from fireStore
      const gallery_ref = db.collection("gallery");
      const galleryQuery = gallery_ref.where("uid", "==", uid);

      const snapshotGallery = await galleryQuery.get();
      const galleries = snapshotGallery.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      console.log("All Gallery retrieved successfully");

      // delete each gallery from fireStore
      for (let i = 0; i < galleries.length; i++) {
        const galleryId = galleries[i]["galleryId"];
        const images = galleries[i]["images"];

        try {
          for (let j = 0; j < images.length; j++) {
            const withoutQuery = images[j].split("?")[0];
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
          }
        } catch (err) {
          console.log("Error deleting image:", err.message);
        }

        // deleting the documents
        await db.collection("gallery").doc(galleryId).delete();
      }

      // revoke the token
      await auth.revokeRefreshTokens(uid);
      // delete the document of the tourist from firebase
      await db.collection("users").doc(uid).delete();
      // delete email and password from firebase auth
      await admin.auth().deleteUser(uid);
    }

    console.log("Successfully deleted user.");
    res.status(200).json({
      msg: "Successfully deleted user",
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({
      msg: "Error while deleting data",
    });
  }
};
