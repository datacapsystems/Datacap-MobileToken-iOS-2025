#!/bin/bash

# Quick Reload Script - Rebuilds and pushes to running simulator
# This script rebuilds the app and installs it on the currently booted simulator

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 Quick Reload - Datacap Token Demo${NC}"
echo -e "${BLUE}====================================${NC}"
echo ""

# Check if simulator is running
if ! pgrep -x "Simulator" > /dev/null; then
    echo -e "${YELLOW}⚠️  No simulator running. Starting iPhone 16 Pro...${NC}"
    open -a Simulator
    sleep 3
    xcrun simctl boot "iPhone 16 Pro" 2>/dev/null || true
    sleep 2
fi

# Get the booted device
BOOTED_DEVICE=$(xcrun simctl list devices | grep -E "Booted" | head -1 | grep -oE '[0-9A-F-]{36}' || true)

if [ -z "$BOOTED_DEVICE" ]; then
    echo -e "${RED}❌ No booted simulator found${NC}"
    echo "Please start a simulator first or run: open -a Simulator"
    exit 1
fi

DEVICE_NAME=$(xcrun simctl list devices | grep "$BOOTED_DEVICE" | sed 's/.*(\(.*\)).*/\1/' | head -1)
echo -e "${GREEN}✓ Found running simulator: $DEVICE_NAME${NC}"

# Navigate to project
cd DatacapMobileTokenDemo

# Build the app
echo -e "${YELLOW}🔨 Building app...${NC}"
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -destination "id=$BOOTED_DEVICE" \
    -configuration Debug \
    -derivedDataPath ../build \
    build \
    -quiet \
    CODE_SIGN_ALLOWED=NO

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful${NC}"
    
    # Find the app
    APP_PATH=$(find ../build/Build/Products -name "DatacapMobileTokenDemo.app" -type d | head -1)
    
    if [ -n "$APP_PATH" ]; then
        # Uninstall existing app
        echo -e "${YELLOW}🗑  Removing old version...${NC}"
        xcrun simctl uninstall "$BOOTED_DEVICE" com.datacapsystems.DatacapMobileTokenDemo 2>/dev/null || true
        
        # Install new version
        echo -e "${YELLOW}📱 Installing new version...${NC}"
        xcrun simctl install "$BOOTED_DEVICE" "$APP_PATH"
        
        # Launch the app
        echo -e "${YELLOW}🚀 Launching app...${NC}"
        xcrun simctl launch "$BOOTED_DEVICE" com.datacapsystems.DatacapMobileTokenDemo
        
        # Bring simulator to front
        osascript -e 'tell application "Simulator" to activate'
        
        echo -e "${GREEN}✅ App reloaded successfully!${NC}"
        echo ""
        echo -e "${BLUE}What's new:${NC}"
        echo "• Help button (?) explains the app and modes"
        echo "• Refined App Store description for Datacap customers"
        echo "• Position as API testing & validation tool"
        echo "• Three testing environments"
        echo ""
        
    else
        echo -e "${RED}❌ Could not find built app${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi