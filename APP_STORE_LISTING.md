# App Store Listing - Datacap Token SDK Demo

## App Information

### App Name
**Datacap Token SDK Demo**

### Subtitle (30 characters max)
iOS Payment SDK Showcase

### Promotional Text (170 characters max)
Test Datacap's iOS tokenization SDK. Drop-in payment library with complete UI, real-time validation, and PCI compliance. Perfect for developers building payment features.

## App Description

### Primary Description (4000 characters max)

**Production-Ready iOS Payment SDK**

Datacap Token SDK Demo showcases our powerful iOS payment tokenization library, designed for developers who need to add secure payment processing to their applications. This demo app provides a complete reference implementation of our SDK, demonstrating best practices and integration patterns.

**What You Get with Datacap's iOS SDK:**

Our SDK transforms complex payment processing into just a few lines of code. The library includes pre-built UI components, handles all card validation, and manages secure API communication - allowing you to focus on building great apps instead of payment infrastructure.

**For iOS Developers:**

See exactly how to integrate payment tokenization into your app. This demo shows the complete implementation, from initialization to token callbacks. The included source code serves as a reference for your own integration.

**For Technical Evaluators:**

Evaluate our SDK's capabilities hands-on. Test the user experience, explore the API integration, and see how our library handles edge cases, validation, and error scenarios.

**SDK Features Demonstrated:**

• **Drop-In UI Components** - Pre-built card input interface with native iOS design

• **Smart Card Detection** - Automatic identification of Visa, Mastercard, Amex, Discover, and Diners

• **Real-Time Validation** - Luhn algorithm and format validation as users type

• **Complete API Integration** - Full tokenization flow with production-ready error handling

• **Dual Environment Support** - Switch between certification and production modes

• **iOS 26 Liquid Glass UI** - Beautiful glass morphism design that matches modern iOS aesthetics

• **Delegate Pattern** - Clean callbacks for token success, failure, and cancellation

• **Date Picker Integration** - Native iOS date selection for card expiration

• **Security Best Practices** - No card storage, secure API communication, PCI compliance

**Who Should Use This App:**

• **iOS Developers** - Building payment features for e-commerce, subscription, or marketplace apps
• **Mobile App Agencies** - Evaluating payment SDKs for client projects
• **Technical Architects** - Assessing integration complexity and user experience
• **Product Managers** - Understanding the payment flow and user interface
• **Existing Datacap Partners** - Testing SDK integration with your merchant credentials
• **FinTech Companies** - Exploring white-label payment solutions

**SDK Integration Example:**

```swift
// Initialize the SDK
let tokenService = DatacapTokenService(
    publicKey: "YOUR_MERCHANT_PUBLIC_KEY",
    isCertification: true
)

// Set delegate for callbacks
tokenService.delegate = self

// Present card input UI
tokenService.requestToken(from: self)

// Handle callbacks
func tokenRequestDidSucceed(_ token: DatacapToken) {
    // Use token for payment processing
}
```

**Testing Environments:**

**Certification Mode** - Safe sandbox environment for development and testing. Use test card numbers without processing real payments.

**Production Mode** - Live tokenization with your production API credentials. Generates real tokens for payment processing.

**What's Included in the SDK:**

• Complete source code for card input UI
• Network layer with retry logic
• Card validation algorithms  
• Secure API communication
• Error handling and user feedback
• Customizable UI components

**Security & Compliance:**

• PCI DSS compliant tokenization
• No sensitive card data stored on device
• TLS 1.2+ encrypted API communication
• Real-time Luhn validation
• Automatic BIN validation
• Secure keychain storage for API credentials

**SDK Distribution Options:**

• **Swift Package Manager** - Recommended for modern iOS projects
• **CocoaPods** - Traditional dependency management
• **Manual Integration** - Copy source files directly
• **GitHub Repository** - Full source code access

**Test Card Numbers (Certification Mode):**

• Visa: 4111 1111 1111 1111
• Mastercard: 5555 5555 5555 4444
• Amex: 3782 822463 10005
• Discover: 6011 1111 1111 1117

**Getting Started:**

**For Developers:**
1. Download the demo app
2. Explore the SDK implementation
3. Get API credentials from dsidevportal.com
4. Test in certification mode
5. Integrate SDK into your app

**For Businesses:**
1. See the payment flow in action
2. Test with your API credentials
3. Evaluate the user experience
4. Contact sales for integration support

**Resources:**

• **SDK Documentation**: docs.datacapsystems.com/ios-sdk
• **GitHub Repository**: github.com/datacapsystems/ios-sdk
• **Developer Portal**: dsidevportal.com  
• **Technical Support**: devsupport@datacapsystems.com
• **Sales**: sales@datacapsystems.com

Download now to see how easy payment integration can be with Datacap's iOS SDK!

### What's New (Version 2.0)

• Complete SDK demonstration app
• Clean, reusable tokenization library
• Removed mock functionality - real API only
• Simplified to focus on core tokenization
• Enhanced help documentation for developers
• Improved button styling and UI polish
• Production-ready code examples
• Library distribution via SPM and CocoaPods

## Keywords (100 characters total)

