import db from "../firebaseAdmin.js";
import Router from "express";
import { geohashQueryBounds, distanceBetween } from "geofire-common";

const router = Router();

/**
 * GET /api/places/nearby?lat=..&lng=..&radius=5000
 */
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

    // geohash bounds
    const bounds = geohashQueryBounds(center, radiusInM);
    const promises = [];

    for (const b of bounds) {
      const q = db
        .collection("places")
        .orderBy("geohash")
        .startAt(b[0])
        .endAt(b[1]);

      promises.push(q.get());
    }

    const snapshots = await Promise.all(promises);

    const results = [];
    const seen = new Set();

    for (const snap of snapshots) {
      for (const doc of snap.docs) {
        if (seen.has(doc.id)) continue;
        seen.add(doc.id);

        const data = doc.data();

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
            popularityScore: data.popularityScore ?? 999,
            distanceKm: Number(dKm.toFixed(2)),
          });
        }
      }
    }

    // lesser-known first
    results.sort((a, b) => a.popularityScore - b.popularityScore);

    res.json(results.slice(0, 30));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "server_error" });
  }
});

export default router;