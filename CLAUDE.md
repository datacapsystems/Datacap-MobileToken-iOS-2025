# CLAUDE.md - AI Development Assistant Guide

This file contains important information for AI assistants (like Claude) working on the Datacap Token iOS project.

## Project Overview

**Project Type**: iOS SDK + Demo Application  
**Languages**: Swift 5.0+  
**Framework**: Datacap Tokenization REST API  
**UI Design**: iOS 26 Liquid Glass (Glass Morphism)  
**Target**: ISVs and Merchants integrating payment tokenization  
**Status**: Production-ready with live API integration  
**Repository**: https://github.com/datacapsystems/Datacap-MobileToken-iOS-2025  

## Recent Updates (2025)

### ✅ Production API Integration (Latest)
- **Fixed tokenization endpoints**: Now using correct `/v1/otu` endpoints
- **Proper authentication**: Token key in Authorization header
- **Correct request format**: Capitalized field names (Account, ExpirationMonth, etc.)
- **Dual key support**: Separate keys for certification and production environments
- **Migration support**: Automatic upgrade from single-key to dual-key system
- **Two integration modes**: Built-in UI or custom UI with `generateTokenDirect()`

### ✅ SDK Architecture
- **Single-file integration**: Just copy `DatacapTokenService.swift`
- **Zero dependencies**: Pure Swift, no external libraries
- **Delegate pattern**: Async responses via protocol
- **Error handling**: Typed errors with clear descriptions
- **Card validation**: Luhn algorithm, BIN detection, format validation

### ✅ UI/UX Implementation
- **iOS 26 Liquid Glass**: Modern glass morphism design
- **Programmatic UI**: No storyboards for new features
- **Smart card entry**: Auto-formatting, type detection
- **Native date picker**: Wheel-style expiration selection
- **Settings management**: Separate keys for each environment

### ✅ Repository Cleanup (June 2025)
- **Public-facing structure**: Cleaned for open source distribution
- **MIT License**: Added for broad usage rights
- **Private files moved**: All internal scripts and docs in `.backup-private/`
- **Professional documentation**: README with working Mermaid diagrams
- **Clean git history**: Ready for public repository

## Repository Structure

```
Datacap-MobileToken-iOS-2025/
├── DatacapTokenLibrary/              # 📦 DISTRIBUTABLE LIBRARY
│   ├── Sources/                      # Library source code
│   │   ├── DatacapTokenService.swift # Public API
│   │   └── DatacapTokenViewController.swift # Internal UI
│   ├── Example/                      # Integration examples
│   ├── Tests/                        # Unit tests
│   ├── Package.swift                 # SPM configuration
│   ├── DatacapTokenLibrary.podspec  # CocoaPods spec
│   └── README.md                     # Library documentation
│
├── DatacapMobileTokenDemo/           # 📱 DEMO APPLICATION
│   ├── DatacapMobileDemo/
│   │   ├── ModernViewController.swift      # Demo main screen
│   │   ├── SettingsViewController.swift    # API configuration
│   │   ├── HelpOverlayView.swift          # iOS 26 help overlay
│   │   ├── DatacapTokenService.swift       # Same as library
│   │   └── GlassMorphismExtensions.swift   # UI styling
│   └── DatacapMobileTokenDemo.xcodeproj
│
├── docs/                             # 📚 PUBLIC DOCUMENTATION
│   └── images/                       # Screenshots and diagrams
│
├── README.md                         # Main repository documentation
├── INTEGRATION_GUIDE.md              # Detailed integration guide
├── LICENSE                           # MIT License
├── CLAUDE.md                         # This file (AI assistant guide)
└── .gitignore                        # Excludes private files
```

## Architecture Overview

### Library Architecture (What Integrators Use)

```mermaid
graph TB
    subgraph "Merchant's iOS App"
        APP[Their App]
    end
    
    subgraph "DatacapTokenLibrary"
        DTS[DatacapTokenService<br/>Public API]
        DTVC[DatacapTokenViewController<br/>Internal]
        MOD[Models & Protocols]
    end
    
    subgraph "Datacap Backend"
        API[Tokenization API]
    end
    
    APP --> DTS
    DTS --> DTVC
    DTS --> API
    API --> APP
    
    style DTS fill:#941a25,stroke:#fff,stroke-width:2px,color:#fff
    style APP fill:#228b22,stroke:#fff,stroke-width:2px,color:#fff
```

### Integration Flow

```mermaid
sequenceDiagram
    participant Integrator
    participant Library
    participant CardUI
    participant DatacapAPI
    
    Integrator->>Library: init(publicKey, isCertification)
    Integrator->>Library: requestToken(from: vc)
    Library->>CardUI: Present input screen
    CardUI->>CardUI: User enters card
    CardUI->>Library: Card data collected
    Library->>DatacapAPI: POST /tokenize
    DatacapAPI->>Library: Token response
    Library->>Integrator: delegate.tokenRequestDidSucceed()
```

## Key Development Guidelines

### 1. Library Philosophy

- **Minimal Surface Area**: Only expose what's necessary
- **Zero Dependencies**: No external libraries
- **Production Ready**: No mock data, real API only
- **Stateless Design**: No data persistence
- **Easy Integration**: 3 lines to get started

### 2. Public API (What Integrators See)

