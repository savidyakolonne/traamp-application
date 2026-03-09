import admin from "firebase-admin";

const db = admin.firestore();

export const getAllNews = async (req, res) => {
  try {

    const snapshot = await db
      .collection("news")
      .orderBy("createdAt", "desc")
      .get();

    const news = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.status(200).json(news);

  } catch (error) {

    console.error(error);

    res.status(500).json({
      error: "Failed to fetch news"
    });

  }
};