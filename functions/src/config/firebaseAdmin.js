import admin from "firebase-admin";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

// Setup __dirname for ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load service account JSON
const serviceAccount = JSON.parse(
  readFileSync(join(__dirname, "serviceAccountKey.json"), "utf8"),
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "traamp-app.firebasestorage.app",
});

admin.firestore().settings({ ignoreUndefinedProperties: true });

const auth = admin.auth();
const db = admin.firestore();
const bucket = admin.storage().bucket();

export default { auth, db, bucket };