```swift
// Main service class
public class DatacapTokenService {
    public init(publicKey: String, isCertification: Bool, apiEndpoint: String?)
    public func requestToken(from: UIViewController)
    public weak var delegate: DatacapTokenServiceDelegate?
}

// Delegate protocol
public protocol DatacapTokenServiceDelegate {
    func tokenRequestDidSucceed(_ token: DatacapToken)
    func tokenRequestDidFail(error: DatacapTokenError)
    func tokenRequestDidCancel()
}

// Response model
public struct DatacapToken {
    public let token: String
    public let maskedCardNumber: String
    public let cardType: String
    public let expirationDate: String
    public let responseCode: String
    public let responseMessage: String
    public let timestamp: Date
}
```

### 3. Internal Components (Hidden from Integrators)

- `DatacapTokenViewController` - Card input UI
- Card validation logic
- Network implementation
- Card formatting logic

### 4. Distribution Channels

#### Swift Package Manager
```swift
.package(url: "https://github.com/datacapsystems/DatacapTokenLibrary-iOS.git", from: "1.0.0")
```

#### CocoaPods
```ruby
pod 'DatacapTokenLibrary', '~> 1.0'
```

#### Manual
- Copy `Sources/` folder
- Add to Xcode project

### 5. Security Requirements

- **No Logging**: Never log card numbers or sensitive data
- **HTTPS Only**: Enforce TLS for all API calls
- **Input Validation**: Client-side Luhn validation
- **No Storage**: Never persist card data
- **API Key Security**: Integrators must secure their keys

### 6. Testing Guidelines

#### For Library Development
```bash
cd DatacapTokenLibrary
swift test
```

#### For Demo App
```bash
xcodebuild test -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### 7. Common Development Tasks

#### Update Library Version
1. Update version in `Package.swift`
2. Update version in `DatacapTokenLibrary.podspec`
3. Tag release in git
4. Update documentation

#### Add New Card Type
1. Update detection in `DatacapTokenService.swift`
2. Add formatting in `DatacapTokenViewController.swift`
3. Update CVV validation
4. Add test cases
5. Update documentation

#### Fix UI Issues
1. Make changes in library `Sources/`
2. Test in demo app
3. Ensure backward compatibility
4. Update integration examples

### 8. Build & Release Process

```bash
# 1. Test library
cd DatacapTokenLibrary
swift test

# 2. Test demo app
cd ..
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj build

# 3. Tag release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# 4. Update package repositories
# - Submit to CocoaPods trunk
# - SPM updates automatically from git tag
```

### 9. Integration Support

When helping integrators:

1. **Always reference the library README** first
2. **Provide minimal code examples**
3. **Test with their specific use case**
4. **Never suggest modifications to library internals**
5. **Document any issues for future releases**

## Current Status

### Library Package (`/DatacapTokenLibrary/`)
- ✅ Core tokenization service
- ✅ Card input UI
- ✅ Real API integration
- ✅ SPM and CocoaPods ready
- ✅ Documentation complete
- ✅ MIT License (entire repository)

### Demo App (`/DatacapMobileTokenDemo/`)
- ✅ Shows library integration
- ✅ Settings for API configuration
- ✅ Glass morphism UI
- ✅ Help documentation
- ✅ Ready for App Store

### Repository Status
- ✅ Public-facing structure
- ✅ Professional documentation
- ✅ Clean commit history
- ✅ Private files backed up in `.backup-private/`
- ✅ Ready for GitHub public repository

## Notes for AI Assistants

### DO's
1. **Keep library minimal** - Don't add unnecessary features
2. **Maintain backward compatibility** - Don't break existing integrations
3. **Document all changes** - Update README and migration guides
4. **Test thoroughly** - Both library and demo app
5. **Focus on security** - This handles payment data
6. **Use semantic versioning** - Major.Minor.Patch

### DON'Ts
1. **Don't add external dependencies** - Keep it zero-dependency
2. **Don't expose internals** - Keep implementation details private
3. **Don't add mock/demo modes** - Production use only
4. **Don't log sensitive data** - No card numbers in logs
5. **Don't complicate integration** - Keep it simple
6. **Don't modify without testing** - Always verify changes

### Quick Commands

```bash
# Open demo in Xcode
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj

# Build library
cd DatacapTokenLibrary && swift build

# Run demo
xcodebuild -project DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  build

# Package library for distribution
cd DatacapTokenLibrary
swift build -c release
```

### Support Channels

- Library Issues: GitHub Issues
- Integration Support: support@datacapsystems.com
- Documentation: docs.datacapsystems.com
- Developer Portal: dsidevportal.com

Remember: The library is what merchants integrate. Keep it clean, secure, and simple. The demo app showcases capabilities but is not distributed to integrators.

## API Integration Details

### Tokenization Endpoints
- **Certification**: `https://token-cert.dcap.com/v1/otu`
- **Production**: `https://token.dcap.com/v1/otu`

### Request Format
```http
POST /v1/otu
Authorization: {token-key}
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

## Key Storage

The app now manages separate API keys for each environment:

```swift
// Certification key
UserDefaults.standard.string(forKey: "DatacapCertificationPublicKey")

// Production key  
UserDefaults.standard.string(forKey: "DatacapProductionPublicKey")

// Legacy key (for backwards compatibility)
UserDefaults.standard.string(forKey: "DatacapPublicKey")

// Current mode
UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
```

## Test Keys for Development

- **Certification Key**: `40e5d3b53da64750937728d783e4b3d1`
- **Production Key**: `6b8690b69c674b83927de02fdb4c5184`

Note: These are example keys. ISVs must obtain their own keys from dsidevportal.com