#!/bin/bash

# Exit on error
set -e
echo "📱 Launching iOS simulator (if not already open)..."
open -a Simulator

echo "🔄 Cleaning Flutter build..."
flutter clean

echo "📦 Getting Flutter packages..."
flutter pub get

# Check if ios/Podfile exists
if [ ! -f "ios/Podfile" ]; then
  echo "📁 No Podfile found. Running 'flutter create .' to generate iOS project files..."
  flutter create .
fi

#echo "🧼 Cleaning iOS build and installing CocoaPods..."
#cd ios
#pod install
#cd ..

# Get the default simulator device ID
DEVICE_ID=$(xcrun simctl list devices | grep -m1 "Booted" | awk -F '[()]' '{print $2}')

# Boot a simulator if none is running
if [ -z "$DEVICE_ID" ]; then
  echo "🕐 No simulator booted. Booting default simulator..."
  DEVICE_NAME=$(xcrun simctl list devices available | grep -m1 "iPhone" | awk -F '(' '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//')
  DEVICE_ID=$(xcrun simctl list devices available | grep "$DEVICE_NAME" | awk -F '[()]' '{print $2}' | head -1)
  xcrun simctl boot "$DEVICE_ID"
fi

# Wait until simulator is fully booted
echo "⏳ Waiting for simulator to finish booting..."
xcrun simctl bootstatus "$DEVICE_ID" -b


echo "🛠 Building and running the app on iOS simulator..."
flutter run

echo "✅ Done!"
