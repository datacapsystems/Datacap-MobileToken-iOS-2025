#!/bin/bash

# Interactive screenshot capture for Datacap Token app

echo "📸 Datacap Token - Interactive Screenshot Capture"
echo "================================================"
echo ""
echo "This script will guide you through capturing each screenshot."
echo "You'll need to manually navigate the app between captures."
echo ""

# Create screenshot directory
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCREENSHOT_DIR="AppStoreAssets/Screenshots/Interactive_${TIMESTAMP}"
mkdir -p "$SCREENSHOT_DIR"

# Device ID (current running simulator)
DEVICE_ID="CE797196-6656-4CC7-9886-9D3C489742AE"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Let's capture all 6 required screenshots...${NC}\n"

# Screenshot 1: Home Screen
echo -e "${YELLOW}Screenshot 1: HOME SCREEN${NC}"
echo "Please ensure:"
echo "  ✓ App is on the main screen"
echo "  ✓ Datacap logo is visible"
echo "  ✓ 'Get Secure Token' button is visible"
echo "  ✓ Feature cards are visible"
echo "  ✓ 'DEMO MODE' indicator is in top-left"
echo ""
read -p "Press ENTER when ready to capture Home Screen..."
xcrun simctl io $DEVICE_ID screenshot "$SCREENSHOT_DIR/1_Home.png"
echo -e "${GREEN}✅ Captured: 1_Home.png${NC}\n"

# Screenshot 2: Card Entry
echo -e "${YELLOW}Screenshot 2: CARD ENTRY${NC}"
echo "Please:"
echo "  1. Tap 'Get Secure Token' button"
echo "  2. Enter partial card number: 4111 1111"
echo "  3. Make sure keyboard is visible"
echo "  4. Card type (Visa) icon should be showing"
echo ""
read -p "Press ENTER when ready to capture Card Entry..."
xcrun simctl io $DEVICE_ID screenshot "$SCREENSHOT_DIR/2_CardEntry.png"
echo -e "${GREEN}✅ Captured: 2_CardEntry.png${NC}\n"

# Screenshot 3: Success
echo -e "${YELLOW}Screenshot 3: TOKEN SUCCESS${NC}"
echo "Please:"
echo "  1. Complete the card number: 4111 1111 1111 1111"
echo "  2. Select expiry date: December 2028 (12/28)"
echo "  3. Enter CVV: 123"
echo "  4. Tap 'Submit' button"
echo "  5. Wait for success screen with green checkmark"
echo ""
read -p "Press ENTER when success screen is showing..."
xcrun simctl io $DEVICE_ID screenshot "$SCREENSHOT_DIR/3_Success.png"
echo -e "${GREEN}✅ Captured: 3_Success.png${NC}\n"

# Screenshot 4: Settings
echo -e "${YELLOW}Screenshot 4: SETTINGS${NC}"
echo "Please:"
echo "  1. Tap 'OK' to close success screen"
echo "  2. Tap the Settings icon (gear in top-right)"
echo "  3. Make sure API Configuration screen is visible"
echo "  4. Demo mode should be selected"
echo ""
read -p "Press ENTER when Settings screen is showing..."
xcrun simctl io $DEVICE_ID screenshot "$SCREENSHOT_DIR/4_Settings.png"
echo -e "${GREEN}✅ Captured: 4_Settings.png${NC}\n"

# Screenshot 5: Help
echo -e "${YELLOW}Screenshot 5: HELP OVERLAY${NC}"
echo "Please:"
echo "  1. Tap back arrow to return to main screen"
echo "  2. Tap the Help button (? in top-right)"
echo "  3. Make sure 'How It Works' overlay is visible"
echo "  4. Operation modes should be visible"
echo ""
read -p "Press ENTER when Help overlay is showing..."
xcrun simctl io $DEVICE_ID screenshot "$SCREENSHOT_DIR/5_Help.png"
echo -e "${GREEN}✅ Captured: 5_Help.png${NC}\n"

# Screenshot 6: Transaction
echo -e "${YELLOW}Screenshot 6: TRANSACTION PROCESSING${NC}"
echo "Please:"
echo "  1. Tap X to close help overlay"
echo "  2. Tap 'Process Transaction' button"
echo "  3. Enter amount: 25.00 using number pad"
echo "  4. Make sure a saved token is visible (if any)"
echo "  5. Number pad should be visible"
echo ""
read -p "Press ENTER when Transaction screen is showing..."
xcrun simctl io $DEVICE_ID screenshot "$SCREENSHOT_DIR/6_Transaction.png"
echo -e "${GREEN}✅ Captured: 6_Transaction.png${NC}\n"

echo -e "${GREEN}🎉 All screenshots captured successfully!${NC}"
echo -e "📁 Screenshots saved to: ${BLUE}$SCREENSHOT_DIR${NC}"
echo ""
echo "Please verify all screenshots show the correct screens."
echo ""

# Open the directory
open "$SCREENSHOT_DIR"