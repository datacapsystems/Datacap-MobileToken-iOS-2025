# Datacap Token Library for iOS

## Quick Start

### 1. Installation

Copy `Sources/DatacapTokenService.swift` into your iOS project.

### 2. Basic Usage

```swift
import UIKit

class CheckoutViewController: UIViewController {
    private var tokenService: DatacapTokenService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize tokenization service
        tokenService = DatacapTokenService(
            publicKey: "YOUR_TOKEN_KEY_HERE",
            isCertification: true  // false for production
        )
        tokenService.delegate = self
    }
    
    @IBAction func payButtonTapped() {
        // Show Datacap's card input UI
        tokenService.requestToken(from: self)
    }
}

extension CheckoutViewController: DatacapTokenServiceDelegate {
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        // Use the token for payment processing
        print("Token: \(token.token)")
        // Send to your server
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

### 3. Custom UI Integration

If you have your own card input UI:

```swift
// Create card data from your UI
let cardData = CardData(
    cardNumber: "4111111111111111",
    expirationMonth: "12",
    expirationYear: "25",
    cvv: "123"
)

// Generate token without showing Datacap UI
Task {
    do {
        let token = try await tokenService.generateTokenDirect(for: cardData)
        // Use token
    } catch {
        // Handle error
    }
}
```

## API Details

- **Certification Endpoint**: `https://token-cert.dcap.com/v1/otu`
- **Production Endpoint**: `https://token.dcap.com/v1/otu`
- **Authentication**: Token key in Authorization header
- **Method**: POST

## Requirements

- iOS 15.6+
- Swift 5.0+
- Network access

## Test Cards

| Card Type   | Number           | CVV | Exp  |
|-------------|------------------|-----|------|
| Visa        | 4111111111111111 | 123 | Any  |
| Mastercard  | 5555555555554444 | 123 | Any  |
| Amex        | 378282246310005  | 1234| Any  |
| Discover    | 6011111111111117 | 123 | Any  |

## Support

- Documentation: https://docs.datacapsystems.com
- Developer Portal: https://www.dsidevportal.com