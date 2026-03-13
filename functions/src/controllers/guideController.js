import admin from "../config/firebaseAdmin.js";

const db = admin.db;

// GET all guides
export const getAllGuides = async (req, res) => {
  try {
    let query = db.collection("users").where("type", "==", "guide");

    // optional filters
    if (req.query.location) {
      query = query.where("location", "==", req.query.location);
    }

    if (req.query.languages) {
      const languages = req.query.languages.split(",");
      query = query.where("languages", "array-contains-any", languages);
    }

    const snapshot = await query.get();

    const guides = snapshot.docs.map(doc => ({
      uid: doc.id,
      ...doc.data(),
    }));

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
      return res.status(404).json({ error: "Guide not found" });
    }

    res.json({ uid: doc.id, ...doc.data() });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch guide" });
  }
};

// GET guide profile
export const getGuideProfile = async (req, res) => {
  try {

    const guideId = req.user.uid;

    const doc = await db.collection("users").doc(guideId).get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Guide not found"
      });
    }

    res.json({
      success: true,
      data: {
        uid: doc.id,
        ...doc.data()
      }
    });

  } catch (error) {
    console.error("Error fetching guide profile:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch guide profile"
    });
  }
};

// UPDATE guide profile
export const updateGuideProfile = async (req, res) => {
  try {

    const guideId = req.user.uid;

    await db.collection("users").doc(guideId).update(req.body);

    res.json({
      success: true,
      message: "Guide profile updated successfully"
    });

  } catch (error) {
    console.error("Error updating guide profile:", error);
    res.status(500).json({
      success: false,
      message: "Failed to update guide profile"
    });
  }
};