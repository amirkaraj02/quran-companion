# 🕌 Quran Companion App — Complete Setup Guide

---

## 📁 Project Structure

```
quran_app/
├── flutter_app/          # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/         # Theme, Router, DI, Network, Storage
│   │   ├── features/
│   │   │   ├── auth/     # Login, Register, JWT
│   │   │   ├── quran/    # Reader, Surah list, Bookmarks
│   │   │   ├── prayer/   # Prayer times, Adhan
│   │   │   ├── qibla/    # Compass + direction
│   │   │   ├── dhikr/    # Tasbeeh counter
│   │   │   ├── progress/ # Goals, Hatim tracking
│   │   │   └── home/     # Dashboard
│   │   ├── l10n/         # ARB files (sq, en, tr)
│   │   └── generated/    # Localization classes
│   ├── pubspec.yaml
│   └── android/
├── backend/              # ASP.NET Core API
│   ├── QuranApp.Domain/
│   ├── QuranApp.Application/
│   ├── QuranApp.Infrastructure/
│   ├── QuranApp.API/
│   └── Dockerfile
├── admin_panel/          # Standalone HTML admin UI
│   └── index.html
└── docker-compose.yml
```

---

## 🚀 QUICK START (Docker)

### Prerequisites
- Docker Desktop installed
- Git installed

### 1. Start Backend + Database
```bash
cd quran_app
docker-compose up -d
```

This starts:
- PostgreSQL on port **5432**
- ASP.NET Core API on port **7000** (http://localhost:7000)
- Admin Panel on port **8080** (http://localhost:8080)

### 2. Verify API
```
http://localhost:7000/swagger
```

---

## 📱 FLUTTER APP SETUP

### Prerequisites
- Flutter 3.16+ installed (`flutter --version`)
- Android Studio + SDK installed
- Emulator or physical device

### Step 1: Install dependencies
```bash
cd flutter_app
flutter pub get
```

### Step 2: Generate localizations
```bash
flutter gen-l10n
```

### Step 3: Set API URL
Edit `lib/core/constants/app_constants.dart`:
```dart
static const String apiBaseUrl = 'http://10.0.2.2:7000/api'; // Android emulator
// or
static const String apiBaseUrl = 'http://YOUR_IP:7000/api';   // Physical device
```

### Step 4: Run the app
```bash
flutter run
```

### Step 5: Build APK (debug)
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Step 6: Build APK (release)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Step 7: Build AAB for Play Store
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 🔑 SIGNING YOUR APP (Play Store)

### Generate keystore
```bash
keytool -genkey -v -keystore ~/quran_companion.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias quran_companion
```

### Configure signing in android/key.properties
```
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=quran_companion
storeFile=/path/to/quran_companion.jks
```

### Update android/app/build.gradle
Add signingConfigs section — see Flutter official docs.

---

## 🏪 PLAY STORE PUBLISHING

1. Build signed AAB: `flutter build appbundle --release`
2. Go to [Google Play Console](https://play.google.com/console)
3. Create new app → Islamic / Religion category
4. Upload AAB to Internal Testing first
5. Fill in store listing:
   - App name: "Quran Companion — Mushaf & Prayer"
   - Short description (≤80 chars)
   - Full description (highlight Quran reading, offline, Albanian/English/Turkish)
6. Add screenshots (phone + 7-inch tablet)
7. Set Content Rating: Everyone
8. Promote to Production when ready

---

## 🗄️ DATABASE SETUP (Manual, without Docker)

### Install PostgreSQL 16
```bash
# Ubuntu/Debian
sudo apt install postgresql-16

# macOS
brew install postgresql@16
```

### Create database
```sql
CREATE DATABASE quranapp;
CREATE USER quranuser WITH PASSWORD 'yourpassword';
GRANT ALL PRIVILEGES ON DATABASE quranapp TO quranuser;
```

### Run migrations
```bash
cd backend/QuranApp.API
dotnet ef database update
```

---

## 🔧 BACKEND MANUAL RUN

```bash
cd backend/QuranApp.API

# Development
dotnet run

# Production
dotnet publish -c Release
dotnet QuranApp.API.dll
```

API available at: `https://localhost:7001` (HTTPS) / `http://localhost:7000`

---

## 🌍 ADDING QURAN DATA

The app uses the **Quran API** from `quran.api.globalquran.com` or a local JSON.

### Recommended JSON format (quran-uthmani.json)
```json
[
  {"surah": 1, "ayah": 1, "text": "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَـٰنِ ٱلرَّحِیمِ", "page": 1},
  {"surah": 1, "ayah": 2, "text": "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَـٰلَمِینَ", "page": 1},
  ...
]
```

### Upload via Admin Panel
1. Open http://localhost:8080
2. Go to "Quran Content"
3. Drop your JSON files

---

## 🔊 AUDIO RECITATIONS

Download from: https://everyayah.com/  
Format: MP3, one file per surah  
Naming: `001.mp3`, `002.mp3`, etc.

Upload via Admin Panel → Audio Recitations tab.

---

## 🕐 PRAYER TIMES

The app uses the **Adhan** Dart library with these calculation methods:
- **Diyanet** (Turkey) — default for Balkans/Turkey
- **MWL** — Muslim World League
- **Umm al-Qura** — Saudi Arabia
- **Egyptian** — Egyptian General Authority

---

## 🌐 LOCALIZATION

Add new strings to:
- `lib/l10n/app_sq.arb` (Albanian — default)
- `lib/l10n/app_en.arb` (English)
- `lib/l10n/app_tr.arb` (Turkish)

Then run: `flutter gen-l10n`

---

## 📦 KEY PACKAGES

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `dio` | HTTP client |
| `isar` | Offline database |
| `adhan` | Prayer times calculation |
| `flutter_qiblah` | Qibla compass |
| `just_audio` | Audio playback |
| `flutter_local_notifications` | Adhan + reading reminders |
| `flutter_secure_storage` | JWT token storage |

---

## 🔐 SECURITY

- JWT tokens expire in 24 hours
- Refresh tokens expire in 30 days
- All passwords hashed with SHA-256 + salt
- HTTPS enforced in production
- Input validation on all endpoints

---

## 📞 API ENDPOINTS

```
POST /api/auth/login          Login
POST /api/auth/register       Register
POST /api/auth/refresh        Refresh JWT

GET  /api/reading/goals        Get all goals
POST /api/reading/goals        Create goal
PUT  /api/reading/goals/{id}   Update progress
DEL  /api/reading/goals/{id}   Delete goal

GET  /api/reading/bookmarks    Get bookmarks
POST /api/reading/bookmarks    Add bookmark
DEL  /api/reading/bookmarks/{id}  Remove bookmark

POST /api/reading/sessions     Log reading session
POST /api/reading/sync         Full sync (offline → online)
```

Full docs: http://localhost:7000/swagger

---

## 🛠️ TECH STACK SUMMARY

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter 3.x + Dart |
| State | Riverpod |
| Navigation | GoRouter |
| Offline DB | Isar |
| Backend | ASP.NET Core 8 |
| Database | PostgreSQL 16 |
| Auth | JWT + Refresh Tokens |
| Deploy | Docker + Docker Compose |
| Admin | Standalone HTML/CSS/JS |

---

*Built with ❤️ for the Muslim community. May Allah accept it.*