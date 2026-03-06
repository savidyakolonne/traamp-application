import { Router } from "express";
import multer from "multer";
import firebaseAdmin from "../firebaseAdmin.js";

const userRouter = Router();
const { auth, db, bucket } = firebaseAdmin;
const upload = multer({ storage: multer.memoryStorage() });

// tourist register router
userRouter.post("/register-tourist", async (req, res) => {
  try {
    const createdAt = new Date(req.body.createdAt);
    const { firstName, lastName, email, password, gender, dob, type, country } =
      req.body;
    // create user with firebase auth
    const userRecord = await auth.createUser({
      email,
      password,
    });
    // save to database
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
    // return response
    res.status(201).json({
      msg: "Tourist registered successfully",
    });
  } catch (error) {
    res.status(400).json({
      msg: error.message,
    });
  }
});

// guide register router
userRouter.post(
  "/register-guide",
  upload.single("certificate"),
  async (req, res) => {
    try {
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

      // Upload file to Firebase Storage
      let certificateUrl = null;
      if (req.file) {
        const blob = bucket.file(`guide_certificates/${req.file.originalname}`);
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

      // Create user in Firebase Auth
      const userRecord = await auth.createUser({ email, password });

      // Save to Firestore
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
        certificate: certificateUrl,
      });

      res.status(201).json({ msg: "Guide registered successfully" });
    } catch (error) {
      res.status(400).json({
        msg: error.message,
      });
    }
  },
);

// Login with email & password router
userRouter.post("/loginWithEmail", async (req, res) => {
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
    console.error(e.message);
    res.status(401).json({ msg: "Invalid Username or Password" });
  }
});

userRouter.post("/get-user-data", async (req, res) => {
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
    console.error(e.message);
    res.status(401).json({ msg: "Invaid idToken" });
  }
});

userRouter.put("/update-guide-availability", async (req, res) => {
  try {
    const { idToken, availability } = req.body;
    const decoded = await auth.verifyIdToken(idToken);
    const id = decoded.uid;
    const userDocRef = await db.collection("users").doc(id);
    const userDocSnap = await userDocRef.get();
    if (userDocSnap.exists) {
      await userDocRef.update({ availability: availability });
      res.status(200).json({
        msg: "Successfully Updated.",
      });
    } else {
      console.error("Document not exist.");
      res.status(404).json({
        msg: "Document not exist",
      });
    }
  } catch (e) {
    console.error(e.message);
    res.status(400).json({ msg: "Failed to update field." });
  }
});

userRouter.post("/user-logout", async (req, res) => {
  try {
    const { idToken } = req.body;
    const decoded = await auth.verifyIdToken(idToken);
    const id = decoded.uid;
    await firebaseAdmin.auth.revokeRefreshTokens(id);
    console.log("User has been logged out (tokens revoked).");
    res.clearCookie("session");
    res.status(200).json({ msg: "Logged out successfully from server side." });
  } catch (e) {
    console.error(e.message);
    res.status(400).json({ msg: e.message });
  }
});

// update tourist profile
userRouter.put("/update-tourist-profile", async (req, res) => {
  try {
    const {
      idToken,
      firstName,
      lastName,
      country,
      gender,
      dob,
      profilePicture
    } = req.body;

    const decoded = await auth.verifyIdToken(idToken);
    const uid = decoded.uid;

    const userRef = db.collection("users").doc(uid);

    const doc = await userRef.get();
    if (!doc.exists) {
      return res.status(404).json({ msg: "User not found" });
    }

    await userRef.update({
      ...(firstName && { firstName }),
      ...(lastName && { lastName }),
      ...(country && { country }),
      ...(gender && { gender }),
      ...(dob && { dob }),
      ...(profilePicture && { profilePicture }),
    });

    res.status(200).json({
      msg: "Profile updated successfully",
    });
  } catch (e) {
    console.error(e.message);
    res.status(400).json({
      msg: "Failed to update profile",
    });
  }
});

export default userRouter;
