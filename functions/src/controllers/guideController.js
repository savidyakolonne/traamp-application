import admin from "../config/firebaseAdmin.js";

const db = admin.db;

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

    let guides = snapshot.docs.map(doc => ({
      uid: doc.id,
      ...doc.data(),
    }));

    //shuffle randomly
    guides = guides.sort(() => Math.random() - 0.5);

    //limit to 50
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
      return res.status(404).json({ success: false, message: "Guide not found" });
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
      }
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
      return res.status(404).json({ success: false, message: "Guide not found" });
    }

    res.json({ success: true, data: { uid: doc.id, ...doc.data() } });

  } catch (error) {
    console.error("Error fetching guide profile:", error);
    res.status(500).json({ success: false, message: "Failed to fetch guide profile" });
  }
};

// UPDATE guide profile 
export const updateGuideProfile = async (req, res) => {
  try {
    const uid = req.user.uid;

    if (!req.body || Object.keys(req.body).length === 0) {
      return res.status(400).json({ success: false, message: "No fields provided to update" });
    }

    await db.collection("users").doc(uid).update({
      ...req.body,
      updatedAt: new Date().toISOString()
    });

    const doc = await db.collection("users").doc(uid).get();
    res.json({ success: true, message: "Guide profile updated successfully", data: { uid: doc.id, ...doc.data() } });

  } catch (error) {
    console.error("Error updating guide profile:", error);
    res.status(500).json({ success: false, message: "Failed to update guide profile" });
  }
};