#!/bin/bash

# Datacap MobileToken iOS Project Setup Script
# This script helps set up the project for first-time users

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${GREEN}"
echo "================================================"
echo " Datacap MobileToken iOS - Project Setup"
echo " Copyright © 2025 Datacap Systems, Inc."
echo "================================================"
echo -e "${NC}"

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj/project.pbxproj" ]; then
    print_error "Please run this script from the repository root directory"
    exit 1
fi

# Check for Xcode
if ! command -v xcodebuild &> /dev/null; then
    print_error "Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

print_status "Xcode is installed"

# Get Xcode version
XCODE_VERSION=$(xcodebuild -version | grep "Xcode" | cut -d' ' -f2)
print_status "Xcode version: $XCODE_VERSION"

# Check Xcode license
if ! xcodebuild -license check &> /dev/null; then
    print_warning "Xcode license needs to be accepted"
    echo "Running license acceptance script..."
    if [ -f "fix-xcode-license.sh" ]; then
        ./fix-xcode-license.sh
    else
        sudo xcodebuild -license accept
    fi
fi

# Check for Command Line Tools
if ! xcode-select -p &> /dev/null; then
    print_warning "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the installation and run this script again."
    exit 1
fi

print_status "Xcode Command Line Tools are installed"

# Create build directory
if [ ! -d "build" ]; then
    mkdir -p build
    print_status "Created build directory"
fi

# Clean any existing build artifacts
print_status "Cleaning previous build artifacts..."
rm -rf ~/Library/Developer/Xcode/DerivedData/DatacapMobileTokenDemo-*
rm -rf build/*

# Check if simulators are available
echo -e "\n${GREEN}Available iOS Simulators:${NC}"
xcrun simctl list devices | grep -E "iPhone|iPad" | grep -v "unavailable" | head -10

# Select simulator
echo -e "\n${YELLOW}Select build option:${NC}"
echo "1) Build for iPhone 16 Pro simulator"
echo "2) Build for iPhone 15 Pro simulator"
echo "3) Build for iPhone 14 Pro simulator"
echo "4) Build for generic iOS device (requires signing)"
echo "5) Just open in Xcode (no build)"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        DESTINATION="platform=iOS Simulator,name=iPhone 16 Pro"
        ;;
    2)
        DESTINATION="platform=iOS Simulator,name=iPhone 15 Pro"
        ;;
    3)
        DESTINATION="platform=iOS Simulator,name=iPhone 14 Pro"
        ;;
    4)
        DESTINATION="generic/platform=iOS"
        ;;
    5)
        print_status "Opening project in Xcode..."
        open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
        exit 0
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

# Build the project
echo -e "\n${GREEN}Building project...${NC}"
echo "Destination: $DESTINATION"

if [ "$choice" -eq 4 ]; then
    print_warning "Building for device requires code signing"
    print_warning "Make sure you have selected a team in Xcode"
    read -p "Press Enter to continue or Ctrl+C to cancel..."
fi

# Perform the build
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
    -scheme DatacapMobileTokenDemo \
    -destination "$DESTINATION" \
    -configuration Debug \
    -derivedDataPath build \
    clean build | xcpretty

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    print_status "Build completed successfully!"
    
    if [ "$choice" -ne 4 ]; then
        echo -e "\n${YELLOW}Would you like to:${NC}"
        echo "1) Run the app in simulator"
        echo "2) Open project in Xcode"
        echo "3) Exit"
        read -p "Enter your choice (1-3): " run_choice
        
        case $run_choice in
            1)
                print_status "Launching app in simulator..."
                # Get the app path
                APP_PATH=$(find build/Build/Products -name "*.app" | head -1)
                if [ -n "$APP_PATH" ]; then
                    xcrun simctl boot "$DESTINATION" 2>/dev/null || true
                    xcrun simctl install booted "$APP_PATH"
                    xcrun simctl launch booted com.datacapsystems.DatacapMobileTokenDemo
                    print_status "App launched!"
                else
                    print_error "Could not find built app"
                fi
                ;;
            2)
                open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
                ;;
            3)
                exit 0
                ;;
        esac
    fi
else
    print_error "Build failed. Please check the error messages above."
    echo -e "\n${YELLOW}Common issues:${NC}"
    echo "- Code signing: Open in Xcode and select a development team"
    echo "- Missing simulator: Install additional simulators in Xcode"
    echo "- Build errors: Check PROJECT_SETUP.md for troubleshooting"
    
    read -p "Would you like to open the project in Xcode? (y/n): " open_xcode
    if [ "$open_xcode" = "y" ]; then
        open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
    fi
fi

echo -e "\n${GREEN}Setup complete!${NC}"
echo "For more information, see:"
echo "- PROJECT_SETUP.md - Detailed setup instructions"
echo "- BUILD_CONFIGURATION.md - Build settings reference"
echo "- TROUBLESHOOTING.md - Common issues and solutions"