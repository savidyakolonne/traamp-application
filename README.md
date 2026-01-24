# TRAAMP Mobile Application 🌍

TRAAMP is a Flutter-based tourism discovery application designed for Sri Lanka.  
The platform helps tourists discover **lesser-known and hidden places** using an interactive map and location-based suggestions.

This repository contains:
- **Flutter frontend** (Android, iOS, Web)
- **Node.js + Express backend** for geo-based place search
- **Firestore** as the database

---

## 📁 Project Structure
TRAAMP-MOBILE-FRONTEND/
│
├── lib/ # Flutter frontend
│ ├── screens/ # UI screens (auth, map, dashboards)
│ │ ├── auth/
│ │ ├── guide/
│ │ ├── tourist/
│ │ └── map/
│ │ └── map_screen.dart
│ │
│ ├── services/
│ │ └── position.dart # GPS & location permission logic
│ │
│ └── main.dart
│
├── functions/ # Node.js backend
│ ├── routes/
│ │ └── places.routes.js 
│ ├── firebaseAdmin.js
│ ├── app.js
│ ├── index.js
│ ├── package.json
│ └── package-lock.json
│
├── assets/
├── web/
├── android/
├── ios/
├── pubspec.yaml
├── .gitignore
└── README.md


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
