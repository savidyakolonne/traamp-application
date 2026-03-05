import firebaseAdmin from "../firebaseAdmin.js";

const mockGuideProfile = {
  firstName: "Kasun",
  lastName: "Perera",
  email: "kasun@example.com",
  bio: "Passionate guide with 8 years of experience",
  specialties: ["Cultural Heritage", "Wildlife Tours"],
  pricePerDay: 75,
  availability: "Available",
  languages: ["English", "Sinhala"],
  rating: 4.9,
  updatedAt: null
};

export const getGuideProfile = async (req, res) => {
  try {
    const uid = req.user.uid;

    if (!firebaseAdmin.db) {
      return res.json({
        success: true,
        data: { ...mockGuideProfile, uid }
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
          bio: "",
          specialties: [],
          pricePerDay: 0,
          availability: "",
          languages: [],
          rating: 0,
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
        bio: data.bio || "",
        specialties: data.specialties || [],
        pricePerDay: data.pricePerDay || 0,
        availability: data.availability || "",
        languages: data.languages || [],
        rating: data.rating || 0,
        updatedAt: data.updatedAt || null
      }
    });

  } catch (error) {
    console.error('Get guide profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal Server Error',
      message: 'Failed to fetch profile'
    });
  }
};

export const updateGuideProfile = async (req, res) => {
  try {
    const uid = req.user.uid;
    const { bio, specialties, pricePerDay, availability, languages } = req.body;

    if (!bio && !specialties && pricePerDay === undefined && !availability && !languages) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'At least one field required (bio, specialties, pricePerDay, availability, languages)'
      });
    }

    if (specialties !== undefined && !Array.isArray(specialties)) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Specialties must be an array'
      });
    }

    if (languages !== undefined && !Array.isArray(languages)) {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'Languages must be an array'
      });
    }

    if (pricePerDay !== undefined && typeof pricePerDay !== 'number') {
      return res.status(400).json({
        success: false,
        error: 'Bad Request',
        message: 'PricePerDay must be a number'
      });
    }

    const updatedAt = new Date().toISOString();
    const updateData = { updatedAt };

    if (bio !== undefined) updateData.bio = bio;
    if (specialties !== undefined) updateData.specialties = specialties;
    if (pricePerDay !== undefined) updateData.pricePerDay = pricePerDay;
    if (availability !== undefined) updateData.availability = availability;
    if (languages !== undefined) updateData.languages = languages;

    if (!firebaseAdmin.db) {
      return res.json({
        success: true,
        message: 'Profile updated successfully',
        data: { ...mockGuideProfile, ...updateData, uid }
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
        bio: data.bio || "",
        specialties: data.specialties || [],
        pricePerDay: data.pricePerDay || 0,
        availability: data.availability || "",
        languages: data.languages || [],
        rating: data.rating || 0,
        updatedAt: data.updatedAt
      }
    });

  } catch (error) {
    console.error('Update guide profile error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal Server Error',
      message: 'Failed to update profile'
    });
  }
};