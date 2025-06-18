# Launch on iPad Air 13-inch

Since Xcode is already open, here's the quickest way:

## In Xcode (Should be open now):

1. **Select iPad Air 13-inch**:
   - Look at the top toolbar
   - Click on the device selector (to the right of "DatacapMobileTokenDemo")
   - Select **"iPad Air 13-inch (M3)"**

2. **Run the App**:
   - Press **⌘+R** (Command+R)
   - Or click the triangular "Run" button

The iPad Air simulator is already booting up and should appear shortly!

## What You'll See:

- The app will launch full screen on the iPad
- The glass morphism effects will look great on the larger display
- All buttons and text will be properly sized
- The app automatically adapts to the iPad's screen size

## Alternative Quick Command:

If you prefer, run this in Terminal:
```bash
cd ~/Documents/Datacap-MobileToken-iOS-2025/DatacapMobileTokenDemo
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPad Air 13-inch (M3)' \
  -derivedDataPath build \
  build && \
xcrun simctl launch booted dsi.dcap.demo
```

But using Xcode's Run button (⌘+R) is faster since it's already open!