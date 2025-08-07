#!/bin/bash

# Production Build Script for ParcelExpress Client App
# This script builds an app bundle for production using the production URL

echo "🚀 Building ParcelExpress Client App for PRODUCTION..."

# Clean the project first
echo "🧹 Cleaning project..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build app bundle for production
# Note: TEST_ENV is not set, so it defaults to false (production)
echo "🔨 Building app bundle for production..."
flutter build appbundle \
  --release \
  --dart-define=TEST_ENV=false \
  --target-platform android-arm64,android-arm,android-x64

echo "✅ Production app bundle built successfully!"
echo "📱 App bundle location: build/app/outputs/bundle/release/app-release.aab"
echo "🌐 Using production URL: https://admin.parcelexpress.om" 