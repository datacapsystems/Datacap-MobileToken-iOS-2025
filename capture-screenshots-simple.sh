#!/bin/bash

# Simple screenshot capture using booted device

echo "📸 Datacap Token - Simple Screenshot Capture"
echo "==========================================="
echo ""

# Create screenshot directory
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCREENSHOT_DIR="AppStoreAssets/Screenshots/Manual_${TIMESTAMP}"
mkdir -p "$SCREENSHOT_DIR"

echo "Screenshots will be saved to: $SCREENSHOT_DIR"
echo ""

# Function to capture with booted device
capture() {
    local name=$1
    local desc=$2
    
    echo "📱 Next: $name"
    echo "Setup: $desc"
    read -p "Press ENTER when ready..."
    
    # Use booted device instead of specific ID
    xcrun simctl io booted screenshot "$SCREENSHOT_DIR/$name.png" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Captured: $name.png"
    else
        echo "❌ Error capturing screenshot. Trying alternative method..."
        # Alternative: Use UI automation
        osascript -e 'tell application "Simulator" to activate'
        osascript -e 'tell application "System Events" to keystroke "s" using command down'
        echo "📸 Please save as: $SCREENSHOT_DIR/$name.png"
        read -p "Press ENTER when saved..."
    fi
    echo ""
}

# Capture sequence
capture "1_Home" "Main screen with logo and Get Secure Token button"
capture "2_CardEntry" "Card entry screen with keyboard (enter 4111 1111)"
capture "3_Success" "Success screen after submitting card"
capture "4_Settings" "Settings/API Configuration screen"
capture "5_Help" "Help overlay (How It Works)"
capture "6_Transaction" "Transaction screen with amount $25.00"

echo "✅ Screenshot capture complete!"
echo "📁 Check: $SCREENSHOT_DIR"
ls -la "$SCREENSHOT_DIR/"