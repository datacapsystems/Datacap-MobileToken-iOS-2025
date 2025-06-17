# Datacap MobileToken iOS Project Setup Guide

This guide will help you set up and build the Datacap MobileToken iOS demo project from scratch.

## Prerequisites

Before you begin, ensure you have:

- **macOS**: Version 13.0 (Ventura) or later
- **Xcode**: Version 15.0 or later (Download from [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835))
- **Apple ID**: Required for code signing (free account works for testing)
- **Git**: For cloning the repository
- **CocoaPods** (optional): If you plan to add dependencies later

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025.git
cd Datacap-MobileToken-iOS-2025
```

### 2. Open in Xcode

```bash
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
```

Or double-click the `.xcodeproj` file in Finder.

### 3. Configure Code Signing

1. Select the project in the navigator
2. Select the "DatacapMobileTokenDemo" target
3. Go to "Signing & Capabilities" tab
4. Check "Automatically manage signing"
5. Select your Team (use personal Apple ID if no developer account)

### 4. Build and Run

- Press `⌘+R` or click the Play button
- Select a simulator (iPhone 14 Pro or later recommended)
- Wait for the build to complete

## Project Structure

```
Datacap-MobileToken-iOS-2025/
├── DatacapMobileTokenDemo/
│   ├── DatacapMobileDemo/
│   │   ├── AppDelegate.h/m              # Objective-C app lifecycle
│   │   ├── ViewController.h/m           # Legacy Objective-C (for compatibility)
│   │   ├── ModernViewController.swift   # Main UI controller
│   │   ├── SettingsViewController.swift # Settings screen
│   │   ├── TransactionViewController.swift # Transaction processing
│   │   ├── DatacapTokenService.swift    # Token service & card input
│   │   ├── GlassMorphismExtensions.swift # UI extensions
│   │   ├── DatacapMobileDemo-Bridging-Header.h # Swift/ObjC bridge
│   │   ├── Main.storyboard             # Entry point (uses ModernViewController)
│   │   ├── Info.plist                  # App configuration
│   │   └── Assets.xcassets/            # Images and colors
│   ├── DatacapMobileToken.xcframework/ # Legacy framework (unused)
│   └── DatacapMobileTokenDemo.xcodeproj/
├── README.md
├── PROJECT_SETUP.md (this file)
├── CLAUDE.md
├── APP_STORE_SUBMISSION.md
├── TROUBLESHOOTING.md
├── build-and-install.sh
└── fix-xcode-license.sh
```

## Build Configuration

### Project Settings

- **Deployment Target**: iOS 15.6
- **Swift Version**: 5.0
- **Supported Devices**: iPhone
- **Orientations**: Portrait only
- **Build Configuration**: Debug/Release

### Required Frameworks

All frameworks are built-in iOS frameworks:
- UIKit
- Foundation
- CommonCrypto

### Build Settings

Key build settings in the project:
```
IPHONEOS_DEPLOYMENT_TARGET = 15.6
SWIFT_VERSION = 5.0
SWIFT_OBJC_BRIDGING_HEADER = DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h
FRAMEWORK_SEARCH_PATHS = $(inherited) "$(PROJECT_DIR)"
ENABLE_BITCODE = NO
```

## Step-by-Step Manual Setup

If you're creating the project from scratch:

### 1. Create New Project

1. Open Xcode
2. File → New → Project
3. Choose "iOS" → "App"
4. Configure:
   - Product Name: `DatacapMobileTokenDemo`
   - Team: Your team
   - Organization Identifier: `com.datacapsystems`
   - Bundle Identifier: `com.datacapsystems.DatacapMobileTokenDemo`
   - Interface: Storyboard
   - Language: Swift
   - Use Core Data: No
   - Include Tests: No

### 2. Add Objective-C Support

1. Create new Objective-C file (AppDelegate.h/m)
2. Xcode will prompt to create bridging header - Accept
3. Configure bridging header path in Build Settings

### 3. Add Swift Files

Add these Swift files to the project:
- `ModernViewController.swift`
- `SettingsViewController.swift`
- `TransactionViewController.swift`
- `DatacapTokenService.swift`
- `GlassMorphismExtensions.swift`

### 4. Configure Storyboard

1. Open Main.storyboard
2. Delete default ViewController
3. Add new ViewController
4. Set class to `ModernViewController`
5. Set as Initial View Controller

### 5. Update Info.plist

Add these keys:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan payment cards</string>
<key>UILaunchStoryboardName</key>
<string>LaunchScreen</string>
<key>UIRequiredDeviceCapabilities</key>
<array>
    <string>armv7</string>
</array>
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
</array>
```

