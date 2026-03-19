import admin from "firebase-admin";

const db = admin.firestore();

// Get dashboard stats
export const getDashboardStats = async (req, res) => {
  try {
    const usersRef = db.collection("users");
    const verificationsRef = db.collection("verifications");

    const [usersSnapshot, guidesSnapshot, touristsSnapshot, pendingSnapshot] =
      await Promise.all([
        usersRef.get(),
        usersRef.where("type", "==", "guide").get(),
        usersRef.where("type", "==", "tourist").get(),
        verificationsRef.where("status", "==", "pending").get(),
      ]);

    return res.json({
      totalUsers: usersSnapshot.size,
      guides: guidesSnapshot.size,
      tourists: touristsSnapshot.size,
      pending: pendingSnapshot.size,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: "Something went wrong" });
  }
};

// Get all guides
// export const getAllGuides = async (req, res) => {
//   try {
//     let query = db.collection("users").where("type", "==", "guide");

//     // optional filters
//     if (req.query.location) {
//       query = query.where("location", "==", req.query.location);
//     }

//     if (req.query.languages) {
//       const languages = req.query.languages.split(",");
//       query = query.where("languages", "array-contains-any", languages);
//     }

//     const snapshot = await query.get();

//     const guides = snapshot.docs.map((doc) => ({
//       uid: doc.id,
//       ...doc.data(),
//     }));

//     res.json(guides);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: "Failed to fetch guides" });
//   }
// };

// Get all tourists
export const getAllTourists = async (req, res) => {
  try {
    let query = db.collection("users").where("type", "==", "tourist");

    if (req.query.status) {
      query = query.where("accountStatus", "==", req.query.status);
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
    const snapshot = await db
      .collection("users")
      .where("type", "==", "tourist")
      .get();

    let total = 0;
    let active = 0;
    let suspended = 0;

    snapshot.forEach((doc) => {
      total++;
      const status = doc.data().accountStatus || "active";

      if (status === "active") active++;
      if (status === "suspended") suspended++;
    });

    res.json({ total, active, suspended });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch tourist stats" });
  }
};


// Get all pending guide verification requests
export const getPendingVerificationRequests = async (req, res) => {
  try {
    const snapshot = await db
      .collection("users")
      .where("type", "==", "guide")
      .where("verificationStatus", "==", "pending")
      .get();

    const requests = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        uid: doc.id,
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        location: data.location || "N/A",
        languages: data.languages || [],
        verificationStatus: data.verificationStatus,
        verificationRequestedAt: data.verificationRequestedAt || null,
        nicImageUrl: data.nicImageUrl || "",
        sltdaCertificateUrl: data.sltdaCertificateUrl || "",
        nicNumber: data.nicNumber || "",
        certificateNumber: data.certificateNumber || "",
      };
    });

    res.json(requests);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch verification requests" });
  }
};

// Get one guide verification request by uid
export const getVerificationRequestById = async (req, res) => {
  try {
    const { uid } = req.params;

    const doc = await db.collection("users").doc(uid).get();

    if (!doc.exists) {
      return res.status(404).json({ error: "Guide not found" });
    }

    const data = doc.data();

    if (data.type !== "guide") {
      return res.status(400).json({ error: "User is not a guide" });
    }

    res.json({
      uid: doc.id,
      ...data,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch verification request" });
  }
};

// Approve guide verification
export const approveGuideVerification = async (req, res) => {
  try {
    const { uid } = req.params;
    const { note } = req.body;

    const userRef = db.collection("users").doc(uid);
    const doc = await userRef.get();

    if (!doc.exists) {
      return res.status(404).json({ error: "Guide not found" });
    }

    const data = doc.data();

    if (data.type !== "guide") {
      return res.status(400).json({ error: "User is not a guide" });
    }

    await userRef.update({
      verificationStatus: "verified",
      isVerified: true,
      verificationNote: note || "Approved by admin",
      verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      rejectedAt: null,
    });

    res.json({ message: "Guide verification approved successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to approve guide verification" });
  }
};

// Reject guide verification
export const rejectGuideVerification = async (req, res) => {
  try {
    const { uid } = req.params;
    const { note } = req.body;

    if (!note || !note.trim()) {
      return res.status(400).json({ error: "Rejection note is required" });
    }

    const userRef = db.collection("users").doc(uid);
    const doc = await userRef.get();

    if (!doc.exists) {
      return res.status(404).json({ error: "Guide not found" });
    }

    const data = doc.data();

    if (data.type !== "guide") {
      return res.status(400).json({ error: "User is not a guide" });
    }

    await userRef.update({
      verificationStatus: "rejected",
      isVerified: false,
      verificationNote: note,
      rejectedAt: admin.firestore.FieldValue.serverTimestamp(),
      verifiedAt: null,
    });

    res.json({ message: "Guide verification rejected successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to reject guide verification" });
  }
};