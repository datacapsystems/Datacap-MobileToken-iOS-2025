#!/bin/bash

# Screenshot capture helper for Datacap Token app
# Run this while manually navigating through the app

echo "📸 Datacap Token - Screenshot Capture Helper"
echo "==========================================="
echo ""
echo "This script will help you capture all required screenshots."
echo "You'll need to manually navigate the app between captures."
echo ""

# Create screenshot directory with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCREENSHOT_DIR="AppStoreAssets/Screenshots/Captured_${TIMESTAMP}"
mkdir -p "$SCREENSHOT_DIR"

# Device ID (current running simulator)
DEVICE_ID="CE797196-6656-4CC7-9886-9D3C489742AE"

# Function to capture screenshot
capture_screenshot() {
    local name=$1
    local description=$2
    
    echo ""
    echo "📱 Next Screenshot: $name"
    echo "📝 Setup: $description"
    echo ""
    read -p "Press ENTER when ready to capture..."
    
    # Capture the screenshot
    xcrun simctl io $DEVICE_ID screenshot "$SCREENSHOT_DIR/$name.png"
    echo "✅ Captured: $name.png"
}

echo "Starting screenshot capture sequence..."
echo ""

# Screenshot sequence
capture_screenshot "1_Home" "Main screen with logo, 'Get Secure Token' button, and DEMO MODE indicator visible"

capture_screenshot "2_CardEntry" "Tap 'Get Secure Token', enter partial card number (4111 1111), keyboard visible"

capture_screenshot "3_Success" "Complete card entry (4111 1111 1111 1111, 12/28, 123) and submit to show success screen"

capture_screenshot "4_Settings" "Tap back, then tap Settings icon to show API configuration screen"

capture_screenshot "5_Help" "Go back to main screen, tap Help (?) button to show help overlay"

capture_screenshot "6_Transaction" "Close help, tap 'Process Transaction', enter $25.00, select a saved token"

echo ""
echo "🎉 Screenshot capture complete!"
echo "📁 Screenshots saved to: $SCREENSHOT_DIR"
echo ""
echo "Next steps:"
echo "1. Review screenshots for quality"
echo "2. Rename files if needed for App Store Connect"
echo "3. Consider adding device frames using tools like Rotato or Previewed"
echo ""

# Optional: Open the screenshot directory
open "$SCREENSHOT_DIR"