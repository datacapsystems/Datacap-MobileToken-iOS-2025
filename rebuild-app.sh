#!/bin/bash

# Datacap MobileToken iOS - Rebuild and Run Script
# This script rebuilds the app and launches it in the simulator

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN} Rebuilding Datacap Token Demo App${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# Navigate to project directory
cd DatacapMobileTokenDemo

# Clean build folder
echo -e "${YELLOW}→ Cleaning previous build...${NC}"
xcodebuild clean -project DatacapMobileTokenDemo.xcodeproj -scheme DatacapMobileTokenDemo -quiet

# Kill any existing simulator
echo -e "${YELLOW}→ Preparing simulator...${NC}"
killall "Simulator" 2>/dev/null || true

# Build the app
echo -e "${YELLOW}→ Building app for iPhone 14 Pro...${NC}"
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
    -configuration Debug \
    build \
    -quiet

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful!${NC}"
    
    # Find the built app
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "DatacapMobileTokenDemo.app" -type d | head -1)
    
    if [ -n "$APP_PATH" ]; then
        echo -e "${YELLOW}→ Installing app on simulator...${NC}"
        
        # Boot the simulator
        xcrun simctl boot "iPhone 14 Pro" 2>/dev/null || true
        
        # Wait for simulator to boot
        sleep 3
        
        # Install the app
        xcrun simctl install booted "$APP_PATH"
        
        # Launch the app
        echo -e "${YELLOW}→ Launching app...${NC}"
        xcrun simctl launch booted com.datacapsystems.DatacapMobileTokenDemo
        
        # Open simulator window
        open -a Simulator
        
        echo -e "${GREEN}✓ App launched successfully!${NC}"
        echo ""
        echo -e "${GREEN}The app should now be running in the iPhone 14 Pro simulator.${NC}"
        echo ""
        echo "Test features:"
        echo "• Tap the '?' help button to learn about the app"
        echo "• Tap 'Get Secure Token' to test tokenization"
        echo "• Use test card: 4111 1111 1111 1111"
        echo "• Check the settings (gear icon) for API configuration"
        echo "• After generating a token, use the credit card icon for transactions"
        
    else
        echo -e "${RED}✗ Could not find built app${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Build failed${NC}"
    echo "Please check the error messages above."
    echo ""
    echo "Common issues:"
    echo "1. Make sure Xcode is installed and updated"
    echo "2. Ensure you have accepted the Xcode license"
    echo "3. Check that the iPhone 14 Pro simulator is available"
    exit 1
fi