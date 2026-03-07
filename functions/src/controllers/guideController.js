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