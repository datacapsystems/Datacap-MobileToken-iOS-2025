# Datacap MobileToken iOS Library 🚀

<div align="center">
  <img src="DatacapMobileTokenDemo/DatacapMobileDemo/logo.png" alt="Datacap Logo" width="300"/>
  
  [![iOS](https://img.shields.io/badge/iOS-15.6+-black.svg)](https://www.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
  [![Xcode](https://img.shields.io/badge/Xcode-16.0+-blue.svg)](https://developer.apple.com/xcode/)
  [![License](https://img.shields.io/badge/License-Commercial-yellow.svg)](LICENSE)
</div>

## 🚀 Overview

This repository contains both a **production-ready iOS tokenization library** and a **demo application** showcasing Datacap's payment tokenization capabilities. The library provides secure payment card tokenization for iOS applications, perfect for developers integrating payment processing into their apps.

**Latest Update (v2.0)**: Completely refactored as a clean, reusable SDK with no mock functionality. The demo app now serves as a reference implementation for developers.

**Recent UI Improvements**:
- Enhanced help overlay with scrollable content and better readability
- Enlarged Generate Token button for better user experience
- Updated App Store positioning as developer tool
- Improved visual consistency across all UI elements

## 📁 Repository Structure

```
Datacap-MobileToken-iOS-2025/
├── DatacapTokenLibrary/        # 📦 Distributable library for integrators
│   ├── Sources/                # Core library code
│   ├── Example/                # Integration examples
│   └── README.md               # Library-specific documentation
├── DatacapMobileTokenDemo/     # 📱 Demo application
│   ├── DatacapMobileDemo/      # Demo app source code
│   └── *.xcodeproj             # Xcode project
└── Documentation/              # 📚 Additional docs
```

## 🎯 What's Included

### 1. DatacapTokenLibrary (For Integrators)

A clean, reusable library that integrators can add to their iOS apps:

```mermaid
graph TB
    subgraph "Integrator's App"
        APP[Their App] --> LIB[DatacapTokenLibrary]
        LIB --> UI[Card Input UI]
        LIB --> API[Datacap API]
    end
    
    subgraph "Token Flow"
        UI --> VAL[Validation]
        VAL --> TOK[Tokenization]
        TOK --> RES[Token Response]
    end
    
    APP -.-> RES
    
    style LIB fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
    style API fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
```

**Quick Integration:**
```swift
// Initialize with merchant's public key
let tokenService = DatacapTokenService(
    publicKey: "MERCHANT_PUBLIC_KEY",
    isCertification: true
)

// Request token
tokenService.requestToken(from: self)
```

### 2. Demo Application

A complete iOS app demonstrating the library in action:

```mermaid
graph LR
    subgraph "Demo App Structure"
        HOME[Home Screen] --> SETTINGS[API Settings]
        HOME --> TOKEN[Token Generation]
        TOKEN --> SUCCESS[Success Display]
        
        SETTINGS --> CERT{Certification Mode?}
        CERT -->|Yes| CERTAPI[Cert API]
        CERT -->|No| PRODAPI[Prod API]
    end
    
    style HOME fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style TOKEN fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
```

## 🏗️ Architecture

### Library Architecture

```mermaid
graph TB
    subgraph "Public API"
        DTS[DatacapTokenService]
        DEL[DatacapTokenServiceDelegate]
        TOK[DatacapToken]
        ERR[DatacapTokenError]
    end
    
    subgraph "Internal Components"
        DTVC[DatacapTokenViewController]
        CARD[Card Input UI]
        VAL[Validation Logic]
        NET[Network Layer]
    end
    
    subgraph "Integration Points"
        APP[Merchant's App]
        API[Datacap API]
    end
    
    APP --> DTS
    DTS --> DTVC
    DTVC --> CARD
    CARD --> VAL
    DTS --> NET
    NET --> API
    API --> TOK
    TOK --> DEL
    DEL --> APP
    
    style DTS fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style APP fill:#228b22,stroke:#fff,stroke-width:2px,color:#fff
    style API fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
```

### Token Generation Flow

```mermaid
sequenceDiagram
    participant User
    participant MerchantApp
    participant TokenLibrary
    participant CardUI
    participant DatacapAPI
    
    User->>MerchantApp: Initiate Payment
    MerchantApp->>TokenLibrary: requestToken()
    TokenLibrary->>CardUI: Present Input Screen
    User->>CardUI: Enter Card Details
    CardUI->>CardUI: Validate Input
    CardUI->>TokenLibrary: Card Data Collected
    TokenLibrary->>DatacapAPI: POST /tokenize
    DatacapAPI->>DatacapAPI: Generate Token
    DatacapAPI->>TokenLibrary: Token Response
    TokenLibrary->>MerchantApp: tokenRequestDidSucceed()
    MerchantApp->>MerchantApp: Process with Token
```

## 🎨 Key Features

### For Integrators (Library) - v2.0
- 🔐 **Production-Ready**: No mock data, real API integration only
- 📱 **Complete UI Package**: Pre-built card input with validation
- ✅ **Zero Dependencies**: Standalone library with no external requirements
- 🎯 **Simple Integration**: Initialize, present, receive token
- 🌐 **Dual Environment**: Certification (testing) and production modes
- 📦 **Multiple Distribution**: SPM, CocoaPods, or manual integration

### For Developers (Demo App)
- 🎨 **Reference Implementation**: See exactly how to integrate the SDK
- ⚙️ **API Configuration**: Test with your merchant credentials
- 💳 **Smart Card Detection**: Automatic BIN-based card identification
- 📅 **Native Date Picker**: iOS wheel-style expiration selection
- 🔄 **Real-time Formatting**: Dynamic card number formatting by type
- ❓ **Comprehensive Help System**: Scrollable overlay with SDK documentation, test cards, and code examples

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="docs/screenshots/1_Home_67.png" alt="Home Screen" width="250"/>
        <br><b>Home Screen</b>
      </td>
      <td align="center">
        <img src="docs/screenshots/4_Settings_67.png" alt="API Settings" width="250"/>
        <br><b>API Configuration</b>
      </td>
      <td align="center">
        <img src="docs/screenshots/2_Token_67.png" alt="Card Input" width="250"/>
        <br><b>Card Input UI</b>
      </td>
    </tr>
  </table>
</div>

## 🛠️ Installation

### For Integrators (Using the Library)

#### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/datacapsystems/DatacapTokenLibrary-iOS.git", from: "1.0.0")
]
```

#### CocoaPods
```ruby
pod 'DatacapTokenLibrary', '~> 1.0'
```

#### Manual Installation
1. Copy `DatacapTokenLibrary/Sources/` to your project
2. Add files to your target
3. Import and use

### For Developers (Running the Demo)

```bash
# Clone the repository
git clone git@github.com:datacapsystems/Datacap-MobileToken-iOS-2025.git
cd Datacap-MobileToken-iOS-2025

# Open in Xcode
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj

# Build and run (⌘+R)
```

## 💻 Integration Guide

### Basic Usage

```swift
import DatacapTokenLibrary

class PaymentViewController: UIViewController {
    
    let tokenService = DatacapTokenService(
        publicKey: "YOUR_MERCHANT_PUBLIC_KEY",
        isCertification: true  // false for production
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenService.delegate = self
    }
    
    @IBAction func addCardTapped() {
        tokenService.requestToken(from: self)
    }
}

extension PaymentViewController: DatacapTokenServiceDelegate {
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        // Success! Send token to your backend
        print("Token: \(token.token)")
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        // Handle error
        print("Error: \(error.localizedDescription)")
    }
    
    func tokenRequestDidCancel() {
        // User cancelled
    }
}
```

## 🔧 Configuration

### API Credentials

1. Get your merchant account at [dsidevportal.com](https://www.dsidevportal.com)
2. Obtain your public API key
3. Initialize the library with your key
4. Start with certification mode for testing

### Supported Card Types

| Card Type | Length | Starting Digits | CVV Length |
|-----------|--------|----------------|------------|
| Visa | 16 | 4 | 3 |
| Mastercard | 16 | 51-55, 2221-2720 | 3 |
| American Express | 15 | 34, 37 | 4 |
| Discover | 16 | 6011, 65, 644-649 | 3 |
| Diners Club | 14 | 36, 38, 300-305 | 3 |

## 💳 Testing

### Test Card Numbers

Use these in certification mode:

```
Visa:         4111111111111111  CVV: 123
Mastercard:   5555555555554444  CVV: 123
Amex:         378282246310005   CVV: 1234
Discover:     6011111111111117  CVV: 123
```

## 🔐 Security

- **No Card Storage**: Card data is never persisted
- **HTTPS Only**: All API calls use TLS encryption
- **PCI Compliant**: Follows all security best practices
- **Input Validation**: Real-time Luhn validation
- **Secure Entry**: CVV field is always masked

## 📚 Documentation

- [Library Integration Guide](DatacapTokenLibrary/README.md)
- [API Documentation](https://docs.datacapsystems.com)
- [Developer Portal](https://www.dsidevportal.com)
- [Support](mailto:support@datacapsystems.com)

## 🚀 Building & Deployment

### Build Library
```bash
cd DatacapTokenLibrary
swift build
```

### Build Demo App
```bash
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  build
```

## 📄 License

This project contains both commercial and demo components:
- **Library**: Commercial license (see [DatacapTokenLibrary/LICENSE](DatacapTokenLibrary/LICENSE))
- **Demo App**: MIT license for reference implementation

## 🤝 Support

For technical support and questions:
- Email: support@datacapsystems.com
- Documentation: https://docs.datacapsystems.com
- Issues: [GitHub Issues](https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025/issues)

---

<div align="center">
  <p>Built with ❤️ by <a href="https://datacapsystems.com">Datacap Systems</a></p>
  <p>© 2025 Datacap Systems, Inc. All rights reserved.</p>
</div>