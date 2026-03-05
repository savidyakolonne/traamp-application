import admin from "firebase-admin";
import { readFileSync } from "fs";

const serviceAccount = JSON.parse(
  readFileSync("./serviceAccountKey.json", "utf8"),
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