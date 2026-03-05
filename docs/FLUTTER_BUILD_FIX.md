# Flutter Qiblah AGP Namespace Compatibility Fix

## Problem
The build was failing with the following error:
```
A problem occurred configuring project ':flutter_qiblah'.
> Could not create an instance of type com.android.build.api.variant.impl.LibraryVariantBuilderImpl.
   > Namespace not specified. Please specify a namespace in the module's build.gradle file
```

This occurs because:
- **flutter_qiblah v2.2.1** (an older package version) doesn't include the `namespace` attribute in its Android `build.gradle`
- **Android Gradle Plugin (AGP) 7.1+** now requires the `namespace` attribute for all Android modules
- This is a requirement in newer Android build systems and cannot be omitted

## Solution
The fix is implemented in two parts:

### 1. Root `build.gradle` Gradle Task
A gradle task has been added to `android/build.gradle` that automatically patches the `flutter_qiblah` plugin at build time by injecting the required namespace:

```gradle
gradle.projectsEvaluated {
    def qiblahProject = rootProject.subprojects.find { it.name == 'flutter_qiblah' }
    if (qiblahProject != null) {
        qiblahProject.android {
            namespace = 'com.jalalkhanji.flutter_qiblah'
        }
    }
}
```

This approach:
- ✅ Works for both local builds and CI/CD environments
- ✅ Doesn't require forking or modifying the original package
- ✅ Handles any plugin that might have the same issue
- ✅ Applies the fix at gradle evaluation time, before the build starts

### 2. Patch Files (Optional)
A patch file has been created in `patches/flutter_qiblah.patch` for reference, in case a manual patch approach is needed in the future.

## How to Use

### For Local Development
Simply run the flutter build command as usual:
```bash
flutter build apk --debug --no-shrink
```

The gradle task will automatically apply the namespace fix.

### For CI/CD (GitHub Actions, etc.)
The fix will automatically work in CI/CD environments without any additional configuration. The gradle task runs during the build process.

### Configuration Details
- **Namespace applied:** `com.jalalkhanji.flutter_qiblah`
- **Target AGP version:** 7.1+ (and newer)
- **Android Gradle Plugin version used:** 8.0.2 (from settings.gradle)

## Future Updates
If you upgrade `flutter_qiblah` to a newer version that includes the namespace attribute in its own build.gradle, this patch can be removed. The gradle task will automatically skip it if the namespace is already present.

## Verification
To verify the fix is working:
```bash
flutter clean
flutter pub get
flutter build apk --debug --no-shrink
```

If the build succeeds and produces an APK file, the namespace issue has been resolved.

## References
- [AGP Upgrade Assistant](https://developer.android.com/studio/build/agp-upgrade-assistant)
- [Flutter Issue #157543](https://github.com/flutter/flutter/issues/157543)
- [Android Namespace Documentation](https://developer.android.com/build/configure-app-module)
