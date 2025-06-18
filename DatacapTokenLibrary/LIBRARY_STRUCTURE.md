# Datacap Token Library Structure

This directory contains the packaged library ready for distribution to integrators.

## Directory Structure

```
DatacapTokenLibrary/
├── Sources/                          # Library source code
│   ├── DatacapTokenService.swift    # Main service class (public API)
│   └── DatacapTokenViewController.swift # Card input UI (internal)
├── Example/                          # Integration examples
│   └── IntegrationExample.swift     # Sample implementation
├── Tests/                           # Unit tests
│   └── DatacapTokenLibraryTests/
│       └── DatacapTokenServiceTests.swift
├── Package.swift                    # Swift Package Manager config
├── DatacapTokenLibrary.podspec     # CocoaPods specification
├── README.md                        # Library documentation
├── LICENSE                          # License agreement
└── LIBRARY_STRUCTURE.md            # This file
```

## Key Components

### 1. DatacapTokenService (Public API)

The main entry point for integrators:

```swift
// Initialize with merchant's public key
let tokenService = DatacapTokenService(
    publicKey: "merchant_public_key",
    isCertification: true
)

// Request token (presents UI)
tokenService.requestToken(from: viewController)
```

### 2. DatacapTokenViewController (Internal)

- Pre-built card input UI
- Handles all formatting and validation
- Not directly accessible by integrators
- Customizable through the service

### 3. Integration Flow

1. **Merchant Integration**:
   - Add library to their iOS app
   - Initialize with their public key
   - Call `requestToken()` when needed
   - Handle callbacks via delegate

2. **End User Experience**:
   - Sees native iOS card input UI
   - Enters card details
   - Gets real-time validation
   - Submits for tokenization

3. **Token Response**:
   - Success: Receive secure token
   - Failure: Get specific error
   - Cancel: User cancelled

## Distribution Options

### Swift Package Manager

Integrators add to their `Package.swift`:
```swift
.package(url: "https://github.com/datacapsystems/DatacapTokenLibrary-iOS.git", from: "1.0.0")
```

### CocoaPods

Integrators add to their `Podfile`:
```ruby
pod 'DatacapTokenLibrary', '~> 1.0'
```

### Manual Integration

1. Copy `Sources` folder to project
2. Add files to target
3. Import and use

## Security Features

- **No Card Storage**: Card data is never persisted
- **HTTPS Only**: All API calls use TLS
- **Input Validation**: Real-time Luhn validation
- **Secure Text Entry**: CVV field is masked
- **No Logging**: Sensitive data never logged

## API Requirements

Integrators need:
1. Valid merchant account with Datacap
2. Public API key from dsidevportal.com
3. iOS 15.6+ deployment target
4. Swift 5.0+ project

## Support

- Documentation: docs.datacapsystems.com
- Developer Portal: dsidevportal.com
- Support: support@datacapsystems.com