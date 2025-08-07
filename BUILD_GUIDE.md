# Build Guide for ParcelExpress Client App

This guide explains how to build the ParcelExpress Client App for different environments.

## Environment Configuration

The app uses environment variables to determine which API endpoints to use:

- **Production**: `https://admin.parcelexpress.om`
- **Test**: `https://test.parcelexpress.om`

The environment is controlled by the `TEST_ENV` Dart define:
- `TEST_ENV=false` (or not set) → Production environment
- `TEST_ENV=true` → Test environment

## Quick Build Commands

### For Production (Recommended for App Store/Play Store)

```bash
# Option 1: Use the build script
./build_production.sh

# Option 2: Manual command
flutter build appbundle --release --dart-define=TEST_ENV=false
```

### For Testing

```bash
# Option 1: Use the build script
./build_test.sh

# Option 2: Manual command
flutter build appbundle --release --dart-define=TEST_ENV=true
```

## Build Output

After a successful build, the app bundle will be located at:
```
build/app/outputs/bundle/release/app-release.aab
```

## Verification

To verify which environment your build is using:

1. Install the app on a device
2. Check the app logs or debug output
3. The app will display the environment name in debug mode

## Manual Build Steps

If you prefer to build manually:

1. **Clean the project**:
   ```bash
   flutter clean
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Build for production**:
   ```bash
   flutter build appbundle \
     --release \
     --dart-define=TEST_ENV=false \
     --target-platform android-arm64,android-arm,android-x64
   ```

## Important Notes

- **Production builds** should always use `TEST_ENV=false` or omit the `--dart-define=TEST_ENV` flag entirely
- **Test builds** should use `TEST_ENV=true`
- The app bundle (`.aab`) format is required for Google Play Store uploads
- Make sure you have a valid keystore configured in `android/key.properties` for release builds

## Troubleshooting

### Common Issues

1. **Build fails with signing errors**:
   - Ensure `android/key.properties` exists and contains valid keystore information
   - Check that the keystore file path is correct

2. **Wrong environment URL**:
   - Verify the `--dart-define=TEST_ENV` flag is set correctly
   - Check `lib/core/utilities/app_endpoints.dart` for URL configuration

3. **Build size too large**:
   - Use `--target-platform` to build only for required architectures
   - Consider using ProGuard/R8 for code shrinking

### Environment Verification

You can verify the environment in your code:

```dart
import 'package:client_app/core/utilities/app_endpoints.dart';

// Check which environment is active
print('Environment: ${AppEndPoints.environmentName}');
print('Base URL: ${AppEndPoints.baseUrl}');
``` 