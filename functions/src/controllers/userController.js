import firebaseAdmin from "../config/firebaseAdmin.js";

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

    const userRecord = await auth.createUser({ email, password });

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
      profilePicture
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
      profilePicture
    });

    res.status(200).json({
      msg: "Profile updated successfully"
    });

  } catch (error) {
    res.status(400).json({
      msg: "Failed to update profile",
      error: error.message
    });
  }
};