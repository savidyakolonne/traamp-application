# TRAAMP Mobile Application 🌍

TRAAMP is a Flutter-based tourism discovery application designed for Sri Lanka.  
The platform helps tourists discover **lesser-known and hidden places** using an interactive map and location-based suggestions.

This repository contains:

- **Flutter frontend** (Android, iOS, Web)
- **Node.js + Express backend** for geo-based place search
- **Firestore** as the database

---

## 📁 Project Structure

````text
TRAAMP-MOBILE-FRONTEND/
├── lib/                      # Flutter frontend source code
|   |── components/
|   |   |   packages/
|   |   |   └──guide_package_card.dart
|   |   |   weather/
|   |   |   |── weather_card_element.dart
|   |   |   |── weather_forecast.dart
|   |   |   └── weather_screen.dart
|   |   |   main_tab_view.dart
|   |   |   settings_screen.dart
|   |   models/
|   |       |── activity_model.dart
|   |       |── char_message.dart
|   |       └──place_model.dart
│   ├── screens/              # UI screens and layouts
│   │   ├── auth/             # Login and Registration screens
|   |   |     |── guide_signup_form.dart
|   |   |     |── login_screen.dart
|   |   |     |── login_setup.dart
|   |   |     |── role_router.dart
|   |   |     |── signup.dart
|   |   |     |── tourist_signup_form.dart
|   |   |── activities/
|   |   |     |── activities_list_screen.dart
|   |   |     |── activities_detail_screen.dart
|   |   |── assistant/
|   |   |     |──assistant_home.dart
|   |   |── emergency/
|   |   |     |──emergency_services.dart
|   |   |── places/
│   │   ├── guide/            # Guide dashboard and specific features
|   |   |     |──guide_gallery/
|   |   |     |   |──
|   |   |     |──guide_packages/
|   |   |         |── guide_dashboard.dart
|   |   |         |── guide_edit_profile.dart
│   │   ├── tourist/          # Tourist dashboard and specific features
│   │   └── map/
│   │   |    └── map_screen.dart # Google Maps integration and nearby places UI
|   |   |── places/
|   |   |    |──place_detail_screen.dart
|   |   |    |── place_list_screen.dart
|   |   |── profile/
|   |   |    |──guide_profile_screen.dart
|   |   |    |──tourist_profile_screen.dart
|   |   |    |── guide_public_view_screen.dart
|   |   |── tourist/
│   ├── services/
│   │   |──position.dart     # GPS logic and location permission handling
|   |   |── activities_service.dart
|   |   |── appUser.dart
|   |   |── auth_service.dart
|   |   |── gemini_service.dart
|   |   |── gudie_service.dart
|   |   |── location_service.dart
|   |   |── places_service.dart
|   |   |── user_service.dart
|   |   └──  weather_service.dart
|   |──widgets/
|   |   |──activity_tile.dart
|   |   └──place_tile.dart
│   |── main.dart             # Application entry point
|   |── firebase_options.dart
|   |── list-data.dart
|   └── app_config.dart
|
├── functions/  # Node.js (Firebase Functions) backend
|   |── node_modules/
|   |──src/
|   |   |──config/
|   |   |     |──firebaseAdmin.js  # Firebase Admin SDK initialization
|   |   |     └──serviceAccountKey.json # service account uris and other related stuff
│   |   |── routes/
│   │   |     |──placeRoutes.js  # Nearby places API endpoints
|   |   |     |──activityRoutes.js # activity listing route .
|   |   |     |──guide_package.mjs #
|   |   |     |──userRoutes.js         #
|   |   |     └──guideRoutes.js
|   |   |──controllers/
|   |   |     |──activityController.js
|   |   |     |──guideController.js
|   |   |     |──placeController.js
|   |   |     └──userController.js
│   |   |──app.js  # Express.js application configuration
│   |   └──index.js # Backend entry point
│   ├── package.json          # Node.js dependencies
│   └── package-lock.json
|
|──traamp-admin/
|      |──.next # generate when run the npm run dev
|      |──app/
|      |   |──admin/
|      |   |   |──dashboard/
|      |   |   |──guides/
|      |   |   |──tourists/
|      |   |   |──verifications
|      |   |   |──layout.tsx
|      |   |──favicon.ico
|      |   |──global.css
|      |   |──layout.tsx
|      |   |──page.tsx
|      |──components/
|      |   |──admin/
|      |        |──sidebar.tsx
|      |        |──topbar.tsx
|      |── config/
|      |     |──serviceAccount.json
|      |── lib/
|      |     |──firebaseAdmin.ts
|      |── public/
|      |── nodemodules # generate, wehn run the npm intall
|      |── .gitignore
|      |── eslint.config.mjs
|      |──package-lock.json
|      |──package.json
|      |──postcss.config.mjs
|      |──next.config.ts
|      |──next-env.d.ts
|      |──ts.config.json
|
|── .env
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

dependencies check-
Front end
  flutter clean
  flutter pub get
backend
  npm i

Start Backend -
cd functions
npm run dev
//run on the 3000 port

Start traamp-admin
cd traamp-admin
npm run dev -- -p 3001
// run on the 3001 port

Start Flutter App -
flutter run

if using a web browser:
flutter run -d chrome --dart-define=GEMINI_API_KEY=YOUR_KEY  for the running on the chrome .(to check the traamp assistant)
````