SDK,iOS,payment,tokenization,library,API,developer,swift,integration,datacap

## App Information

### Primary Category
Developer Tools

### Secondary Category
Finance

### Age Rating
4+ (No objectionable content)

### Copyright
© 2025 Datacap Systems, Inc.

### Privacy Policy URL
https://datacapsystems.com/privacy

### Support URL
https://docs.datacapsystems.com

## Screenshots Required

### iPhone 6.7" Display (1290 × 2796 pixels)
Required for iPhone 16 Pro Max, 15 Pro Max, 14 Pro Max

1. **Home Screen** - Show main screen with "Generate Token" button
2. **Card Entry** - Show card input form with smart formatting
3. **Token Success** - Display successful token generation
4. **Settings** - Show API configuration screen
5. **Help Screen** - Display SDK integration help overlay
6. **Date Picker** - Show expiration date selection

### iPhone 6.5" Display (1242 × 2688 pixels) or 6.7" Display
Required for iPhone 14 Plus, 13 Pro Max, 12 Pro Max, 11 Pro Max, XS Max

### iPhone 5.5" Display (1242 × 2208 pixels)
Required for iPhone 8 Plus, 7 Plus, 6s Plus

### iPad Pro 12.9" Display (2048 × 2732 pixels)
Required for iPad Pro 12.9-inch

### iPad Pro 11" Display (1668 × 2388 pixels)
Required for iPad Pro 11-inch

## App Icon Requirements

### App Store Icon
- 1024 × 1024 pixels
- No transparency
- No rounded corners (iOS applies them)
- PNG format
- sRGB or P3 color space

### Included Icon Sizes (for app bundle)
The following sizes are automatically generated by Xcode:

**iPhone App Icons:**
- 180 × 180 (60pt @3x) - iPhone App
- 120 × 120 (60pt @2x) - iPhone App
- 87 × 87 (29pt @3x) - Settings
- 58 × 58 (29pt @2x) - Settings
- 60 × 60 (20pt @3x) - Notifications
- 40 × 40 (20pt @2x) - Notifications

**iPad App Icons:**
- 167 × 167 (83.5pt @2x) - iPad Pro App
- 152 × 152 (76pt @2x) - iPad App
- 76 × 76 (76pt @1x) - iPad App
- 58 × 58 (29pt @2x) - Settings
- 29 × 29 (29pt @1x) - Settings
- 40 × 40 (20pt @2x) - Notifications
- 20 × 20 (20pt @1x) - Notifications

## App Preview Video (Optional but Recommended)

### Video Specifications
- 1920 × 1080 (16:9) or 1080 × 1920 (9:16)
- 15-30 seconds long
- .mov, .m4v, or .mp4 format
- 500 MB maximum

### Suggested Video Script
1. Show app launch with logo (2 sec)
2. Tap "Get Secure Token" (2 sec)
3. Enter card number - show auto-formatting (5 sec)
4. Select expiry date with picker (3 sec)
5. Generate token successfully (3 sec)
6. Show saved token in transaction screen (5 sec)
7. Process a transaction (5 sec)
8. End with Datacap logo (2 sec)

## Review Information

### Demo Account
Username: Not required
Password: Not required
Note: App works in demo mode by default. No login required.

### Notes for Reviewer
This is a developer demonstration app showcasing Datacap's iOS payment tokenization SDK. The app serves as a reference implementation for developers integrating our SDK into their applications. Real tokenization requires API credentials from dsidevportal.com. The app demonstrates proper SDK integration patterns and includes complete source code examples. All test card numbers are industry-standard test numbers.

### Contact Information
- Name: Datacap Systems Development Team
- Phone: +1 (215) 997-8989
- Email: appstore@datacapsystems.com

## Export Compliance

### Uses Encryption: Yes
- Only HTTPS/TLS for API communication
- Exempt from ERN (uses standard encryption)

### Content Rights
All content is owned by Datacap Systems, Inc.

### Advertising ID
Does not use IDFA

## Pricing

### Price
Free

### In-App Purchases
None

---

## Additional Notes for Asset Creation

### Creating Screenshots

1. **Use iPhone 16 Pro Max Simulator** for primary screenshots
2. **Clean Status Bar**: Use SimulatorStatusMagic or set time to 9:41 AM
3. **Consistent Content**: Use same test data across all screenshots
4. **Highlight Features**: Each screenshot should showcase a different feature
5. **Add Captions**: Consider adding text overlays to explain features

### Screenshot Checklist
- [ ] Remove any personal or sensitive data
- [ ] Ensure consistent time (9:41 AM)
- [ ] Full battery and cellular bars
- [ ] No notification badges
- [ ] Clean, professional appearance
- [ ] Show actual app functionality

### Creating App Icon

The app icon should:
- Reflect the Datacap brand (red #941a25)
- Include a credit card or lock symbol
- Be simple and recognizable at small sizes
- Work on both light and dark backgrounds
- Not include text (except possibly "DC" monogram)

### Localization

Consider providing descriptions in:
- English (Primary)
- Spanish
- French
- German
- Japanese
- Simplified Chinese

This will significantly increase your app's reach in international markets.