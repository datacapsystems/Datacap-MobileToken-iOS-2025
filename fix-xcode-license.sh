#!/bin/bash

# Script to fix Xcode license agreement issue

echo "🔧 Fixing Xcode License Agreement"
echo "================================="
echo ""
echo "This script will help you accept the Xcode license agreement."
echo ""

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "📌 This script needs administrator privileges."
    echo "   Please enter your password when prompted."
    echo ""
fi

# Method 1: Command line acceptance
echo "Method 1: Accepting license via command line..."
sudo xcodebuild -license accept

if [ $? -eq 0 ]; then
    echo "✅ License accepted successfully!"
    echo ""
    echo "You can now:"
    echo "1. Open Xcode normally"
    echo "2. Run: open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj"
    echo "3. Build and run the app (⌘+R)"
else
    echo ""
    echo "⚠️  Command line method failed. Try these alternatives:"
    echo ""
    echo "Method 2: Open Xcode directly"
    echo "1. Completely quit Xcode (⌘+Q)"
    echo "2. Open Xcode from Applications"
    echo "3. Accept the license agreement when prompted"
    echo ""
    echo "Method 3: Reset and reopen"
    echo "1. Restart your Mac"
    echo "2. Open Xcode"
    echo "3. Accept the agreement"
    echo ""
    echo "Method 4: Manual acceptance"
    echo "Run: sudo xcodebuild -license"
    echo "Then press 'q' to view the license and type 'agree'"
fi

echo ""
echo "After accepting the license, you can build the app!"