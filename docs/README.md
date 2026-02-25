# 🕌 Quran Companion — Islamic Mobile App

A production-ready Islamic Quran Companion & Daily Worship Tracker built with Flutter + ASP.NET Core.

[![Build APK](https://github.com/YOUR_USERNAME/quran-companion/actions/workflows/build.yml/badge.svg)](https://github.com/YOUR_USERNAME/quran-companion/actions/workflows/build.yml)

## 📱 Features

| Feature | Description |
|---------|-------------|
| **Quran Reader** | All 114 Surahs, page-by-page Mushaf experience |
| **Progress Tracking** | Hatim, memorization, daily reading goals |
| **Prayer Times** | Balkans + Turkey, Diyanet/MWL/Umm al-Qura |
| **Qibla Finder** | Real compass with Kaaba direction |
| **Dhikr Counter** | Digital tasbeeh with presets |
| **3 Languages** | Albanian 🇦🇱 (default), English 🇬🇧, Turkish 🇹🇷 |
| **Offline First** | Works without internet |

## 🚀 Quick Start — Get Your APK

### Method 1: GitHub Actions (Recommended — no setup needed)

1. Push this repo to GitHub
2. Go to **Actions** tab → **Build & Release APK**
3. Click **Run workflow**
4. Wait ~5 minutes
5. Download **quran-companion-debug-apk** from the Artifacts section

### Method 2: Build Locally

```bash
# Prerequisites: Flutter 3.27+ installed
cd flutter_app
flutter pub get
flutter gen-l10n
flutter build apk --debug
# APK → build/app/outputs/flutter-apk/app-debug.apk
```

## 🏗️ Project Structure

```
quran_app/
├── .github/workflows/build.yml   ← CI/CD (builds APK automatically)
├── flutter_app/                  ← Flutter mobile app
│   ├── lib/
│   │   ├── core/                 ← Theme, routing, DI, network
│   │   └── features/             ← quran, prayer, progress, qibla, dhikr, auth
│   ├── l10n/                     ← Albanian / English / Turkish strings
│   └── android/
├── backend/                      ← ASP.NET Core Web API
│   ├── QuranApp.API/
│   ├── QuranApp.Application/
│   ├── QuranApp.Domain/
│   └── QuranApp.Infrastructure/
├── admin_panel/                  ← Static admin dashboard
└── docker-compose.yml            ← One-command backend start
```

## ⚙️ Backend Setup

```bash
# Start PostgreSQL + API
docker-compose up -d

# API available at:
# http://localhost:7000/swagger
```

## 📋 Tech Stack

- **Mobile**: Flutter 3.27 + Dart, Riverpod, GoRouter, Hive, Dio
- **Backend**: ASP.NET Core 8, PostgreSQL, JWT Auth, Entity Framework Core
- **Architecture**: Clean Architecture (Domain → Application → Infrastructure → Presentation)
- **CI/CD**: GitHub Actions

## 🌐 Localization

The app supports 3 languages switchable at runtime:
- 🇦🇱 **Albanian** (default) — `l10n/app_sq.arb`
- 🇬🇧 **English** — `l10n/app_en.arb`
- 🇹🇷 **Turkish** — `l10n/app_tr.arb`

## 📦 Play Store Release

1. Create signing key: `keytool -genkey -v -keystore quran.jks -alias quran -keyalg RSA -keysize 2048 -validity 10000`
2. Add `key.properties` to `flutter_app/android/`
3. Build: `flutter build appbundle --release`
4. Upload `.aab` to Google Play Console

---

Built with ❤️ for the Muslim community
