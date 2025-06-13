# CLAUDE.md - AI Development Assistant Guide

This file contains important information for AI assistants (like Claude) working on the Datacap Token iOS project.

## Project Overview

**Project Type**: iOS Mobile Application  
**Languages**: Swift 5.0+ and Objective-C  
**Framework**: Datacap MobileToken SDK  
**UI Design**: iOS 26 Liquid Glass (Glass Morphism)  
**Target**: App Store Ready Demo Application  

## Key Development Guidelines

### 1. Code Style and Standards

- **Swift**: Use modern Swift 5.0+ features, optionals, and type safety
- **Objective-C**: Maintain compatibility with existing framework
- **UI**: Build programmatically using UIKit, avoid Storyboard for new features
- **Naming**: Follow Apple's API Design Guidelines
- **Comments**: Minimal inline comments, code should be self-documenting

### 2. Design System

#### Colors (from Datacap brand)
```swift
Primary Red: #941a25
Dark Gray: #54595f  
Blue Gray: #778799
Near Black: #231f20
Light Background: #f6f9fc
```

#### Glass Morphism Parameters
- Blur intensity: 0.85-0.95
- Corner radius: 16-24px
- Shadow opacity: 0.05-0.20
- Border: 0.5px @ 20% opacity white

### 3. Project Structure

```
DatacapMobileTokenDemo/
├── DatacapMobileDemo/
│   ├── AppDelegate.m/h (Objective-C app lifecycle)
│   ├── ViewController.m/h (Legacy Objective-C)
│   ├── ModernViewController.swift (Main UI)
│   ├── GlassMorphismExtensions.swift (UI extensions)
│   ├── DatacapMobileDemo-Bridging-Header.h
│   └── Assets.xcassets/
├── DatacapMobileToken.xcframework/ (SDK)
└── DatacapMobileTokenDemo.xcodeproj/
```

### 4. Key Implementation Details

#### Swift/Objective-C Bridge
```objc
// DatacapMobileDemo-Bridging-Header.h
#import <DatacapMobileToken/DatacapMobileToken.h>
#import "ViewController.h"
```

#### Main View Controller
- `ModernViewController.swift` - Primary UI implementation
- Programmatic UI only, no Storyboard elements
- Implements `DatacapTokenDelegate` protocol

#### UI Extensions
- `GlassMorphismExtensions.swift` - Reusable glass effects
- `UIView.applyLiquidGlass()` - Main glass morphism method
- `UIButton.applyDatacapGlassStyle()` - Branded button styling

### 5. Testing Commands

```bash
# Lint Swift code
swiftlint

# Format Swift code  
swiftformat .

# Build for testing
xcodebuild -project DatacapMobileTokenDemo.xcodeproj -scheme DatacapMobileTokenDemo -destination 'platform=iOS Simulator,name=iPhone 14 Pro' build

# Run tests
xcodebuild test -project DatacapMobileTokenDemo.xcodeproj -scheme DatacapMobileTokenDemo -destination 'platform=iOS Simulator,name=iPhone 14 Pro'
```

### 6. Common Tasks

#### Add New UI Component
1. Create extension in `GlassMorphismExtensions.swift`
2. Apply glass morphism effects consistently
3. Use Datacap color palette
4. Add haptic feedback for interactions

#### Update Token Integration
1. Modify in `ModernViewController.swift`
2. Implement delegate methods properly
3. Handle all error cases
4. Show appropriate UI feedback

#### Prepare for App Store
1. Update version in project settings
2. Verify Info.plist privacy descriptions
3. Test on multiple devices
4. Create screenshots at required sizes
5. Archive with Release configuration

### 7. Important Files to Check

When making changes, always verify:
- `Info.plist` - App configuration and privacy settings
- `ModernViewController.swift` - Main functionality
- `GlassMorphismExtensions.swift` - UI consistency
- `DatacapMobileDemo-Bridging-Header.h` - Framework imports

### 8. Security Considerations

- Never commit real API keys or credentials
- Use test/demo keys in code examples
- Always use `isCertification: true` for demos
- No logging of sensitive payment data

### 9. Performance Guidelines

- Minimize view hierarchy depth
- Cache glass morphism layers
- Use lazy loading for heavy UI elements
- Profile with Instruments before release

### 10. Git Workflow

```bash
# Before committing
swiftlint
swiftformat .

# Commit message format
git commit -m "feat: Add glass morphism to payment form

- Implement iOS 26 Liquid Glass design
- Add shimmer animations
- Update color scheme to match Datacap brand"

# Always test before pushing
xcodebuild -project DatacapMobileTokenDemo.xcodeproj -scheme DatacapMobileTokenDemo clean build
```

### 11. Troubleshooting

#### Common Issues
1. **Bridging header not found**: Check build settings for correct path
2. **Framework not loading**: Verify embed settings in project
3. **UI not rendering**: Check iOS deployment target (13.0+)
4. **Glass effects missing**: Verify blur view insertion order

#### Debug Commands
```bash
# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData

# Reset simulator
xcrun simctl erase all

# Check Swift version
swift --version
```

### 12. Future Enhancements

Consider these for future updates:
- SwiftUI migration for iOS 17+
- Dynamic Island support
- Apple Pay integration
- Biometric authentication
- Accessibility improvements
- Dark mode refinements

### 13. Resources

- [Datacap API Docs](https://docs.datacapsystems.com)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Swift Style Guide](https://google.github.io/swift/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## Notes for AI Assistants

1. **Always test code changes** before committing
2. **Maintain consistent UI** using the glass morphism extensions
3. **Follow existing patterns** in the codebase
4. **Consider App Store requirements** in all changes
5. **Keep security as top priority** for payment handling

Remember: This is a demo app showcasing Datacap's technology. It should be impressive, functional, and ready for App Store submission while maintaining enterprise-grade code quality.