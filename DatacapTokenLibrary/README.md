# Datacap Token Library for iOS

A lightweight, secure iOS library for tokenizing payment cards using Datacap's tokenization API. Perfect for merchants who need to accept card payments in their iOS applications.

## Features

- 🔐 **Secure Tokenization**: Convert card numbers to secure tokens
- 💳 **Smart Card Detection**: Automatically identifies card types
- 📱 **Native iOS UI**: Pre-built card input interface
- ✅ **Built-in Validation**: Luhn algorithm and format validation
- 🎨 **Customizable**: Easy to integrate with your app's design
- 🚀 **Production Ready**: Supports both certification and production environments

## Requirements

- iOS 15.6+
- Swift 5.0+
- Xcode 15.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/datacapsystems/DatacapTokenLibrary-iOS.git", from: "1.0.0")
]
```

### CocoaPods

```ruby
pod 'DatacapTokenLibrary', '~> 1.0'
```

### Manual Installation

1. Copy the `Sources` folder into your project
2. Add the files to your target
3. Import the module where needed

## Quick Start

### 1. Initialize the Service

```swift
import DatacapTokenLibrary

// Initialize with your merchant's public key
let tokenService = DatacapTokenService(
    publicKey: "YOUR_MERCHANT_PUBLIC_KEY",
    isCertification: true  // Use false for production
)

// Set the delegate
tokenService.delegate = self
```

### 2. Request a Token

```swift
// This will present the card input UI
tokenService.requestToken(from: self)
```

### 3. Handle the Response

```swift
extension YourViewController: DatacapTokenServiceDelegate {
    
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        // Success! Send the token to your backend
        print("Token: \(token.token)")
        print("Card: \(token.cardType) \(token.maskedCardNumber)")
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        // Handle the error
        print("Error: \(error.localizedDescription)")
    }
    
    func tokenRequestDidCancel() {
        // User cancelled
    }
}
```

## API Documentation

### DatacapTokenService

The main service class for tokenization.

```swift
public class DatacapTokenService {
    /// Initialize the service
    /// - Parameters:
    ///   - publicKey: Your merchant's public API key
    ///   - isCertification: Use certification environment (default: true)
    ///   - apiEndpoint: Custom endpoint (optional)
    public init(publicKey: String, 
                isCertification: Bool = true,
                apiEndpoint: String = "https://api.datacapsystems.com/v1/tokenize")
    
    /// Request a token by presenting the card input UI
    public func requestToken(from viewController: UIViewController)
}
```

### DatacapToken

The token response model.

```swift
public struct DatacapToken {
    public let token: String              // The secure token
    public let maskedCardNumber: String   // **** 1234
    public let cardType: String           // Visa, Mastercard, etc.
    public let expirationDate: String     // MM/YY
    public let responseCode: String       // 00 for success
    public let responseMessage: String    // Success or error message
    public let timestamp: Date
}
```

### DatacapTokenError

Possible error types.

```swift
public enum DatacapTokenError: LocalizedError {
    case invalidPublicKey
    case invalidCardNumber
    case invalidExpirationDate
    case invalidCVV
    case networkError(String)
    case tokenizationFailed(String)
    case userCancelled
    case missingAPIConfiguration
}
```

## Supported Card Types

The library automatically detects and formats these card types:

- **Visa**: 16 digits, starts with 4
- **Mastercard**: 16 digits, starts with 51-55 or 2221-2720
- **American Express**: 15 digits, starts with 34 or 37
- **Discover**: 16 digits, starts with 6011, 65, or 644-649
- **Diners Club**: 14 digits, starts with 36, 38, or 300-305

## Security

- **PCI Compliant**: No card data is stored on device
- **HTTPS Only**: All API calls use secure connections
- **Input Validation**: Real-time validation prevents invalid data
- **No Logging**: Sensitive data is never logged

## Testing

### Test Card Numbers

Use these test cards in certification mode:

| Card Type | Number | CVV | Expiry |
|-----------|--------|-----|---------|
| Visa | 4111111111111111 | 123 | Any future date |
| Mastercard | 5555555555554444 | 123 | Any future date |
| American Express | 378282246310005 | 1234 | Any future date |
| Discover | 6011111111111117 | 123 | Any future date |

### Getting Your API Key

1. Visit [dsidevportal.com](https://www.dsidevportal.com)
2. Register for a merchant account
3. Get your public API key
4. Start in certification mode for testing
5. Switch to production when ready

## Example Integration

```swift
import UIKit
import DatacapTokenLibrary

class CheckoutViewController: UIViewController {
    
    private let tokenService = DatacapTokenService(
        publicKey: "YOUR_PUBLIC_KEY",
        isCertification: true
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tokenService.delegate = self
    }
    
    @IBAction func addCardTapped() {
        tokenService.requestToken(from: self)
    }
}

extension CheckoutViewController: DatacapTokenServiceDelegate {
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        // Send token to your backend
        completeCheckout(with: token.token)
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        showError(error.localizedDescription)
    }
    
    func tokenRequestDidCancel() {
        // Handle cancellation
    }
}
```

## Best Practices

1. **Never store card details** - Only store the token
2. **Use HTTPS** - Always use secure connections to your backend
3. **Handle errors gracefully** - Show user-friendly error messages
4. **Test thoroughly** - Use certification mode before going live
5. **Keep keys secure** - Never commit API keys to source control

## Support

- **Documentation**: [docs.datacapsystems.com](https://docs.datacapsystems.com)
- **Developer Portal**: [dsidevportal.com](https://www.dsidevportal.com)
- **Support**: support@datacapsystems.com

## License

Copyright © 2025 Datacap Systems, Inc. All rights reserved.

This library is provided under the Datacap SDK License Agreement.
See LICENSE file for details.