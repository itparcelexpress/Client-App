# Environment Configuration Guide

This document explains how to use the environment configuration system for the ParcelExpress Client App.

## Overview

The app supports two environments:
- **Production**: `https://admin.parcelexpress.om`
- **Test**: `https://test.parcelexpress.om`

The environment is determined at compile-time using the `TEST_ENV` Dart define flag.

## How It Works

### 1. Environment Detection

The environment is detected in `lib/core/utilities/app_endpoints.dart`:

```dart
static const bool _isTestEnvironment = bool.fromEnvironment('TEST_ENV', defaultValue: false);
```

- When `TEST_ENV=true`: Uses test environment URLs
- When `TEST_ENV=false` or not set: Uses production environment URLs

### 2. Visual Indicator

When running in test environment, an orange banner appears at the top of the app showing "TEST ENVIRONMENT" to prevent confusion.

## VS Code Integration

### Launch Configurations

The `.vscode/launch.json` file includes configurations for both environments:

#### Production Environment
- **Client App (Production)**: Debug mode with production URLs
- **Client App (Production - Profile)**: Profile mode with production URLs  
- **Client App (Production - Release)**: Release mode with production URLs

#### Test Environment
- **Client App (Test)**: Debug mode with test URLs
- **Client App (Test - Profile)**: Profile mode with test URLs
- **Client App (Test - Release)**: Release mode with test URLs

### Build Tasks

The `.vscode/tasks.json` file includes build tasks for both environments:

#### APK Builds
- **Build APK (Production)**: Creates production APK
- **Build APK (Test)**: Creates test APK

#### iOS Builds
- **Build iOS (Production)**: Creates production iOS build
- **Build iOS (Test)**: Creates test iOS build

#### Utility Tasks
- **Clean Build**: Cleans the project
- **Get Dependencies**: Runs `flutter pub get`

## Usage Instructions

### Running the App

1. **VS Code (Recommended)**:
   - Open the Run and Debug panel (Ctrl+Shift+D)
   - Select the desired configuration from the dropdown
   - Click the play button or press F5

2. **Command Line**:
   ```bash
   # Production environment
   flutter run --dart-define=TEST_ENV=false
   
   # Test environment
   flutter run --dart-define=TEST_ENV=true
   ```

### Building the App

1. **VS Code**:
   - Open the Command Palette (Ctrl+Shift+P)
   - Type "Tasks: Run Task"
   - Select the desired build task

2. **Command Line**:
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

## Environment URLs

### Production Environment
- Base URL: `https://admin.parcelexpress.om`
- API Endpoint: `https://admin.parcelexpress.om/api/`
- File Path: `https://admin.parcelexpress.om/files`

### Test Environment
- Base URL: `https://test.parcelexpress.om`
- API Endpoint: `https://test.parcelexpress.om/api/`
- File Path: `https://test.parcelexpress.om/files`

## Code Access

You can access environment information in your code:

```dart
import 'package:client_app/core/utilities/app_endpoints.dart';

// Check if running in test environment
if (AppEndPoints.isTestEnvironment) {
  print('Running in test environment');
}

// Get environment name
print('Environment: ${AppEndPoints.environmentName}');

// Get current base URL
print('Base URL: ${AppEndPoints.baseUrl}');
```

## Best Practices

1. **Always use the VS Code launch configurations** to ensure consistent environment setup
2. **Check the orange banner** to confirm you're in the correct environment
3. **Use test environment for development and testing**
4. **Use production environment only for final testing and releases**
5. **Never commit test environment builds to production**

## Troubleshooting

### Environment Banner Not Showing
- Ensure you're using a test environment configuration
- Check that the `TEST_ENV=true` flag is being passed correctly
- Verify the `EnvironmentBanner` widget is included in your app

### Wrong URLs Being Used
- Check the launch configuration in VS Code
- Verify the `--dart-define=TEST_ENV=` flag is set correctly
- Clean and rebuild the project if needed

### Build Failures
- Run "Clean Build" task first
- Ensure all dependencies are installed with "Get Dependencies" task
- Check that you have the correct Flutter version and tools installed

## File Structure

```
lib/
├── core/
│   ├── utilities/
│   │   └── app_endpoints.dart          # Environment configuration
│   └── widgets/
│       └── environment_banner.dart     # Test environment banner
├── main.dart                           # App entry point with banner integration
.vscode/
├── launch.json                         # VS Code launch configurations
└── tasks.json                          # VS Code build tasks
```

## Security Notes

- The test environment banner helps prevent accidental use of test data in production
- Environment detection happens at compile-time, making it secure and efficient
- No environment variables are stored in the app bundle
- The system is designed to prevent environment confusion during development 