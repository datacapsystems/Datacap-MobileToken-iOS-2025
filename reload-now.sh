#!/bin/bash

# Simplified reload script that works with any running simulator

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔄 Reloading Datacap Token Demo${NC}"
echo ""

# Navigate to project directory
cd DatacapMobileTokenDemo

# Build for generic iOS Simulator
echo -e "${YELLOW}🔨 Building app...${NC}"
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -sdk iphonesimulator \
    -configuration Debug \
    -derivedDataPath ../build \
    build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Build successful${NC}"
    
    # Find the app
    APP_PATH=$(find ../build/Build/Products -name "DatacapMobileTokenDemo.app" -type d | head -1)
    
    if [ -n "$APP_PATH" ]; then
        # Try to uninstall and install on booted device
        echo -e "${YELLOW}📱 Installing app...${NC}"
        
        # Uninstall if exists
        xcrun simctl uninstall booted com.datacapsystems.DatacapMobileTokenDemo 2>/dev/null || true
        
        # Install new version
        xcrun simctl install booted "$APP_PATH" || {
            echo -e "${YELLOW}Trying alternate install method...${NC}"
            # If booted doesn't work, try to find the device ID
            DEVICE_ID=$(xcrun simctl list devices | grep -E "iPhone.*Booted" | grep -oE '[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}' | head -1)
            if [ -n "$DEVICE_ID" ]; then
                xcrun simctl install "$DEVICE_ID" "$APP_PATH"
            fi
        }
        
        # Launch the app
        echo -e "${YELLOW}🚀 Launching app...${NC}"
        xcrun simctl launch booted com.datacapsystems.DatacapMobileTokenDemo || {
            # Try with device ID if booted fails
            if [ -n "$DEVICE_ID" ]; then
                xcrun simctl launch "$DEVICE_ID" com.datacapsystems.DatacapMobileTokenDemo
            fi
        }
        
        # Bring simulator to front
        osascript -e 'tell application "Simulator" to activate' 2>/dev/null || true
        
        echo -e "${GREEN}✅ App reloaded!${NC}"
        echo ""
        echo -e "${BLUE}What's included:${NC}"
        echo "• Help button (?) with app information"
        echo "• Three testing modes (Demo/Cert/Production)"
        echo "• Transaction processing with saved tokens"
        echo "• Updated for both new and existing Datacap users"
        echo ""
        
    else
        echo -e "${RED}❌ Could not find built app${NC}"
        echo "Build output: ../build/Build/Products/"
        ls -la ../build/Build/Products/ 2>/dev/null || echo "No build products found"
        exit 1
    fi
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi