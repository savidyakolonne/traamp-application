import firebaseAdmin from "../config/firebaseAdmin.js";
import admin from "firebase-admin";

const { db } = firebaseAdmin;

// GET all pending verification requests
export const getPendingVerifications = async (req, res) => {
  try {
    const snapshot = await db
      .collection("verifications")
      .where("status", "==", "pending")
      .get();

    const requests = snapshot.docs
      .map((doc) => ({
        verificationId: doc.id,
        ...doc.data(),
      }))
      .sort((a, b) => {
        const aSec = a.submittedAt?._seconds || a.submittedAt?.seconds || 0;
        const bSec = b.submittedAt?._seconds || b.submittedAt?.seconds || 0;
        return bSec - aSec;
      });

    return res.status(200).json(requests);
  } catch (error) {
    console.error("Error fetching pending verifications:", error);
    return res.status(500).json({
      error: "Failed to fetch verification requests",
      details: error.message,
    });
  }
};

// GET one verification request by verificationId
export const getVerificationById = async (req, res) => {
  try {
    const { id } = req.params;

    const verificationDoc = await db.collection("verifications").doc(id).get();

    if (!verificationDoc.exists) {
      return res.status(404).json({
        error: "Verification request not found",
      });
    }

    const verificationData = verificationDoc.data();
    const uid = verificationData.uid;

    let guideData = null;

    if (uid) {
      const guideDoc = await db.collection("users").doc(uid).get();
      if (guideDoc.exists) {
        guideData = guideDoc.data();
      }
    }

    return res.status(200).json({
      verificationId: verificationDoc.id,
      ...verificationData,
      guide: guideData,
    });
  } catch (error) {
    console.error("Error fetching verification by id:", error);
    return res.status(500).json({
      error: "Failed to fetch verification request",
      details: error.message,
    });
  }
};

// APPROVE verification
export const approveVerification = async (req, res) => {
  try {
    const { id } = req.params;
    const { note } = req.body;

    const verificationRef = db.collection("verifications").doc(id);
    const verificationDoc = await verificationRef.get();

    if (!verificationDoc.exists) {
      return res.status(404).json({
        error: "Verification request not found",
      });
    }

    const verificationData = verificationDoc.data();
    const uid = verificationData.uid;

    await verificationRef.update({
      status: "approved",
      reviewedAt: admin.firestore.FieldValue.serverTimestamp(),
      reviewedBy: "admin",
      adminNote: note || "",
    });

    await db.collection("users").doc(uid).update({
      isVerified: true,
      badgeIssued: true,
      currentVerificationStatus: "approved",
      activeVerificationId: id,
      guideCertificateType: verificationData.guideCertificateType || null,
      certificateNumber: verificationData.certificateNumber || null,
    });

    return res.status(200).json({
      msg: "Guide verification approved successfully",
    });
  } catch (error) {
    console.error("Error approving verification:", error);
    return res.status(500).json({
      error: "Failed to approve verification",
      details: error.message,
    });
  }
};

// REJECT verification
export const rejectVerification = async (req, res) => {
  try {
    const { id } = req.params;
    const { note } = req.body;

    const verificationRef = db.collection("verifications").doc(id);
    const verificationDoc = await verificationRef.get();

    if (!verificationDoc.exists) {
      return res.status(404).json({
        error: "Verification request not found",
      });
    }

    const verificationData = verificationDoc.data();
    const uid = verificationData.uid;

    await verificationRef.update({
      status: "rejected",
      reviewedAt: admin.firestore.FieldValue.serverTimestamp(),
      reviewedBy: "admin",
      adminNote: note || "",
    });

    await db.collection("users").doc(uid).update({
      isVerified: false,
      badgeIssued: false,
      currentVerificationStatus: "rejected",
      activeVerificationId: id,
    });

    return res.status(200).json({
      msg: "Guide verification rejected successfully",
    });
  } catch (error) {
    console.error("Error rejecting verification:", error);
    return res.status(500).json({
      error: "Failed to reject verification",
      details: error.message,
    });
  }
};