const admin = require("firebase-admin");

const db = admin.firestore();


// GET ALL NEWS
exports.getAllNews = async (req, res) => {
  try {

    const snapshot = await db
      .collection("news")
      .orderBy("createdAt", "desc")
      .get();

    const news = [];

    snapshot.forEach(doc => {
      news.push({
        id: doc.id,
        ...doc.data()
      });
    });

    res.status(200).json(news);

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};



// GET SINGLE NEWS
exports.getNewsById = async (req, res) => {

  try {

    const doc = await db.collection("news").doc(req.params.id).get();

    if (!doc.exists) {
      return res.status(404).json({ message: "News not found" });
    }

    res.status(200).json({
      id: doc.id,
      ...doc.data()
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }

};



// CREATE NEWS
exports.createNews = async (req, res) => {

  try {

    const { title, description, imageUrl, date } = req.body;

    const newNews = {
      title,
      description,
      imageUrl,
      date,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };

    const docRef = await db.collection("news").add(newNews);

    res.status(201).json({
      message: "News created successfully",
      id: docRef.id
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }

};



// DELETE NEWS
exports.deleteNews = async (req, res) => {

  try {

    await db.collection("news").doc(req.params.id).delete();

    res.status(200).json({
      message: "News deleted"
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }

};