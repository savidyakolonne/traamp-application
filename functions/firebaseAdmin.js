// functions/firebaseAdmin.js
import admin from "firebase-admin";
import { readFileSync } from "fs";

let auth, db;

try {
  const serviceAccount = JSON.parse(
    readFileSync("./serviceAccountKey.json", "utf8")
  );

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  auth = admin.auth();
  db = admin.firestore();

  console.log("✅ Firebase Admin initialized");
} catch (error) {
  console.warn("⚠️ Firebase Admin init failed:", error.message);
  console.warn("   Continuing with mock auth...");
  auth = null;
  db = null;
}

export default { auth, db };