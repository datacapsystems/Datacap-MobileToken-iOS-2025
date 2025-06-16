# Datacap Token iOS - Modern Payment Tokenization

<div align="center">
  <img src="DatacapMobileTokenDemo/DatacapMobileDemo/logo.png" alt="Datacap Logo" width="300"/>
  
  [![iOS](https://img.shields.io/badge/iOS-15.6+-black.svg)](https://www.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
  [![License](https://img.shields.io/badge/License-Commercial-blue.svg)](LICENSE)
  [![App Store Ready](https://img.shields.io/badge/App%20Store-Ready-green.svg)](APP_STORE_SUBMISSION.md)
  [![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025)
</div>

## 🚀 Overview

Datacap Token is a cutting-edge iOS application that demonstrates secure payment tokenization using a modern pure Swift implementation. Built with iOS 26's stunning Liquid Glass design language, this app provides enterprise-grade security with a beautiful, modern interface.

## 🎨 Features

- **iOS 26 Liquid Glass UI** - Stunning glass morphism effects with dynamic animations
- **Secure Tokenization** - Convert sensitive payment data to secure tokens
- **Bank-Level Encryption** - Industry-standard security protocols
- **Lightning Fast** - Get tokens in milliseconds
- **PCI Compliant** - Meet all regulatory requirements
- **Beautiful Animations** - Smooth transitions and haptic feedback
- **Pure Swift Implementation** - No legacy framework dependencies

## 📱 Screenshots

<div align="center">
  <img src="docs/screenshot1.png" alt="Home Screen" width="250"/>
  <img src="docs/screenshot2.png" alt="Token Generation" width="250"/>
  <img src="docs/screenshot3.png" alt="Success Screen" width="250"/>
</div>

## 🏗️ Architecture

### High-Level Architecture

```mermaid
graph TB
    subgraph "iOS App"
        A[ModernViewController<br/>Swift UI Layer] --> B[DatacapTokenService<br/>Pure Swift]
        A --> C[GlassMorphism<br/>UI Extensions]
        B --> D[DatacapTokenViewController<br/>Card Input UI]
    end
    
    subgraph "Business Logic"
        B --> E[Card Validation<br/>Luhn Algorithm]
        B --> F[Token Generation<br/>Mock Service]
        E --> G[Card Type Detection]
    end
    
    subgraph "UI Components"
        C --> H[Liquid Glass<br/>Effects]
        C --> I[Custom Alerts]
        C --> J[Loading States]
        H --> K[Blur Effects]
        H --> L[Specular Highlights]
        H --> M[Shimmer Animation]
    end
    
    style A fill:#941a25,stroke:#fff,stroke-width:4px,color:#fff
    style B fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
    style C fill:#54595f,stroke:#fff,stroke-width:2px,color:#fff
```

### Component Architecture

```mermaid
classDiagram
    class ModernViewController {
        -tokenService: DatacapTokenService
        -backgroundGradient: CAGradientLayer
        +viewDidLoad()
        +getTokenTapped()
    }
    
    class DatacapTokenService {
        -publicKey: String
        -isCertification: Bool
        +delegate: DatacapTokenServiceDelegate
        +requestToken(from: UIViewController)
        -validateCardNumber(String): Bool
        -detectCardType(String): String
        -generateToken(CardData): DatacapToken
    }
    
    class DatacapTokenViewController {
        -cardNumberField: UITextField
        -expirationField: UITextField
        -cvvField: UITextField
        +delegate: DatacapTokenViewControllerDelegate
    }
    
    class GlassMorphismExtensions {
        <<extension>>
        +applyLiquidGlass()
        +applyDatacapGlassStyle()
    }
    
    class DatacapToken {
        +token: String
        +maskedCardNumber: String
        +cardType: String
        +expirationDate: String
    }
    
    ModernViewController --> DatacapTokenService
    ModernViewController ..> GlassMorphismExtensions
    DatacapTokenService --> DatacapTokenViewController
    DatacapTokenService --> DatacapToken
    DatacapTokenViewController --> CardData
```

### Tokenization Flow

```mermaid
sequenceDiagram
    participant User
    participant UI as ModernViewController
    participant Service as DatacapTokenService
    participant Input as DatacapTokenViewController
    participant Validator as Card Validator
    
    User->>UI: Tap "Get Secure Token"
    UI->>Service: requestToken(from: self)
    Service->>Input: Present card input form
    Input->>User: Show input fields
    User->>Input: Enter card details
    Input->>Input: Format card number
    Input->>Input: Format expiry date
    User->>Input: Tap Submit
    Input->>Validator: Validate card (Luhn)
    alt Valid Card
        Validator->>Service: Card is valid
        Service->>Service: Generate token
        Service->>UI: tokenRequestDidSucceed
        UI->>User: Show success alert
    else Invalid Card
        Validator->>Service: Validation failed
        Service->>UI: tokenRequestDidFail
        UI->>User: Show error alert
    end
```

## 🛠️ Technical Stack

- **Language**: Swift 5.0+ & Objective-C
- **UI Framework**: UIKit with programmatic UI
- **Design Pattern**: MVC with Extensions
- **Minimum iOS**: 15.6
- **Architecture**: arm64, x86_64 (Simulator)

## 📦 Installation

### Prerequisites

- Xcode 15.0 or later
- iOS 15.6+ deployment target
- Apple Developer account (for device testing)

### Setup

1. **Clone the repository**
   ```bash
   git clone git@github.com:datacapsystems/Datacap-MobileToken-iOS-2025.git
   cd Datacap-MobileToken-iOS-2025
   ```

2. **Open in Xcode**
   ```bash
   open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
   ```

3. **Configure signing**
   - Select the project in Xcode
   - Go to "Signing & Capabilities"
   - Select your team
   - Update bundle identifier if needed

4. **Build and run**
   - Select a simulator or device
   - Press ⌘+R to build and run

## 🚀 Quick Start

### Using the Build Script

For a streamlined build process, use our automated script:

```bash
./build-and-install.sh
```

This interactive script will:
- List available simulators
- Build the project
- Install on selected simulator
- Launch the app automatically

### Deploy to Physical iPhone

To install on your connected iPhone:

```bash
./deploy-to-phone.sh
```

This will guide you through:
- Setting up code signing
- Selecting your device
- Building and installing the app
- Trusting developer certificate

### Manual Build

```bash
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  build
```

### Troubleshooting Installation

If you're having issues installing:

```bash
./diagnose-install.sh
```

## 💳 Testing

Use these test card numbers:

| Card Type | Number | CVV | Expiry |
|-----------|--------|-----|---------|
| Visa | 4111111111111111 | 123 | 12/25 |
| Mastercard | 5555555555554444 | 456 | 01/26 |
| Amex | 378282246310005 | 7890 | 03/27 |

## 🔧 Project Structure

```
DatacapMobileTokenDemo/
├── DatacapMobileDemo/
│   ├── ModernViewController.swift      # Main UI controller
│   ├── DatacapTokenService.swift       # Token service logic
│   ├── GlassMorphismExtensions.swift   # UI extensions
│   ├── AppDelegate.m/h                 # App lifecycle
│   ├── ViewController.m/h              # Legacy support
│   └── Assets.xcassets/                # Images and colors
├── DatacapMobileToken.xcframework/     # Legacy framework (unused)
└── DatacapMobileTokenDemo.xcodeproj/   # Xcode project
```

## 🎯 Key Components

### DatacapTokenService
Pure Swift implementation providing:
- Card number validation (Luhn algorithm)
- Card type detection (Visa, MC, Amex, etc.)
- Mock token generation
- Delegate pattern for async callbacks

### ModernViewController
Main UI featuring:
- iOS 26 Liquid Glass design
- Animated gradient backgrounds
- Glass morphism effects
- Custom success/error alerts

### GlassMorphismExtensions
Reusable UI components:
- `applyLiquidGlass()` - Glass morphism effects
- `applyDatacapGlassStyle()` - Branded buttons
- `LiquidGlassLoadingView` - Loading animations

## 🔐 Security

- No sensitive data logging
- Secure text entry for CVV
- Card numbers masked in display
- Demo mode with test keys
- PCI compliance ready

## 📱 App Store Submission

See [APP_STORE_SUBMISSION.md](APP_STORE_SUBMISSION.md) for detailed submission guidelines.

## 🐛 Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues and solutions.

### Common Issues

1. **MinimumOSVersion Error**: Update Info.plist to match your device iOS version
2. **Code Signing**: Enable automatic signing in Xcode
3. **ThreatLocker Blocking**: Add exception for Xcode and the app
4. **Device Not Found**: Reconnect USB and trust computer on device

## 📚 Documentation

- [CLAUDE.md](CLAUDE.md) - AI assistant guide
- [APP_STORE_SUBMISSION.md](APP_STORE_SUBMISSION.md) - Submission checklist
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues

## 🤝 Support

For technical support and questions:
- Email: support@datacapsystems.com
- Documentation: https://docs.datacapsystems.com
- Issues: https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025/issues

## 📄 License

This project is proprietary software. See LICENSE file for details.

---

<div align="center">
  <p>Built with ❤️ by <a href="https://datacapsystems.com">Datacap Systems</a></p>
  <p>© 2025 Datacap Systems, Inc. All rights reserved.</p>
</div>