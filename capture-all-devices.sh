#!/bin/bash

# Complete screenshot capture for all App Store required devices

echo "📱 Datacap Token - Multi-Device Screenshot Capture"
echo "================================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# App path
APP_PATH="/Users/edcrotty/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-enyzfibwrsrtmtgtubarpizjjrfh/Build/Products/Debug-iphonesimulator/DatacapMobileTokenDemo.app"
BUNDLE_ID="com.dcap.DatacapMobileDemo"

# Device configurations
declare -A DEVICES=(
    ["iPhone 16 Pro Max"]="iPhone 16 Pro Max|iPhone67"
    ["iPad Pro 13-inch (M4)"]="iPad Pro 13-inch (M4)|iPadPro13"
)

echo -e "${BLUE}Required devices for App Store:${NC}"
echo "1. iPhone 16 Pro Max (6.7\") - 1290 × 2796"
echo "2. iPad Pro 13\" - 2048 × 2732"
echo ""

for device_name in "${!DEVICES[@]}"; do
    IFS='|' read -r simulator_name file_prefix <<< "${DEVICES[$device_name]}"
    
    echo -e "\n${YELLOW}Setting up $device_name...${NC}"
    
    # Get device ID
    DEVICE_ID=$(xcrun simctl list devices | grep "$simulator_name" | grep -E -o '[A-F0-9-]{36}' | head -1)
    
    if [ -z "$DEVICE_ID" ]; then
        echo -e "${YELLOW}Warning: $simulator_name not found. Skipping...${NC}"
        continue
    fi
    
    # Boot device if needed
    STATE=$(xcrun simctl list devices | grep "$DEVICE_ID" | grep -o "(.*)" | tr -d "()")
    if [ "$STATE" != "Booted" ]; then
        echo "Booting $simulator_name..."
        xcrun simctl boot "$DEVICE_ID"
        sleep 5
    fi
    
    # Install app
    echo "Installing app on $simulator_name..."
    xcrun simctl install "$DEVICE_ID" "$APP_PATH"
    
    # Set status bar
    echo "Setting perfect status bar..."
    xcrun simctl status_bar "$DEVICE_ID" override --time "9:41" --batteryState charged --batteryLevel 100 --cellularMode active --cellularBars 4 --wifiBars 3
    
    # Launch app
    echo "Launching app..."
    xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID"
    
    sleep 3
    
    echo -e "${GREEN}✅ $device_name ready for screenshots${NC}"
    echo ""
    echo "Please capture screenshots manually:"
    echo "1. Use Simulator > Device > Screenshot (⌘+S)"
    echo "2. Or run: xcrun simctl io $DEVICE_ID screenshot ${file_prefix}_1_Home.png"
    echo ""
    read -p "Press ENTER when done with $device_name screenshots..."
done

echo -e "\n${GREEN}🎉 All devices prepared!${NC}"
echo ""
echo "Final steps:"
echo "1. Review all screenshots for consistency"
echo "2. Ensure all devices show the same content"
echo "3. Consider adding device frames"
echo "4. Upload to App Store Connect"