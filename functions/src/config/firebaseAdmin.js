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

//Firebase Auth Middleware
const firebaseAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      return res.status(401).json({
        success: false,
        error: "Unauthorized",
        message: "No authorization token provided",
      });
    }

    if (!authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        success: false,
        error: "Unauthorized",
        message: "Invalid authorization header format. Expected: Bearer <token>",
      });
    }

    const idToken = authHeader.substring(7);
    const decodedToken = await auth.verifyIdToken(idToken);

    req.user = {
      uid: decodedToken.uid,
      email: decodedToken.email,
    };

    console.log(`Auth: ${req.user.uid} (${req.user.email})`);
    next();

  } catch (error) {
    console.error("Firebase Auth Error:", error.message);

    if (
      error.code === "auth/id-token-expired" ||
      error.code === "auth/id-token-revoked" ||
      error.code === "auth/invalid-id-token" ||
      error.code === "auth/argument-error"
    ) {
      return res.status(401).json({
        success: false,
        error: "Unauthorized",
        message: "Invalid or expired token",
      });
    }

    return res.status(500).json({
      success: false,
      error: "Internal Server Error",
      message: "Authentication failed",
    });
  }
};

export default { auth, db, bucket, firebaseAuth };
