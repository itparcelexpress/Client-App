# Environment Configuration - Quick Reference

## URLs
- **Production**: `https://admin.parcelexpress.om`
- **Test**: `https://test.parcelexpress.om`

## VS Code Launch Configurations

### Production
- `Client App (Production)` - Debug mode
- `Client App (Production - Profile)` - Profile mode  
- `Client App (Production - Release)` - Release mode

### Test
- `Client App (Test)` - Debug mode
- `Client App (Test - Profile)` - Profile mode
- `Client App (Test - Release)` - Release mode

## VS Code Build Tasks

### APK Builds
- `Build APK (Production)`
- `Build APK (Test)`

### iOS Builds  
- `Build iOS (Production)`
- `Build iOS (Test)`

### Utilities
- `Clean Build`
- `Get Dependencies`

## Command Line

### Run
```bash
# Production
flutter run --dart-define=TEST_ENV=false

# Test  
flutter run --dart-define=TEST_ENV=true
```

### Build
```bash
# Production APK
flutter build apk --dart-define=TEST_ENV=false --release

# Test APK
flutter build apk --dart-define=TEST_ENV=true --release

# Production iOS
flutter build ios --dart-define=TEST_ENV=false --release

# Test iOS
flutter build ios --dart-define=TEST_ENV=true --release
```

## Visual Indicators
- **Test Environment**: Orange "TEST ENVIRONMENT" banner at top
- **Production Environment**: No banner

## Code Access
```dart
import 'package:client_app/core/utilities/app_endpoints.dart';

AppEndPoints.isTestEnvironment  // bool
AppEndPoints.environmentName    // 'TEST' or 'PRODUCTION'
AppEndPoints.baseUrl           // Current API base URL
``` 