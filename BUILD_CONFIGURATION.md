# Datacap MobileToken iOS - Build Configuration

This document contains all the necessary configuration details for building the Datacap MobileToken iOS demo app.

## Xcode Project Configuration

### General Settings

| Setting | Value |
|---------|--------|
| **Project Format** | Xcode 14.0-compatible |
| **Deployment Target** | iOS 15.6 |
| **Devices** | iPhone |
| **Display Name** | Datacap Token |
| **Bundle Identifier** | com.datacapsystems.DatacapMobileTokenDemo |
| **Version** | 1.0 |
| **Build** | 1 |

### Build Settings

#### Basic
- **Architectures**: Standard Architectures (arm64)
- **Valid Architectures**: arm64 arm64e
- **Build Active Architecture Only**: 
  - Debug: Yes
  - Release: No

#### Swift Compiler
- **Swift Language Version**: Swift 5
- **Optimization Level**:
  - Debug: None [-Onone]
  - Release: Optimize for Speed [-O]
- **Compilation Mode**: Whole Module (Release only)

#### Linking
- **Other Linker Flags**: -ObjC
- **Dead Code Stripping**: Yes
- **Enable Bitcode**: No

#### Search Paths
- **Framework Search Paths**: 
  ```
  $(inherited)
  $(PROJECT_DIR)
  ```
- **Header Search Paths**: 
  ```
  $(inherited)
  ```

#### Packaging
- **Product Name**: $(TARGET_NAME)
- **Product Bundle Identifier**: com.datacapsystems.DatacapMobileTokenDemo
- **Info.plist File**: DatacapMobileDemo/Info.plist

#### Code Signing
- **Code Signing Style**: Automatic
- **Development Team**: [Your Team ID]
- **Code Signing Identity**: 
  - Debug: Apple Development
  - Release: Apple Distribution
- **Provisioning Profile**: Automatic

#### Custom Build Settings
```
SWIFT_OBJC_BRIDGING_HEADER = DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h
CLANG_ENABLE_MODULES = YES
SWIFT_OPTIMIZATION_LEVEL = -Onone (Debug) / -O (Release)
ENABLE_TESTABILITY = YES (Debug only)
```

### Build Phases

1. **Target Dependencies**: None

2. **Compile Sources** (16 items):
   - AppDelegate.m
   - ViewController.m
   - DatacapTokenService.swift
   - GlassMorphismExtensions.swift
   - ModernViewController.swift
   - SettingsViewController.swift
   - TransactionViewController.swift
   - GeneratedAssetSymbols.swift

3. **Link Binary With Libraries**:
   - Foundation.framework
   - UIKit.framework
   - CoreGraphics.framework
   - Security.framework (for keychain if needed)

4. **Copy Bundle Resources**:
   - Main.storyboard
   - LaunchScreen.storyboard
   - Assets.xcassets
   - logo.png (if separate from assets)

### Scheme Configuration

#### DatacapMobileTokenDemo Scheme

**Build**:
- [✓] DatacapMobileTokenDemo

**Run**:
- Build Configuration: Debug
- Executable: DatacapMobileTokenDemo.app
- Debug executable: Yes
- Launch: Automatically
- GPU Frame Capture: Automatically
- Metal API Validation: Enabled

**Test**:
- Build Configuration: Debug
- Debug executable: Yes

**Profile**:
- Build Configuration: Release
- Executable: DatacapMobileTokenDemo.app

**Analyze**:
- Build Configuration: Debug

**Archive**:
- Build Configuration: Release
- Reveal Archive in Organizer: Yes

### Info.plist Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>Datacap Token</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to scan payment cards</string>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    <key>UIStatusBarStyle</key>
    <string>UIStatusBarStyleDarkContent</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UIUserInterfaceStyle</key>
    <string>Light</string>
</dict>
</plist>
```

### Bridging Header Configuration

**DatacapMobileDemo-Bridging-Header.h**:
```objc
//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "ViewController.h"
#import "AppDelegate.h"
```

## Build Commands

### Command Line Build

#### Debug Build for Simulator
```bash
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.0' \
  -derivedDataPath build \
  clean build
```

#### Release Build for Device
```bash
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -derivedDataPath build \
  clean build
```

#### Archive for App Store
```bash
xcodebuild -project DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/DatacapMobileTokenDemo.xcarchive \
  clean archive
```

#### Export IPA
```bash
xcodebuild -exportArchive \
  -archivePath build/DatacapMobileTokenDemo.xcarchive \
  -exportPath build/ipa \
  -exportOptionsPlist ExportOptions.plist
```

### ExportOptions.plist for App Store

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>[YOUR_TEAM_ID]</string>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
```

## Environment Variables

### Build Environment
```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk
```

### CI/CD Environment
```bash
# For GitHub Actions or other CI
export CODE_SIGN_IDENTITY="Apple Development"
export DEVELOPMENT_TEAM="YOUR_TEAM_ID"
export PROVISIONING_PROFILE_SPECIFIER=""
```

## Troubleshooting Build Issues

### Common Build Errors

1. **Module 'DatacapMobileToken' not found**
   - Clean build folder: `⌘+Shift+K`
   - Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
   - Check bridging header path

2. **Swift Compiler Error**
   - Verify Swift version in Build Settings
   - Check for syntax errors in Swift files
   - Ensure proper module imports

3. **Code Signing Failed**
   - Update provisioning profiles: `⌘+,` → Accounts → Download Manual Profiles
   - Check certificate validity
   - Ensure team is selected

4. **Linker Errors**
   - Check framework search paths
   - Verify all required frameworks are linked
   - Clean and rebuild

### Debug Build Settings

For debugging build issues, add these to Other Swift Flags:
```
-Xfrontend -debug-time-function-bodies
-Xfrontend -debug-time-compilation
```

## Performance Optimization

### Release Build Optimizations

1. **Swift Optimization**: Whole Module Optimization
2. **Strip Debug Symbols**: Yes
3. **Asset Catalog Compiler**: Optimize for Size
4. **Enable Testability**: No (Release only)

### Build Time Optimization

1. **Parallelize Build**: Yes
2. **Build Active Architecture Only**: Yes (Debug)
3. **Precompiled Headers**: Automatic

## Security Considerations

### App Transport Security

Already configured for HTTPS only. No exceptions needed.

### Code Signing

- Use automatic signing for development
- Use manual signing for App Store distribution
- Enable hardened runtime for notarization (macOS catalyst only)

## Notes

- The project uses both Objective-C and Swift with a bridging header
- No external dependencies (CocoaPods/Carthage/SPM)
- All frameworks are system frameworks
- Minimum deployment target is iOS 15.6 for modern Swift features
- The legacy DatacapMobileToken.xcframework is included but not used

This configuration has been tested with Xcode 15.0+ and iOS 17.0+ simulators.