#!/bin/bash

echo "🔍 Diagnosing iPhone Installation Issues"
echo "======================================="
echo ""

# Check device connection
echo "1. Checking device connection..."
if xcrun devicectl list devices | grep -q "iPhone (310)"; then
    echo "   ✓ iPhone is connected"
else
    echo "   ✗ iPhone not found"
    exit 1
fi

# Check if app exists in DerivedData
echo ""
echo "2. Checking if app was built..."
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "DatacapMobileTokenDemo.app" -path "*/Debug-iphoneos/*" 2>/dev/null | head -1)
if [ -n "$APP_PATH" ]; then
    echo "   ✓ App found at: $APP_PATH"
    echo "   Size: $(du -sh "$APP_PATH" | cut -f1)"
else
    echo "   ✗ App not found in DerivedData"
    exit 1
fi

# Check if app is installed on device
echo ""
echo "3. Checking if app is installed on device..."
if xcrun devicectl device process launch --device C7AC4818-54FF-550F-8592-3DBF65611B67 --start-stopped com.dcap.DatacapMobileDemo 2>&1 | grep -q "not installed"; then
    echo "   ✗ App is NOT installed on device"
    echo ""
    echo "   📱 In Xcode:"
    echo "   - Make sure 'iPhone (310)' is selected in the device dropdown"
    echo "   - Press ⌘R to run (not just build)"
    echo "   - Watch for 'Installing to iPhone...' message"
    echo "   - Check the console (View → Debug Area → Show Debug Area)"
else
    echo "   ✓ App appears to be installed"
fi

echo ""
echo "4. Common fixes:"
echo "   - In Xcode: Product → Clean Build Folder (⇧⌘K)"
echo "   - Restart your iPhone"
echo "   - Reconnect the USB cable"
echo "   - In Xcode: Window → Devices and Simulators → Check your device"
echo ""