# TRAAMP Mobile Application 🌍

TRAAMP is a Flutter-based tourism discovery application designed for Sri Lanka.  
The platform helps tourists discover **lesser-known and hidden places** using an interactive map and location-based suggestions.

This repository contains:
- **Flutter frontend** (Android, iOS, Web)
- **Node.js + Express backend** for geo-based place search
- **Firestore** as the database

---

## 📁 Project Structure

```text
TRAAMP-MOBILE-FRONTEND/
├── lib/                      # Flutter frontend source code
│   ├── screens/              # UI screens and layouts
│   │   ├── auth/             # Login and Registration screens
│   │   ├── guide/            # Guide dashboard and specific features
│   │   ├── tourist/          # Tourist dashboard and specific features
│   │   └── map/
│   │       └── map_screen.dart # Google Maps integration and nearby places UI
│   ├── services/
│   │   └── position.dart     # GPS logic and location permission handling
│   └── main.dart             # Application entry point
├── functions/                # Node.js (Firebase Functions) backend
│   ├── routes/
│   │   └── places.routes.js  # Nearby places API endpoints
│   ├── firebaseAdmin.js      # Firebase Admin SDK initialization
│   ├── app.js                # Express.js application configuration
│   ├── index.js              # Backend entry point
│   ├── package.json          # Node.js dependencies
│   └── package-lock.json
├── assets/                   # Images, icons, and static assets
├── web/                      # Flutter web platform configuration
├── android/                  # Android native platform files
├── ios/                      # iOS native platform files
├── pubspec.yaml              # Flutter dependencies and metadata
├── .gitignore                # Files excluded from version control
└── README.md                 # Project documentation


---

## 🚀 Features

- Tourist & Guide authentication
- Role-based dashboards
- Google Maps integration
- Current location detection
- Nearby hidden places (5km / 10km radius)
- Backend-powered geo queries (Firestore + Geohash)
- Works on **Android, iOS, and Web (Chrome)**

---

## 🧰 Prerequisites

### Frontend
- Flutter SDK (latest stable)
- Android Studio or VS Code
- Chrome browser (for Flutter Web)
- Android Emulator / iOS Simulator (optional)

Check Flutter setup:
```bash
flutter doctor


▶️ Running Order (IMPORTANT)

Start Backend - 
cd functions
node index.js

Start Flutter App - 
flutter run 


flutter run -d chrome --dart-define=GEMINI_API_KEY=YOUR_KEY  for the running on the chrome .(check the traamp assistant)