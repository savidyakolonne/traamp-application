import firebaseAdmin from "../firebaseAdmin.js";

const mockTouristProfile = {
  firstName: "Alex",
  lastName: "Chen",
  email: "alex@example.com",
  country: "Canada",
  bio: "Love exploring new places",
  preferences: ["nature", "culture"],
  updatedAt: null
};

export const getTouristProfile = async (req, res) => {
  try {
    const uid = req.user.uid;

    if (!firebaseAdmin.db) {
      return res.json({
        success: true,
        data: { ...mockTouristProfile, uid }
      });
    }

    const docRef = firebaseAdmin.db.collection('users').doc(uid);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.json({
        success: true,
        data: {
          uid,
          firstName: "",
          lastName: "",
          email: "",
          country: "",
          bio: "",
          preferences: [],
          updatedAt: null
        }
      });
    }

    const data = doc.data();

    res.json({
      success: true,
      data: {
        uid,
        firstName: data.firstName || "",
        lastName: data.lastName || "",
        email: data.email || "",
        country: data.country || "",
        bio: data.bio || "",
        preferences: data.preferences || [],
        updatedAt: data.updatedAt || null
      }
    });

  } catch (error) {
    console.error('Get tourist profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal Server Error',
      message: 'Failed to fetch profile'
    });
  }
};

export const updateTouristProfile = async (req, res) => {
  try {
    const uid = req.user.uid;
    const { firstName, lastName, country, bio, preferences } = req.body;

    if (!firstName && !lastName && !country && !bio && !preferences) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'At least one field required'
      });
    }

    if (preferences && !Array.isArray(preferences)) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Preferences must be an array'
      });
    }

    const updatedAt = new Date().toISOString();
    const updateData = { updatedAt };

    if (firstName !== undefined) updateData.firstName = firstName;
    if (lastName !== undefined) updateData.lastName = lastName;
    if (country !== undefined) updateData.country = country;
    if (bio !== undefined) updateData.bio = bio;
    if (preferences !== undefined) updateData.preferences = preferences;

    if (!firebaseAdmin.db) {
      return res.json({
        success: true,
        message: 'Profile updated successfully',
        data: { ...mockTouristProfile, ...updateData, uid }
      });
    }

    const docRef = firebaseAdmin.db.collection('users').doc(uid);
    await docRef.set(updateData, { merge: true });

    const doc = await docRef.get();
    const data = doc.data();

    res.json({
      success: true,
      message: 'Profile updated successfully',
      data: {
        uid,
        firstName: data.firstName || "",
        lastName: data.lastName || "",
        email: data.email || "",
        country: data.country || "",
        bio: data.bio || "",
        preferences: data.preferences || [],
        updatedAt: data.updatedAt
      }
    });

  } catch (error) {
    console.error('Update tourist profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal Server Error',
      message: 'Failed to update profile'
    });
  }
};