### 6. Add Assets

1. Add logo.png to Assets.xcassets
2. Set up AppIcon if desired
3. Configure LaunchScreen

## Building from Command Line

### Using xcodebuild

```bash
# Clean build folder
xcodebuild clean -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj

# Build for simulator
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  build

# Build for device (requires signing)
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -destination 'generic/platform=iOS' \
  build
```

### Using Build Script

```bash
# Make script executable
chmod +x build-and-install.sh

# Run interactive build
./build-and-install.sh
```

## Common Issues and Solutions

### 1. Code Signing Errors

**Issue**: "Signing for "DatacapMobileTokenDemo" requires a development team"

**Solution**:
```bash
# Open Xcode and select a team
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj

# Or use automatic signing
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -allowProvisioningUpdates \
  -allowProvisioningDeviceRegistration \
  build
```

### 2. Module 'DatacapMobileToken' not found

**Issue**: Swift can't find the Objective-C module

**Solution**:
1. Clean build folder: `⌘+Shift+K`
2. Check bridging header path in Build Settings
3. Ensure bridging header contains:
   ```objc
   #import "ViewController.h"
   ```

### 3. Minimum iOS Version

**Issue**: "The app's deployment target must be iOS 15.6 or later"

**Solution**:
1. Select project in navigator
2. Select target
3. General tab → Deployment Info → iOS 15.6

### 4. Swift Version Mismatch

**Issue**: "Use Legacy Swift Language Version"

**Solution**:
1. Build Settings → Swift Language Version → Swift 5
2. Clean and rebuild

## Testing the App

### Simulator Testing

1. Select iPhone 14 Pro or later simulator
2. Build and run (`⌘+R`)
3. Test features:
   - Tap "Get Secure Token"
   - Enter test card: 4111111111111111
   - Expiry: Any future date
   - CVV: 123

### Device Testing

1. Connect iPhone via USB
2. Trust computer on device
3. Select device in Xcode
4. Build and run
5. Trust developer certificate in Settings → General → Device Management

### Test Scenarios

1. **Token Generation**:
   - Demo mode (default)
   - Enter test cards
   - Verify token display

2. **Settings Configuration**:
   - Tap settings icon
   - Switch between Demo/Certification/Production
   - Enter API credentials

3. **Transaction Processing**:
   - Generate a token first
   - Tap transaction button (credit card icon)
   - Select saved token
   - Enter amount
   - Process transaction

## API Configuration

### Demo Mode (Default)
- No configuration needed
- Uses mock tokenization
- Instant responses

### Certification Mode
- Endpoint: `https://pay-cert.dcap.com/v2/`
- Requires test API key from Datacap
- Test environment

### Production Mode
- Endpoint: `https://pay.dcap.com/v2/`
- Requires production API key
- Live transactions

## Debugging

### Enable Debug Logging

Add to `AppDelegate.m`:
```objc
#ifdef DEBUG
    NSLog(@"Debug mode enabled");
#endif
```

### View Console Output

1. Xcode → View → Debug Area → Show Debug Area
2. Or press `⌘+Shift+Y`

### Common Debug Commands

```bash
# View device logs
xcrun simctl spawn booted log stream --predicate 'subsystem == "com.datacapsystems.DatacapMobileTokenDemo"'

# Reset simulator
xcrun simctl erase all

# List available simulators
xcrun simctl list devices
```

## Advanced Configuration

### Custom URL Schemes

Add to Info.plist for deep linking:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>datacaptoken</string>
        </array>
    </dict>
</array>
```

### Push Notifications (Future)

1. Enable Push Notifications capability
2. Add to Info.plist:
   ```xml
   <key>UIBackgroundModes</key>
   <array>
       <string>remote-notification</string>
   </array>
   ```

## Contributing

### Code Style

- Use Swift 5.0+ features
- Follow Apple's API Design Guidelines
- Minimal comments, self-documenting code
- Consistent indentation (4 spaces)

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature

# Make changes
git add .
git commit -m "feat: Add your feature"

# Push to remote
git push origin feature/your-feature
```

## Resources

- [Datacap API Documentation](https://docs.datacapsystems.com)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Swift Documentation](https://docs.swift.org)
- [Xcode Documentation](https://developer.apple.com/documentation/xcode)

## Support

For issues or questions:
- GitHub Issues: https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025/issues
- Email: support@datacapsystems.com
- Documentation: https://docs.datacapsystems.com

---

**Note**: This is a demo application showcasing Datacap's tokenization technology. For production use, ensure proper security measures and compliance with PCI standards.