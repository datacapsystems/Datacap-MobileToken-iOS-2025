# Datacap Mobile Token for iOS

<div align="center">
  <img src="DatacapMobileTokenDemo/DatacapMobileDemo/logo.png" alt="Datacap Logo" width="300"/>
  
  [![iOS](https://img.shields.io/badge/iOS-15.6+-black.svg)](https://www.apple.com/ios/)
  [![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
  [![Xcode](https://img.shields.io/badge/Xcode-16.0+-blue.svg)](https://developer.apple.com/xcode/)
  [![API](https://img.shields.io/badge/API-REST-green.svg)](https://docs.datacapsystems.com)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
</div>

## Overview

Enterprise payment tokenization for iOS. Strengthen PCI compliance with Datacap's cross-platform tokenization solution. This production-ready app and SDK enable merchants and ISVs to integrate secure payment tokenization with support for both certification and production environments.

### Key Benefits

- **Enterprise Security**: PCI compliance ready for production use
- **Processor Independence**: Switch payment processors without retokenization
- **P2PE Validated**: Point-to-point encryption certified solutions
- **Cross-Platform**: Use tokens across all sales channels
- **35+ Years of Innovation**: Datacap's proven payment technology

### Latest Updates (v1.3)

- **Glass Morphism Design**: Stunning iOS 26 liquid glass effects throughout
- **iPad Optimization**: Full-screen layout with feature cards and dynamic typography
- **Dark Mode Support**: Complete light/dark mode adaptation for all screens
- **Consistent UI**: Unified glass morphism across iPhone and iPad
- **Enhanced Typography**: Larger, clearer fonts for better readability
- **Dual Environment Support**: Separate API keys for certification and production
- **Floating Navigation**: Modern menu pill for quick access to settings and help
- **Professional Polish**: Enterprise-ready interface with attention to detail

## Screenshots

### iPhone Interface
<div align="center">
  <img src="docs/screenshots/iphone-home-light.png" alt="iPhone Home" width="250"/>
  <img src="docs/screenshots/iphone-card-entry.png" alt="iPhone Card Entry" width="250"/>
  <img src="docs/screenshots/iphone-settings.png" alt="iPhone Settings" width="250"/>
</div>

### iPad Interface
<div align="center">
  <img src="docs/screenshots/ipad-home-light.png" alt="iPad Home" width="350"/>
  <img src="docs/screenshots/ipad-settings.png" alt="iPad Settings" width="350"/>
</div>

### Dark Mode Support
<div align="center">
  <img src="docs/screenshots/iphone-dark-mode.png" alt="iPhone Dark Mode" width="250"/>
  <img src="docs/screenshots/ipad-dark-mode.png" alt="iPad Dark Mode" width="350"/>
</div>

## Repository Structure

```
Datacap-MobileToken-iOS-2025/
├── DatacapTokenLibrary/        # Ready-to-use SDK for integrators
│   ├── Sources/                # DatacapTokenService.swift
│   └── README.md               # Quick integration guide
├── DatacapMobileTokenDemo/     # Reference implementation
│   ├── DatacapMobileDemo/      # Demo app with UI examples
│   └── *.xcodeproj             # Xcode project
├── INTEGRATION_GUIDE.md        # Detailed integration instructions
├── LICENSE                     # MIT License
└── CLAUDE.md                   # Developer reference guide
```

## Architecture

### Complete System Architecture

```mermaid
graph TB
    subgraph "iOS App Layer"
        UI[User Interface]
        UI --> |iPhone| IPHONE[Compact Layout]
        UI --> |iPad| IPAD[Feature Cards Layout]
        
        IPHONE --> DARK_I[Dark Mode]
        IPHONE --> LIGHT_I[Light Mode]
        IPAD --> DARK_P[Dark Mode]
        IPAD --> LIGHT_P[Light Mode]
    end
    
    subgraph "SDK Layer"
        TOKEN[DatacapTokenService]
        TOKEN --> VALIDATE[Card Validation]
        TOKEN --> FORMAT[Auto-Formatting]
        TOKEN --> NETWORK[Network Layer]
    end
    
    subgraph "API Layer"
        NETWORK --> |Cert Mode| CERT_API[token-cert.dcap.com]
        NETWORK --> |Prod Mode| PROD_API[token.dcap.com]
        CERT_API --> RESPONSE[Token Response]
        PROD_API --> RESPONSE
    end
    
    subgraph "Security Layer"
        RESPONSE --> SECURE[Secure Storage]
        SECURE --> PCI[PCI Compliance]
        SECURE --> ENCRYPT[TLS Encryption]
    end
    
    UI --> TOKEN
    
    style UI fill:#2a2a2a,stroke:#fff,stroke-width:2px,color:#fff
    style TOKEN fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style CERT_API fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
    style PROD_API fill:#228b22,stroke:#fff,stroke-width:2px,color:#fff
    style PCI fill:#54595f,stroke:#fff,stroke-width:2px,color:#fff
```

### SDK Architecture

```mermaid
graph TB
    subgraph YourApp["Your iOS App"]
        APP[Your App] --> SDK[DatacapTokenService]
        SDK --> |"Option 1"| UI[Built-in Card UI]
        SDK --> |"Option 2"| CUSTOM[Your Custom UI]
    end
    
    subgraph DatacapAPI["Datacap API"]
        SDK --> AUTH[Authorization Header]
        AUTH --> |"POST"| OTU["/v1/otu Endpoint"]
        OTU --> TOKEN[Secure Token]
    end
    
    subgraph Response["Response"]
        TOKEN --> |"Success"| RESP["Token + Card Details"]
        TOKEN --> |"Error"| ERR[Error Message]
    end
    
    style SDK fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style OTU fill:#228b22,stroke:#fff,stroke-width:2px,color:#fff
    style APP fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
```

### API Integration Flow

```mermaid
sequenceDiagram
    participant App as iOS App
    participant SDK as DatacapTokenService
    participant API as Datacap API
    participant Server as Your Server
    
    App->>SDK: Initialize with API Key
    App->>SDK: requestToken() or generateTokenDirect()
    SDK->>SDK: Validate Card (Luhn)
    SDK->>API: POST /v1/otu<br/>Auth: Token Key<br/>Body: Card Data
    API-->>SDK: Token Response
    SDK-->>App: DatacapToken object
    App->>Server: Send token for payment processing
    Server->>Server: Process payment with token
```

### Dual Environment Support

```mermaid
graph LR
    subgraph KeyMgmt["API Key Management"]
        CERT[Certification Key] --> CERTENV["Cert Environment<br/>token-cert.dcap.com"]
        PROD[Production Key] --> PRODENV["Prod Environment<br/>token.dcap.com"]
    end
    
    subgraph Storage["Settings Storage"]
        CERT -.-> CS[DatacapCertificationPublicKey]
        PROD -.-> PS[DatacapProductionPublicKey]
        MODE[Current Mode] --> ACTIVE[Active Environment]
    end
    
    style CERT fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
    style PROD fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style CERTENV fill:#54595f,stroke:#fff,stroke-width:2px,color:#fff
    style PRODENV fill:#228b22,stroke:#fff,stroke-width:2px,color:#fff
```

### iOS 26 UI Architecture

```mermaid
graph TB
    subgraph "Floating Menu Pill"
        MODE[Mode Toggle<br/>Cert/Prod]
        SETTINGS[Settings<br/>Icon]
        HELP[Help<br/>Icon]
    end
    
    subgraph "Main Screen"
        CARD[Card Entry Form]
        TOKEN[Generate Token]
        RESULT[Token Display]
    end
    
    subgraph "Overlays"
        SVIEW[Settings View]
        HVIEW[Help View]
    end
    
    MODE --> CARD
    SETTINGS --> SVIEW
    HELP --> HVIEW
    TOKEN --> RESULT
    
    style MODE fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style CARD fill:#2a2a2a,stroke:#444,stroke-width:1px,color:#fff
```

### iPad Layout Architecture

```mermaid
graph TB
    subgraph "iPad Optimizations"
        DETECT[Device Detection] --> LAYOUT[Dynamic Layout]
        LAYOUT --> CONTAINER[800pt Container]
        LAYOUT --> TYPOGRAPHY[48pt Titles]
        LAYOUT --> CARDS[Feature Cards]
        
        subgraph "Feature Cards"
            SEC[Enterprise Security<br/>PCI DSS Level 1]
            PROC[Instant Processing<br/>Sub-second Response]
            ENV[Dual Environment<br/>Cert & Production]
        end
        
        CARDS --> SEC
        CARDS --> PROC
        CARDS --> ENV
    end
    
    style DETECT fill:#54595f,stroke:#fff,stroke-width:2px,color:#fff
    style TYPOGRAPHY fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style CARDS fill:#228b22,stroke:#fff,stroke-width:2px,color:#fff
```

### Dark Mode Architecture

```mermaid
graph LR
    subgraph "Appearance Detection"
        TRAIT[Trait Collection] --> DETECT{Light or Dark?}
        DETECT -->|Light Mode| LIGHT[Light Colors]
        DETECT -->|Dark Mode| DARK[Dark Colors]
    end
    
    subgraph "Dynamic Color System"
        LIGHT --> BG_L[Light Background<br/>#f6f9fc]
        LIGHT --> TEXT_L[Dark Text<br/>#231f20]
        LIGHT --> FORM_L[White Forms]
        
        DARK --> BG_D[Dark Background<br/>#1c1c1e]
        DARK --> TEXT_D[Light Text<br/>#f0f0f2]
        DARK --> FORM_D[Gray Forms<br/>#2c2c2e]
    end
    
    subgraph "UI Components"
        FORM_L --> UI[Adaptive UI]
        FORM_D --> UI
        UI --> GLASS[Glass Morphism]
        UI --> CONTRAST[High Contrast]
        UI --> ACCESS[Accessibility]
    end
    
    style TRAIT fill:#778799,stroke:#fff,stroke-width:2px,color:#fff
    style LIGHT fill:#f6f9fc,stroke:#333,stroke-width:2px,color:#333
    style DARK fill:#1c1c1e,stroke:#fff,stroke-width:2px,color:#fff
    style UI fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
```

## Quick Start

### 1. Copy the SDK
```bash
cp DatacapTokenLibrary/Sources/DatacapTokenService.swift YourProject/
```

### 2. Initialize Service
```swift
import UIKit

class PaymentViewController: UIViewController {
    private var tokenService: DatacapTokenService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tokenService = DatacapTokenService(
            publicKey: "YOUR_TOKEN_KEY",
            isCertification: true  // false for production
        )
        tokenService.delegate = self
    }
}
```

### 3. Generate Token
```swift
// Option 1: Use built-in UI
@IBAction func payButtonTapped() {
    tokenService.requestToken(from: self)
}

// Option 2: Use your own UI
let cardData = CardData(
    cardNumber: "4111111111111111",
    expirationMonth: "12",
    expirationYear: "25",
    cvv: "123"
)

Task {
    do {
        let token = try await tokenService.generateTokenDirect(for: cardData)
        // Process payment with token
    } catch {
        // Handle error
    }
}
```

### 4. Handle Response
```swift
extension PaymentViewController: DatacapTokenServiceDelegate {
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        print("Token: \(token.token)")
        print("Card: \(token.maskedCardNumber)")
        print("Type: \(token.cardType)")
        // Send token to your server
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        // Handle error
    }
    
    func tokenRequestDidCancel() {
        // User cancelled
    }
}
```

## Key Features

### SDK Features
- **Real API Integration**: Direct REST API calls to Datacap's OTU endpoints
- **Dual Key Support**: Separate keys for certification and production
- **Two Integration Modes**: Built-in UI or bring your own
- **Card Validation**: Luhn algorithm, BIN detection, format validation
- **Zero Dependencies**: Pure Swift, no external libraries
- **Easy Integration**: Single file to add to your project

### App Features
- **Modern UI**: iOS 26 Liquid Glass design system
- **Settings Management**: Configure and test both environments
- **Smart Card Entry**: Auto-formatting, type detection
- **Native Date Picker**: Wheel-style expiration selection
- **Live Validation**: Real-time feedback as you type
- **Token Display**: Copy token with one tap
- **Dark Mode**: Full support for light and dark appearance
- **iPad Optimized**: Responsive layouts with feature cards
- **Accessibility**: High contrast and dynamic type support

## API Documentation

### Endpoints
- **Certification**: `https://token-cert.dcap.com/v1/otu`
- **Production**: `https://token.dcap.com/v1/otu`

### Request Format
```http
POST /v1/otu
Authorization: {your-token-key}
Content-Type: application/json

{
    "Account": "4111111111111111",
    "ExpirationMonth": "12",
    "ExpirationYear": "25",
    "CVV": "123"
}
```

### Response Format
```json
{
    "Token": "DC4:AAAMbdJpMn6wZYlx84etCekz...",
    "Brand": "Visa",
    "ExpirationMonth": "12",
    "ExpirationYear": "2025",
    "Last4": "1111",
    "Bin": "411111"
}
```

## Test Cards

Use these in certification mode:

| Card Type | Number | CVV | Exp |
|-----------|--------|-----|-----|
| Visa | 4111111111111111 | 123 | Any future date |
| Mastercard | 5555555555554444 | 123 | Any future date |
| Amex | 378282246310005 | 1234 | Any future date |
| Discover | 6011111111111117 | 123 | Any future date |
| Diners | 36700102000000 | 123 | Any future date |

## Security

- **PCI Compliant**: No card data storage, tokenization only
- **TLS Encryption**: All API calls use HTTPS
- **Input Validation**: Luhn algorithm, BIN validation
- **Secure Entry**: Masked CVV input
- **One-Time Tokens**: Tokens are single-use only

## Running the App

```bash
# Clone repository
git clone https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025.git
cd Datacap-MobileToken-iOS-2025

# Open in Xcode
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj

# Build and run (⌘+R)
```

### App Configuration
1. Launch app
2. Tap Settings (gear icon)
3. Select Certification mode
4. Enter your test API key
5. Save configuration
6. Tap "Generate Token"

## Requirements

- iOS 15.6+
- Xcode 16.0+
- Swift 5.0+
- Network connectivity

## Support

- **Documentation**: [docs.datacapsystems.com](https://docs.datacapsystems.com)
- **Developer Portal**: [dsidevportal.com](https://www.dsidevportal.com)
- **Support**: [datacapsystems.com/support](http://datacapsystems.com/support)
- **GitHub Issues**: [Report bugs here](https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025/issues)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <b>Built with care by Datacap Systems</b><br>
  <i>Secure Payment Solutions Since 1983</i>
</div>