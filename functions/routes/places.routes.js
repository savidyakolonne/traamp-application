import express from "express";
//import { db } from "../firebaseAdmin.js";
import firebaseAdmin from "../firebaseAdmin.js";
import { geohashQueryBounds, distanceBetween } from "geofire-common";

const router = express.Router();
const { db } = firebaseAdmin;

router.get("/", async (req, res) => {
  try {
    const snapshot = await db.collection("places").get();

    const places = snapshot.docs.map(doc => ({
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
      activities: doc.data().activities || {},        // map of activityName: description
      bestTimeToVisit: doc.data().bestTimeToVisit || {}, // map with seasonNote & timeOfDayNote
      visitingHours: doc.data().visitingHours || {},
      shortDesc: doc.data().shortDesc || "",
    }));

    res.json(places);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "server_error" });
  }
});

//routers for map feature - savidyakolonne 

router.get("/nearby", async (req, res) => {
  try {
    const lat = Number(req.query.lat);
    const lng = Number(req.query.lng);
    const radiusInM = Number(req.query.radius || 5000);

    if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
      return res.status(400).json({ error: "lat & lng required" });
    }

    const center = [lat, lng];
    const radiusKm = radiusInM / 1000;

    const bounds = geohashQueryBounds(center, radiusInM);

    const snapshots = await Promise.all(
      bounds.map((b) =>
        db.collection("places")
          .orderBy("geohash")
          .startAt(b[0])
          .endAt(b[1])
          .get()
      )
    );

    const results = [];
    const seen = new Set();

    for (const snap of snapshots) {
      for (const doc of snap.docs) {
        if (seen.has(doc.id)) continue;
        seen.add(doc.id);

        const data = doc.data();

        // ✅ only hidden gems
        if (data.isHidden !== true) continue;

        const placeLat = data.location?.lat;
        const placeLng = data.location?.lng;

        if (!Number.isFinite(placeLat) || !Number.isFinite(placeLng)) continue;

        const dKm = distanceBetween(center, [placeLat, placeLng]);
        if (dKm <= radiusKm) {
          results.push({
            id: doc.id,
            name: data.name ?? "",
            shortDesc: data.shortDesc ?? "",
            location: data.location,
            images: data.images ?? [],
            coverImage: data.coverImage ?? "",
            popularityScore: data.popularityScore ?? 999,
            distanceKm: Number(dKm.toFixed(2)),
          });
        }
      }
    }

    // ✅ lesser-known first
    results.sort((a, b) => (a.popularityScore ?? 999) - (b.popularityScore ?? 999));

    res.json(results.slice(0, 30));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "server_error" });
  }
});

//-----------------------------------------------------------------------------------------------

router.get("/:id", async (req, res) => {
  try {
    const docRef = db.collection("places").doc(req.params.id);
    const docSnap = await docRef.get();

    if (!docSnap.exists) {
      return res.status(404).json({ error: "place_not_found" });
    }

    res.json({
      id: docSnap.id,
      ...docSnap.data(),
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "server_error" });
  }
});


export default router;
