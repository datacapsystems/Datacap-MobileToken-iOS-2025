#!/bin/bash

# Datacap MobileToken iOS - Automated Build and Install Script
# This script builds and installs the app on your connected iPhone

set -e  # Exit on error

echo "🚀 Datacap MobileToken iOS - Build & Install Script"
echo "=================================================="

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed or not in PATH"
    echo "Please install Xcode from the App Store and agree to the license terms"
    exit 1
fi

# Accept Xcode license if needed
echo "📝 Checking Xcode license..."
if ! xcodebuild -license check &> /dev/null; then
    echo "You need to accept the Xcode license. Running: sudo xcodebuild -license accept"
    sudo xcodebuild -license accept
fi

# Project configuration
PROJECT_PATH="DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj"
SCHEME="DatacapMobileTokenDemo"
CONFIGURATION="Debug"

# Function to build for simulator
build_simulator() {
    echo "📱 Building for iOS Simulator..."
    
    # List available simulators
    echo "Available simulators:"
    xcrun simctl list devices | grep -E "iPhone.*Simulator" | grep -v "unavailable" || true
    
    # Default to iPhone 14 Pro
    SIMULATOR_NAME="iPhone 14 Pro"
    
    echo "Building for $SIMULATOR_NAME..."
    xcodebuild -project "$PROJECT_PATH" \
        -scheme "$SCHEME" \
        -configuration "$CONFIGURATION" \
        -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" \
        -derivedDataPath build \
        clean build
    
    echo "✅ Build successful! Opening simulator..."
    
    # Boot simulator and install app
    SIMULATOR_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -E -o "[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}" | head -1)
    
    if [ ! -z "$SIMULATOR_ID" ]; then
        xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || true
        
        # Find the app bundle
        APP_PATH=$(find build -name "*.app" -type d | head -1)
        
        if [ ! -z "$APP_PATH" ]; then
            echo "Installing app..."
            xcrun simctl install "$SIMULATOR_ID" "$APP_PATH"
            
            echo "Launching app..."
            xcrun simctl launch "$SIMULATOR_ID" com.datacapsystems.mobiletoken
            
            echo "✅ App launched in simulator!"
        fi
    fi
}

# Function to build for device
build_device() {
    echo "📱 Building for connected iPhone..."
    
    # List connected devices
    echo "Checking for connected devices..."
    DEVICE_LIST=$(xcrun devicectl list devices | grep -E "iPhone|iPad" || true)
    
    if [ -z "$DEVICE_LIST" ]; then
        echo "❌ No iOS devices connected. Please connect your iPhone via USB."
        exit 1
    fi
    
    echo "Connected devices:"
    echo "$DEVICE_LIST"
    
    # Get first connected device name
    DEVICE_NAME=$(echo "$DEVICE_LIST" | head -1 | awk '{print $2}')
    
    echo "Building for device: $DEVICE_NAME"
    
    # Build for device
    xcodebuild -project "$PROJECT_PATH" \
        -scheme "$SCHEME" \
        -configuration "$CONFIGURATION" \
        -destination "platform=iOS,name=$DEVICE_NAME" \
        -derivedDataPath build \
        clean build
    
    echo "✅ Build successful!"
    
    # Install using ios-deploy if available
    if command -v ios-deploy &> /dev/null; then
        APP_PATH=$(find build -name "*.app" -type d | head -1)
        echo "Installing on device..."
        ios-deploy --bundle "$APP_PATH" --no-wifi
    else
        echo "📌 Note: Install ios-deploy for automatic installation:"
        echo "   brew install ios-deploy"
        echo ""
        echo "The app has been built. Use Xcode to install on your device."
    fi
}

# Function to fix common issues
fix_issues() {
    echo "🔧 Applying common fixes..."
    
    # Clean derived data
    echo "Cleaning derived data..."
    rm -rf ~/Library/Developer/Xcode/DerivedData
    
    # Clean build folder
    rm -rf build
    
    echo "✅ Cleanup complete!"
}

# Main menu
echo ""
echo "Choose build target:"
echo "1) iOS Simulator"
echo "2) Connected iPhone"
echo "3) Fix common issues"
echo "4) Exit"
echo ""

read -p "Enter choice (1-4): " choice

case $choice in
    1)
        build_simulator
        ;;
    2)
        build_device
        ;;
    3)
        fix_issues
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run script again."
        exit 1
        ;;
esac

echo ""
echo "🎉 Done! Check the app on your device/simulator."
echo ""
echo "Test card for tokenization:"
echo "  Number: 4111111111111111"
echo "  Expiry: 12/25"
echo "  CVV: 123"