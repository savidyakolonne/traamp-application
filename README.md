# TRAAMP Mobile Application 🌍

TRAAMP is a Flutter-based tourism discovery application designed for Sri Lanka.
The platform helps tourists discover **lesser-known and hidden places** using an interactive map and location-based suggestions.

This repository contains:

* **Flutter frontend** (Android, iOS, Web)
* **Node.js + Express backend** for geo-based place search
* **Firestore** as the database

---

## 📁 Project Structure

```text
TRAAMP-MOBILE-FRONTEND/
│
├── traamp-mobile/
│   ├── lib/
│   │   ├── components/
│   │   │   ├── packages/
│   │   │   │   └── guide_package_card.dart
│   │   │   ├── weather/
│   │   │   │   ├── weather_card_element.dart
│   │   │   │   ├── weather_forecast.dart
│   │   │   │   └── weather_screen.dart
│   │   │   ├── main_tab_view.dart
│   │   │   └── settings_screen.dart
│   │   │
│   │   ├── models/
│   │   │   ├── activity_model.dart
│   │   │   ├── chat_message.dart
│   │   │   └── place_model.dart
│   │   │
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   ├── guide_signup_form.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── login_setup.dart
│   │   │   │   ├── role_router.dart
│   │   │   │   ├── signup.dart
│   │   │   │   └── tourist_signup_form.dart
│   │   │   │
│   │   │   ├── activities/
│   │   │   │   ├── activities_list_screen.dart
│   │   │   │   └── activities_detail_screen.dart
│   │   │   │
│   │   │   ├── assistant/
│   │   │   │   └── assistant_home.dart
│   │   │   │
│   │   │   ├── emergency/
│   │   │   │   └── emergency_services.dart
│   │   │   │
│   │   │   ├── guide/
│   │   │   │   ├── guide_gallery/
│   │   │   │   ├── guide_packages/
│   │   │   │   ├── guide_dashboard.dart
│   │   │   │   └── guide_edit_profile.dart
│   │   │   │
│   │   │   ├── map/
│   │   │   │   └── map_screen.dart
│   │   │   │
│   │   │   ├── places/
│   │   │   │   ├── place_detail_screen.dart
│   │   │   │   └── place_list_screen.dart
│   │   │   │
│   │   │   ├── profile/
│   │   │   │   ├── guide_profile_screen.dart
│   │   │   │   ├── tourist_profile_screen.dart
│   │   │   │   └── guide_public_view_screen.dart
│   │   │   │
│   │   │   └── tourist/
│   │   │
│   │   ├── services/
│   │   │   ├── position.dart
│   │   │   ├── activities_service.dart
│   │   │   ├── appUser.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── gemini_service.dart
│   │   │   ├── guide_service.dart
│   │   │   ├── location_service.dart
│   │   │   ├── places_service.dart
│   │   │   ├── user_service.dart
│   │   │   └── weather_service.dart
│   │   │
│   │   ├── widgets/
│   │   │   ├── activity_tile.dart
│   │   │   └── place_tile.dart
│   │   │
│   │   ├── main.dart
│   │   ├── firebase_options.dart
│   │   ├── list-data.dart
│   │   └── app_config.dart
│   │
│   ├── .env
│   ├── assets/
│   ├── web/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── functions/
│   ├── node_modules/
│   ├── src/
│   │   ├── config/
│   │   │   ├── firebaseAdmin.js
│   │   │   └── serviceAccountKey.json
│   │   │
│   │   ├── routes/
│   │   │   ├── placeRoutes.js
│   │   │   ├── activityRoutes.js
│   │   │   ├── guide_package.mjs
│   │   │   ├── userRoutes.js
│   │   │   └── guideRoutes.js
│   │   │
│   │   ├── controllers/
│   │   │   ├── activityController.js
│   │   │   ├── guideController.js
│   │   │   ├── placeController.js
│   │   │   └── userController.js
│   │   │
│   │   ├── app.js
│   │   └── index.js
│   │
│   ├── package.json
│   └── package-lock.json
│
├── traamp-admin/
│   ├── .next/
│   ├── app/
│   │   ├── admin/
│   │   │   ├── dashboard/
│   │   │   ├── guides/
│   │   │   ├── tourists/
│   │   │   ├── verifications/
│   │   │   └── layout.tsx
│   │   ├── favicon.ico
│   │   ├── global.css
│   │   ├── layout.tsx
│   │   └── page.tsx
│   │
│   ├── components/
│   │   └── admin/
│   │       ├── sidebar.tsx
│   │       └── topbar.tsx
│   │
│   ├── config/
│   │   └── serviceAccount.json
│   │
│   ├── lib/
│   │   └── firebaseAdmin.ts
│   │
│   ├── public/
│   ├── node_modules/
│   ├── .env.local
│   ├── .env.example
│   ├── .gitignore
│   ├── eslint.config.mjs
│   ├── package-lock.json
│   ├── package.json
│   ├── postcss.config.mjs
│   ├── next.config.ts
│   ├── next-env.d.ts
│   └── tsconfig.json
│
├── .gitignore
└── README.md
```

---

## 🚀 Features

* Tourist & Guide authentication
* Role-based dashboards
* Google Maps integration
* Current location detection
* Nearby hidden places (5km / 10km radius)
* Backend-powered geo queries (Firestore + Geohash)
* Works on **Android, iOS, and Web (Chrome)**

---

## 🧰 Prerequisites

### Frontend

* Flutter SDK (latest stable)
* Android Studio or VS Code
* Chrome browser (for Flutter Web)
* Android Emulator / iOS Simulator (optional)

Check Flutter setup:

```bash
flutter doctor
```

---

## ▶️ Running Order (IMPORTANT)

### 1. Install Dependencies

**Frontend**

```bash
flutter clean
flutter pub get
```

**Backend**

```bash
npm install
```

---

### 2. Start Backend

```bash
cd functions
npm run dev
```

Runs on port **3000**

---

### 3. Start Admin Panel

```bash
cd traamp-admin
```

Create a `.env.local` file and copy configurations from `.env.example`

```bash
npm run dev -- -p 3001
```

Runs on port **3001**

---

### 4. Start Flutter App

```bash
flutter run
```

**For Web (Chrome):**

```bash
flutter run -d chrome --dart-define=GEMINI_API_KEY=YOUR_KEY
```

(Required to test the TRAAMP assistant)

---


testing the url change