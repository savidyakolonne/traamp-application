import adminSdk from "firebase-admin";        //firebase-admin directly for FieldValue
import adminConfig from "../config/firebaseAdmin.js";

const db = adminConfig.db;

// POST /api/saved-guides
export const saveGuide = async (req, res) => {
  try {
    const touristUid = req.user.uid;
    const { guideUid } = req.body;

    if (!guideUid) {
      return res.status(400).json({ success: false, error: "guideUid is required" });
    }

    const guideDoc = await db.collection("users").doc(guideUid).get();
    if (!guideDoc.exists || guideDoc.data().type !== "guide") {
      return res.status(404).json({ success: false, error: "Guide not found" });
    }

    const existing = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .where("guideUid", "==", guideUid)
      .get();

    if (!existing.empty) {
      return res.status(409).json({ success: false, error: "Guide already saved" });
    }

    const savedRef = await db.collection("saved_guides").add({
      touristUid,
      guideUid,
      createdAt: adminSdk.firestore.FieldValue.serverTimestamp(), 
    });

    res.status(201).json({
      success: true,
      message: "Guide saved successfully",
      data: { id: savedRef.id, touristUid, guideUid }
    });

  } catch (err) {
    console.error("Error saving guide:", err);
    res.status(500).json({ success: false, error: "Failed to save guide" });
  }
};

// DELETE /api/saved-guides/:guideId
export const removeSavedGuide = async (req, res) => {
  try {
    const touristUid = req.user.uid;
    const { guideId } = req.params;

    if (!guideId) {
      return res.status(400).json({ success: false, error: "guideId is required" });
    }

    const snapshot = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .where("guideUid", "==", guideId)
      .get();

    if (snapshot.empty) {
      return res.status(404).json({ success: false, error: "Saved guide not found" });
    }

    const batch = db.batch();
    snapshot.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();

    res.json({ success: true, message: "Saved guide removed successfully" });

  } catch (err) {
    console.error("Error removing saved guide:", err);
    res.status(500).json({ success: false, error: "Failed to remove saved guide" });
  }
};

// GET /api/saved-guides
export const getSavedGuides = async (req, res) => {
  try {
    const touristUid = req.user.uid;

    const snapshot = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .orderBy("createdAt", "desc")
      .get();

    if (snapshot.empty) {
      return res.json({ success: true, data: [] });
    }

    const guides = [];
    for (const doc of snapshot.docs) {
      const guideDoc = await db.collection("users").doc(doc.data().guideUid).get();
      if (guideDoc.exists && guideDoc.data().type === "guide") {
        guides.push({ uid: guideDoc.id, ...guideDoc.data() });
      }
    }

    res.json({ success: true, data: guides });

  } catch (err) {
    console.error("Error fetching saved guides:", err);
    res.status(500).json({ success: false, error: "Failed to fetch saved guides" });
  }
};