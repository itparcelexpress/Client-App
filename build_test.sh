#!/bin/bash

# Test Build Script for ParcelExpress Client App
# This script builds an app bundle for testing using the test URL

echo "🧪 Building ParcelExpress Client App for TESTING..."

# Clean the project first
echo "🧹 Cleaning project..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build app bundle for testing
echo "🔨 Building app bundle for testing..."
flutter build appbundle \
  --release \
  --dart-define=TEST_ENV=true \
  --target-platform android-arm64,android-arm,android-x64

echo "✅ Test app bundle built successfully!"
echo "📱 App bundle location: build/app/outputs/bundle/release/app-release.aab"
echo "🌐 Using test URL: https://test.parcelexpress.om" 