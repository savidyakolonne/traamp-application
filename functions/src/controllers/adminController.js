import admin from "firebase-admin";

const db = admin.firestore();

// Get dashboard stats
export const getDashboardStats = async (req, res) => {
  try {
    const snapshot = await db.collection("users").get();

    let totalUsers = 0;
    let guides = 0;
    let tourists = 0;
    let pending = 0;

    snapshot.forEach((doc) => {
      const data = doc.data();
      totalUsers++;

      if (data.type === "guide") {
        guides++;
        if (data.verificationStatus === "pending") pending++;
      }

      if (data.type === "tourist") tourists++;
    });

    res.json({ totalUsers, guides, tourists, pending });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Something went wrong" });
  }
};

// Get all guides
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

    const guides = snapshot.docs.map((doc) => ({
      uid: doc.id,
      ...doc.data(),
    }));

    res.json(guides);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch guides" });
  }
};

// Get all tourists
export const getAllTourists = async (req, res) => {
  try {
    let query = db.collection("users").where("type", "==", "tourist");

    // optional filters
    if (req.query.status) {
      query = query.where("verificationStatus", "==", req.query.status);
    }

    const snapshot = await query.get();

    const tourists = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        uid: doc.id,
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        country: data.country || "N/A",
        joined: data.createdAt ? data.createdAt.toDate() : null,
        verificationStatus:
          data.verificationStatus === "pending"
            ? "Pending Verification"
            : data.verificationStatus === "verified"
            ? "Active"
            : "Suspended",
      };
    });

    res.json(tourists);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch tourists" });
  }
};

// Get tourist stats
export const getTouristStats = async (req, res) => {
  try {
    const snapshot = await db.collection("users").where("type", "==", "tourist").get();

    let total = 0;
    let active = 0;
    let suspended = 0;

    snapshot.forEach((doc) => {
      total++;
      const status = doc.data().verificationStatus;
      if (status === "verified") active++;
      if (status === "suspended") suspended++;
    });

    res.json({ total, active, suspended });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch tourist stats" });
  }
};