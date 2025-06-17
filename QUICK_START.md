# Quick Start Guide - Datacap MobileToken iOS

Get up and running in under 5 minutes!

## 🚀 Fastest Setup (3 Steps)

### 1. Clone the Repository
```bash
git clone https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025.git
cd Datacap-MobileToken-iOS-2025
```

### 2. Open in Xcode
```bash
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
```

### 3. Build and Run
- Press `⌘+R` or click the ▶️ button
- Select iPhone 14 Pro or later simulator
- Done! 🎉

## 📱 First Test

1. **Tap "Get Secure Token"**
2. **Enter Test Card:**
   - Number: `4111111111111111`
   - Expiry: Tap field and select any future date
   - CVV: `123`
3. **Tap Submit**
4. **See the generated token!**

## ⚙️ Key Features to Try

### 1. Help (Question Mark Icon)
- Learn about the app's features
- Understand the three operation modes
- View detailed explanations of each feature

### 2. Settings (Gear Icon)
- Switch between Demo/Certification/Production modes
- Configure API credentials
- Save settings

### 3. Transactions (Credit Card Icon)
- Appears after generating a token
- Select saved token
- Enter amount (e.g., $10.00)
- Process transaction

### 3. Card Detection
Try different card types:
- Visa: `4111111111111111`
- Mastercard: `5555555555554444`
- Amex: `378282246310005` (Note: 4-digit CVV)

## 🛠 Common Setup Issues

### "Signing Requires Development Team"
1. Click on project name in Xcode
2. Select "DatacapMobileTokenDemo" target
3. Go to "Signing & Capabilities"
4. Check "Automatically manage signing"
5. Select your Apple ID from Team dropdown

### "No Simulator Found"
1. Xcode → Settings → Platforms
2. Click "+" to add iOS simulators
3. Download iOS 17.0+ simulator

### Build Fails
```bash
# Clean and rebuild
rm -rf ~/Library/Developer/Xcode/DerivedData
# Then rebuild in Xcode
```

## 📁 Project Structure

```
DatacapMobileTokenDemo/
├── ModernViewController.swift      # Main screen
├── SettingsViewController.swift    # API settings
├── TransactionViewController.swift # Payment processing
├── DatacapTokenService.swift      # Token generation
└── GlassMorphismExtensions.swift  # UI styling
```

## 🔑 API Modes

### Demo Mode (Default)
- No configuration needed
- Generates mock tokens instantly
- Perfect for UI/UX testing

### Certification Mode
- Test environment
- Endpoint: `https://pay-cert.dcap.com/v2/`
- Requires test API key

### Production Mode
- Live transactions
- Endpoint: `https://pay.dcap.com/v2/`
- Requires production credentials

## 📝 Next Steps

1. **Read Full Documentation**
   - [PROJECT_SETUP.md](PROJECT_SETUP.md) - Detailed setup
   - [README.md](README.md) - Complete overview
   - [CLAUDE.md](CLAUDE.md) - Developer guide

2. **Customize the App**
   - Modify colors in `UIColor.Datacap` extensions
   - Update logo in `Assets.xcassets`
   - Adjust glass morphism effects

3. **Test Transactions**
   - Generate multiple tokens
   - Try different amounts
   - Test error scenarios

## 🆘 Need Help?

- **Build Issues**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **API Questions**: Check [Datacap Docs](https://docs.datacapsystems.com)
- **Report Bugs**: [GitHub Issues](https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025/issues)

---

**Happy Coding!** 🎉

Built with ❤️ by Datacap Systems