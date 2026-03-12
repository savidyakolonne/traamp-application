import admin from "../config/firebaseAdmin.js";

const db = admin.db;

// Save a guide to favorites
export const saveGuide = async (req, res) => {
  try {
    const { touristUid, guideUid } = req.body;

    if (!touristUid || !guideUid) {
      return res.status(400).json({ 
        success: false,
        error: "touristUid and guideUid are required" 
      });
    }

    // Verify the guide exists
    const guideDoc = await db.collection("users").doc(guideUid).get();
    if (!guideDoc.exists || guideDoc.data().type !== "guide") {
      return res.status(404).json({ 
        success: false,
        error: "Guide not found" 
      });
    }

    // Verify the tourist exists
    const touristDoc = await db.collection("users").doc(touristUid).get();
    if (!touristDoc.exists || touristDoc.data().type !== "tourist") {
      return res.status(404).json({ 
        success: false,
        error: "Tourist not found" 
      });
    }

    // Check if already saved
    const existingDoc = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .where("guideUid", "==", guideUid)
      .get();

    if (!existingDoc.empty) {
      return res.status(409).json({ 
        success: false,
        error: "Guide already saved" 
      });
    }

    // Save the guide
    const savedGuideRef = await db.collection("saved_guides").add({
      touristUid,
      guideUid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(201).json({ 
      success: true,
      message: "Guide saved successfully",
      data: {
        id: savedGuideRef.id,
        touristUid,
        guideUid,
      }
    });

  } catch (err) {
    console.error("Error saving guide:", err);
    res.status(500).json({ 
      success: false,
      error: "Failed to save guide" 
    });
  }
};

// Remove a saved guide
export const removeSavedGuide = async (req, res) => {
  try {
    const { touristUid, guideUid } = req.body;

    if (!touristUid || !guideUid) {
      return res.status(400).json({ 
        success: false,
        error: "touristUid and guideUid are required" 
      });
    }

    // Find the saved guide document
    const snapshot = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .where("guideUid", "==", guideUid)
      .get();

    if (snapshot.empty) {
      return res.status(404).json({ 
        success: false,
        error: "Saved guide not found" 
      });
    }

    // Delete the document
    const batch = db.batch();
    snapshot.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    await batch.commit();

    res.json({ 
      success: true,
      message: "Saved guide removed successfully" 
    });

  } catch (err) {
    console.error("Error removing saved guide:", err);
    res.status(500).json({ 
      success: false,
      error: "Failed to remove saved guide" 
    });
  }
};

// Check if a guide is saved
export const checkIfGuideSaved = async (req, res) => {
  try {
    const { touristUid, guideUid } = req.query;

    if (!touristUid || !guideUid) {
      return res.status(400).json({ 
        success: false,
        error: "touristUid and guideUid are required" 
      });
    }

    const snapshot = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .where("guideUid", "==", guideUid)
      .get();

    res.json({ 
      success: true,
      isSaved: !snapshot.empty 
    });

  } catch (err) {
    console.error("Error checking saved guide:", err);
    res.status(500).json({ 
      success: false,
      error: "Failed to check saved guide" 
    });
  }
};

// Get all saved guides for a tourist
export const getSavedGuides = async (req, res) => {
  try {
    const { touristUid } = req.params;

    if (!touristUid) {
      return res.status(400).json({ 
        success: false,
        error: "touristUid is required" 
      });
    }

    // Get all saved guide references
    const savedGuidesSnapshot = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .orderBy("createdAt", "desc")
      .get();

    if (savedGuidesSnapshot.empty) {
      return res.json({ 
        success: true,
        data: [] 
      });
    }

    // Fetch full guide details
    const guideUids = savedGuidesSnapshot.docs.map(doc => doc.data().guideUid);
    const guides = [];

    for (const guideUid of guideUids) {
      const guideDoc = await db.collection("users").doc(guideUid).get();
      if (guideDoc.exists && guideDoc.data().type === "guide") {
        guides.push({
          uid: guideDoc.id,
          ...guideDoc.data(),
        });
      }
    }

    res.json({ 
      success: true,
      data: guides 
    });

  } catch (err) {
    console.error("Error fetching saved guides:", err);
    res.status(500).json({ 
      success: false,
      error: "Failed to fetch saved guides" 
    });
  }
};

// Get saved guides count for a tourist
export const getSavedGuidesCount = async (req, res) => {
  try {
    const { touristUid } = req.params;

    if (!touristUid) {
      return res.status(400).json({ 
        success: false,
        error: "touristUid is required" 
      });
    }

    const snapshot = await db.collection("saved_guides")
      .where("touristUid", "==", touristUid)
      .get();

    res.json({ 
      success: true,
      count: snapshot.size 
    });

  } catch (err) {
    console.error("Error fetching saved guides count:", err);
    res.status(500).json({ 
      success: false,
      error: "Failed to fetch saved guides count" 
    });
  }
};