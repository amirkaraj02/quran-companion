# 📋 GitHub Setup Guide — Get Your APK in 5 Minutes

Follow these steps exactly to get your APK built automatically by GitHub.

---

## Step 1 — Create GitHub Account (if needed)
Go to https://github.com and sign up (free).

---

## Step 2 — Create a New Repository

1. Click the **+** button (top right) → **New repository**
2. Name it: `quran-companion`
3. Set to **Private** (recommended) or Public
4. Do NOT initialize with README (we have one)
5. Click **Create repository**

---

## Step 3 — Upload the Project

### Option A: Upload via GitHub website (easiest)
1. On your new repo page, click **uploading an existing file**
2. Drag & drop ALL the files from your `quran_app/` folder
3. Make sure the folder structure is preserved
4. Click **Commit changes**

### Option B: Use Git command line
```bash
cd quran_app
git init
git add .
git commit -m "Initial commit — Quran Companion App"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/quran-companion.git
git push -u origin main
```

---

## Step 4 — Trigger the Build

1. Go to your repo on GitHub
2. Click the **Actions** tab
3. You'll see **"Build & Release APK"** workflow
4. Click it → Click **"Run workflow"** (blue button) → **Run workflow**

---

## Step 5 — Download Your APK

1. Wait 4-6 minutes for the build to complete ✅
2. Click on the completed workflow run
3. Scroll down to **Artifacts** section
4. Click **quran-companion-debug-apk** to download
5. You'll get a `.zip` containing the `app-debug.apk`
6. Transfer to your Android phone and install!

> **Note**: On your phone, enable **Install from Unknown Sources** in Settings → Security

---

## Step 6 — Auto-build on every push

After setup, every time you push code changes to GitHub, a new APK is automatically built. No manual steps needed.

---

## 🏷️ Create a Release with Download Link

To share a download link publicly:
1. Create a tag: `git tag v1.0.0 && git push origin v1.0.0`
2. GitHub Actions will automatically create a **Release** with the APK attached
3. Share the release URL with anyone

---

## ❓ Troubleshooting

| Problem | Solution |
|---------|----------|
| Build fails on `flutter pub get` | Check `pubspec.yaml` is in `flutter_app/` folder |
| `gen-l10n` fails | Check `l10n/` folder has `app_sq.arb`, `app_en.arb`, `app_tr.arb` |
| APK not in artifacts | Check the workflow logs for the exact error |
| Can't install APK | Enable "Unknown sources" on Android device |
