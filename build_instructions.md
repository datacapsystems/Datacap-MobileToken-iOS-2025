# Build Instructions for Datacap Token iOS App

## Prerequisites

1. **Xcode 15.0 or later** (for iOS 26 support)
2. **Apple Developer Account** (for App Store submission)
3. **Valid provisioning profiles and certificates**

## Project Setup

1. **Open the Project**
   ```bash
   cd /Users/edcrotty/Documents/MobileToken-iOS-Datacap
   open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
   ```

2. **Configure Signing**
   - Select the project in Xcode
   - Go to "Signing & Capabilities" tab
   - Select your development team
   - Enable "Automatically manage signing"

3. **Set Swift Bridging Header**
   - In Build Settings, search for "Objective-C Bridging Header"
   - Set it to: `DatacapMobileDemo/DatacapMobileDemo-Bridging-Header.h`

4. **Configure Build Settings**
   - Set "iOS Deployment Target" to 13.0
   - Ensure "Build Active Architecture Only" is NO for Release
   - Set "Valid Architectures" to arm64 armv7

## Building for Testing

1. **Select Target Device**
   - Choose a simulator or connected device
   - For best results, test on iPhone 14 Pro or newer

2. **Build and Run**
   - Press ⌘+R or click the Play button
   - The app should launch with the modern glass morphism UI

## Building for App Store

1. **Update Version and Build Number**
   - Select project > General tab
   - Update Version (e.g., 1.1.0)
   - Update Build (increment for each submission)

2. **Select Generic iOS Device**
   - From the scheme selector, choose "Any iOS Device (arm64)"

3. **Archive the App**
   - Product menu → Archive
   - Wait for the archive to complete

4. **Validate and Upload**
   - In Organizer, select your archive
   - Click "Validate App" and fix any issues
   - Click "Distribute App" → App Store Connect → Upload

## Troubleshooting

### Swift Compilation Errors
- Ensure the bridging header path is correct
- Clean build folder: ⌘+Shift+K
- Delete derived data if needed

### Framework Not Found
- Verify DatacapMobileToken.xcframework is properly linked
- Check "Embed & Sign" is selected for the framework

### UI Not Showing Correctly
- Ensure you're testing on iOS 13.0+
- Check that Main.storyboard uses ModernViewController

### Archive Issues
- Verify all assets are included
- Check code signing settings
- Ensure no development-only code is included

## Testing Checklist

- [ ] App launches without crashes
- [ ] Glass morphism effects render correctly
- [ ] Token generation works properly
- [ ] All animations are smooth
- [ ] Error handling works as expected
- [ ] App works in both light and dark mode
- [ ] No memory leaks (check with Instruments)

## Notes

- The app uses a test public key for demonstration
- Remove `isCertification: true` for production use
- All payment data in demo mode is simulated
- The glass morphism effects require iOS 13.0+

## Support

For technical support with the SDK:
- Visit: https://datacapsystems.com/support
- GitHub Issues: https://github.com/datacapsystems/MobileToken-iOS/issues

For app development questions:
- Review the ModernViewController.swift implementation
- Check GlassMorphismExtensions.swift for UI customization