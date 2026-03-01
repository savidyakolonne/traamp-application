import express from "express";
//import { db } from "../firebaseAdmin.js";
import firebaseAdmin from "../firebaseAdmin.js";

const router = express.Router();
const { db } = firebaseAdmin;

router.get("/" , async (req, res) => {
    try {
        const snapshot = await db.collection("activities").get();

        const activities = snapshot.docs.map(doc =>({
            id: doc.id,
            name: doc.data().name || "",
            category: doc.data().category || "",
            district: doc.data().district || "",
            province: doc.data().province || "",
            coverImage: doc.data().coverImage,
            images: doc.data().images || [],
            description: doc.data().description || "",
            location: doc.data().location || {},
            keywords: doc.data().search?.keywords || [],
            bestTime: doc.data().bestTime || {},
            shortDesc: doc.data().shortDesc || "",
        }));

         res.json(activities);
    }catch (error) {
        console.error(error);
        res.status(500).json({ error: "server_error"});
    }
});

router.get("/:id", async (req, res) => {
    try{
        const docRef = db.collection("activities").doc(req.params.id);
        const docSnap = await docRef.get();

        if (!docSnap.exists) {
            return res.status(404).json({ error: "activities_not_found"});
        }
        res.json({
            id:docSnap.id,
            ...docSnap.data(),
        });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "server_error"});
    }
});

export default router;
