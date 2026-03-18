import firebaseAdmin from "../config/firebaseAdmin.js";
import admin from "firebase-admin";

const { auth, db, bucket } = firebaseAdmin;

// GET all guides — shuffled, max 50
export const getAllGuides = async (req, res) => {
  try {
    let query = db.collection("users").where("type", "==", "guide");

    if (req.query.location) {
      query = query.where("location", "==", req.query.location);
    }

    if (req.query.languages) {
      const languages = req.query.languages.split(",");
      query = query.where("languages", "array-contains-any", languages);
    }

    const snapshot = await query.get();

    let guides = snapshot.docs.map((doc) => ({
      uid: doc.id,
      ...doc.data(),
    }));

    guides = guides.sort(() => Math.random() - 0.5);
    guides = guides.slice(0, 50);

    res.json(guides);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch guides" });
  }
};

// GET single guide
export const getGuideById = async (req, res) => {
  try {
    const doc = await db.collection("users").doc(req.params.uid).get();

    if (!doc.exists || doc.data().type !== "guide") {
      return res
        .status(404)
        .json({ success: false, message: "Guide not found" });
    }

    const data = doc.data();
    res.json({
      success: true,
      data: {
        uid: doc.id,
        firstName: data.firstName || "",
        lastName: data.lastName || "",
        email: data.email || "",
        phoneNumber: data.phoneNumber || "",
        languages: data.languages || [],
        location: data.location || "",
        rating: data.rating || 0,
        bio: data.bio || "",
        profilePicture: data.profilePicture || "",
        isVerified: data.isVerified || false,
        availability: data.availability || false,
        guideCertificateType: data.guideCertificateType || "",
        skills: data.skills || [],
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Failed to fetch guide" });
  }
};

// GET guide profile (authenticated)
export const getGuideProfile = async (req, res) => {
  try {
    const uid = req.user.uid;
    const doc = await db.collection("users").doc(uid).get();

    if (!doc.exists) {
      return res
        .status(404)
        .json({ success: false, message: "Guide not found" });
    }

    res.json({ success: true, data: { uid: doc.id, ...doc.data() } });
  } catch (error) {
    console.error("Error fetching guide profile:", error);
    res
      .status(500)
      .json({ success: false, message: "Failed to fetch guide profile" });
  }
};

// UPDATE guide profile
export const updateGuideProfile = async (req, res) => {
  try {
    const uid = req.user.uid;

    if (!req.body || Object.keys(req.body).length === 0) {
      return res.status(400).json({
        success: false,
        message: "No fields provided to update",
      });
    }

    await db.collection("users").doc(uid).update({
      ...req.body,
      updatedAt: new Date().toISOString(),
    });

    const doc = await db.collection("users").doc(uid).get();
    res.json({
      success: true,
      message: "Guide profile updated successfully",
      data: { uid: doc.id, ...doc.data() },
    });
  } catch (error) {
    console.error("Error updating guide profile:", error);
    res
      .status(500)
      .json({ success: false, message: "Failed to update guide profile" });
  }
};

// SUBMIT guide verification
export const submitGuideVerification = async (req, res) => {
  try {
    const { guideCertificateType, certificateNumber } = req.body;
    const uid = req.user.uid;

    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ msg: "Guide not found" });
    }

    const userData = userDoc.data();

    if (userData.type !== "guide") {
      return res.status(403).json({
        msg: "Only guides can submit verification requests",
      });
    }

    if (userData.currentVerificationStatus === "pending") {
      return res.status(400).json({
        msg: "You already have a pending verification request",
      });
    }

    const nicFile = req.files?.nicDocument?.[0];
    const certificateFile = req.files?.sltdaCertificate?.[0];

    if (!nicFile || !certificateFile) {
      return res.status(400).json({
        msg: "NIC document and SLTDA certificate are required",
      });
    }

    if (!guideCertificateType || !certificateNumber) {
      return res.status(400).json({
        msg: "Certificate type and certificate number are required",
      });
    }

    const allowedMimeTypes = [
      "image/jpeg",
      "image/jpg",
      "image/png",
      "application/pdf",
    ];

    if (!allowedMimeTypes.includes(nicFile.mimetype)) {
      return res.status(400).json({
        msg: "Invalid NIC document type. Only JPG, PNG, and PDF are allowed",
      });
    }

    if (!allowedMimeTypes.includes(certificateFile.mimetype)) {
      return res.status(400).json({
        msg: "Invalid certificate file type. Only JPG, PNG, and PDF are allowed",
      });
    }

    const verificationRef = db.collection("verifications").doc();
    const verificationId = verificationRef.id;

    const nicFileName = `guide_verifications/${uid}/${verificationId}/nic_${Date.now()}_${nicFile.originalname}`;
    const nicBlob = bucket.file(nicFileName);

    const nicBlobStream = nicBlob.createWriteStream({
      metadata: { contentType: nicFile.mimetype },
    });

    await new Promise((resolve, reject) => {
      nicBlobStream.on("error", reject);
      nicBlobStream.on("finish", resolve);
      nicBlobStream.end(nicFile.buffer);
    });

    const [nicDocumentUrl] = await nicBlob.getSignedUrl({
      action: "read",
      expires: "03-09-2491",
    });

    const certificateFileName = `guide_verifications/${uid}/${verificationId}/certificate_${Date.now()}_${certificateFile.originalname}`;
    const certificateBlob = bucket.file(certificateFileName);

    const certificateBlobStream = certificateBlob.createWriteStream({
      metadata: { contentType: certificateFile.mimetype },
    });

    await new Promise((resolve, reject) => {
      certificateBlobStream.on("error", reject);
      certificateBlobStream.on("finish", resolve);
      certificateBlobStream.end(certificateFile.buffer);
    });

    const [sltdaCertificateUrl] = await certificateBlob.getSignedUrl({
      action: "read",
      expires: "03-09-2491",
    });

    await verificationRef.set({
      verificationId,
      uid,
      nicNumber: userData.nicNumber || "",
      guideCertificateType,
      certificateNumber,
      nicDocumentUrl,
      sltdaCertificateUrl,
      status: "pending",
      submittedAt: admin.firestore.FieldValue.serverTimestamp(),
      reviewedAt: null,
      adminNote: "",
      reviewedBy: null,
      guideSnapshot: {
        firstName: userData.firstName || "",
        lastName: userData.lastName || "",
        email: userData.email || "",
        phoneNumber: userData.phoneNumber || "",
        location: userData.location || "",
        profilePicture: userData.profilePicture || "",
      },
    });

    await userRef.update({
      guideCertificateType,
      certificateNumber,
      currentVerificationStatus: "pending",
      activeVerificationId: verificationId,
      isVerified: false,
      badgeIssued: false,
    });

    const notificationDocRef = db.collection("notifications").doc();
    await notificationDocRef.set({
      notificationId: notificationDocRef.id,
      uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isUnread: true,
      type: "verification-submitted",
      verificationId,
    });

    return res.status(201).json({
      msg: "Verification request submitted successfully",
      verificationId,
      nicDocumentUrl,
      sltdaCertificateUrl,
    });
  } catch (error) {
    return res.status(400).json({
      msg: "Failed to submit verification request",
      error: error.message,
    });
  }
};