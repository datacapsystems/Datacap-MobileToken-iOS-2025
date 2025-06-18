# Datacap iOS Token Library - Integration Guide

## Overview

This guide explains how to integrate the Datacap tokenization service into your iOS application. The implementation uses Datacap's REST API for secure payment card tokenization.

## API Endpoint Documentation

### Production Implementation Details

Based on the working implementation, here are the exact API details:

#### Endpoints
- **Certification**: `https://token-cert.dcap.com/v1/otu`
- **Production**: `https://token.dcap.com/v1/otu`

#### Request Format
```
Method: POST
Headers:
  Authorization: {your-public-key}
  Content-Type: application/json

Body:
{
  "Account": "4111111111111111",
  "ExpirationMonth": "12",
  "ExpirationYear": "25", 
  "CVV": "123"
}
```

#### Response Format
```json
{
  "Token": "DC4:AAAMbdJpMn6wZYlx84etCekz2HMpp6IQtqL0G3aMInirXYQMNLpr9oJMctxC76NVSGkO5XXO/naM0X1CfzX1md2caSTHKO4QjpYmzJlMOsQwer5VUEJWCZVzd0Ytr2jvRLw=",
  "Brand": "Visa",
  "ExpirationMonth": "12",
  "ExpirationYear": "2025",
  "Last4": "1111",
  "Bin": "411111"
}
```

## Integration Steps

### 1. Copy Required Files

Extract these files from the demo project into your iOS application:

**Core Service Files:**
- `DatacapTokenService.swift` - Main tokenization service
- `DatacapTokenViewController.swift` - Card input UI (included in DatacapTokenService.swift)

**Optional UI Enhancement:**
- `GlassMorphismExtensions.swift` - Modern UI effects (optional)

### 2. Basic Integration

```swift
import UIKit

class PaymentViewController: UIViewController {
    
    private var tokenService: DatacapTokenService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize with your merchant credentials
        tokenService = DatacapTokenService(
            publicKey: "YOUR_PUBLIC_KEY_HERE",
            isCertification: true,  // false for production
            apiEndpoint: ""  // Not used - endpoint is automatic
        )
        tokenService.delegate = self
    }
    
    @IBAction func collectPaymentTapped() {
        // This will present the card input UI
        tokenService.requestToken(from: self)
    }
}

// MARK: - DatacapTokenServiceDelegate
extension PaymentViewController: DatacapTokenServiceDelegate {
    
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        // Token generated successfully
        print("Token: \(token.token)")
        print("Masked Card: \(token.maskedCardNumber)")
        print("Card Type: \(token.cardType)")
        
        // Send token to your server for processing
        processPaymentWithToken(token.token)
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        // Handle error
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func tokenRequestDidCancel() {
        // User cancelled card input
        print("User cancelled tokenization")
    }
}
```

### 3. Advanced Integration (Custom UI)

If you want to use your own card input UI instead of the provided one:

```swift
// Create card data from your custom UI
let cardData = CardData(
    cardNumber: "4111111111111111",
    expirationMonth: "12",
    expirationYear: "25",
    cvv: "123"
)

// Generate token directly (without presenting UI)
Task {
    do {
        let token = await tokenService.generateToken(for: cardData)
        // Handle successful token
    } catch {
        // Handle error
    }
}
```

### 4. Security Best Practices

1. **Never log or store card numbers** - Only use the tokenized value
2. **Use HTTPS only** - The API requires secure connections
3. **Validate on server** - Always validate tokens server-side before processing
4. **PCI Compliance** - This library helps maintain PCI compliance by avoiding card data storage

### 5. Testing

#### Test Card Numbers
```
Visa:       4111111111111111
Mastercard: 5555555555554444
Amex:       378282246310005
Discover:   6011111111111117
```

#### Switching Environments
```swift
// Certification (testing)
tokenService = DatacapTokenService(
    publicKey: "YOUR_CERT_KEY",
    isCertification: true,
    apiEndpoint: ""
)

// Production
tokenService = DatacapTokenService(
    publicKey: "YOUR_PROD_KEY", 
    isCertification: false,
    apiEndpoint: ""
)
```

### 6. Error Handling

The library provides specific error types:

```swift
enum DatacapTokenError {
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

### 7. Customization Options

#### Modify Card Input UI
The card input view controller can be customized by modifying `DatacapTokenViewController` in the service file:
- Change colors, fonts, layout
- Add your branding
- Modify validation rules

#### Card Type Detection
The library automatically detects card types:
- Visa, Mastercard, American Express, Discover, Diners Club
- Automatic formatting based on card type
- CVV length validation (3 or 4 digits for Amex)

## Important Notes

1. **API Key Required**: You must obtain a public key from Datacap
2. **No Mock Mode**: This implementation always calls the real API
3. **Token Format**: Tokens are one-time use only
4. **iOS Version**: Requires iOS 15.6 or later
5. **Swift Version**: Built with Swift 5.0+

## Support

For API keys and merchant account setup:
- Visit: https://www.datacapsystems.com
- Developer Portal: https://www.dsidevportal.com

## Example Implementation

See the demo app in `DatacapMobileTokenDemo/` for a complete working example including:
- Settings management
- Error handling
- Success display
- UI/UX best practices