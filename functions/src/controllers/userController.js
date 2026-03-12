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
      guideCertificateType,
      certificateNumber,
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

    let certificateUrl = null;

    if (req.file) {
      const blob = bucket.file(
        `guide_certificates/${userRecord.uid}_${req.file.originalname}`,
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

    await db.collection("users").doc(userRecord.uid).set({
      uid: userRecord.uid,
      firstName,
      lastName,
      email,
      gender,
      dob,
      type,
      phoneNumber,
      guideCertificateType,
      certificateNumber,
      nic,
      location,
      address,
      country,
      rating,
      availability,
      languages: [],
      profilePicture: "",
      certificate: certificateUrl,
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
