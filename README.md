# Getting started with MobileToken for iOS

### Add DatacapMobileToken.framework to your Xcode project
1. In the project navigator, select the project or group within a project to which you want to add the framework.
2. Choose File > Add Files to “*Your Project Name*”.
3. Select the DatacapMobileToken.framework bundle, and click Add.
4. In the project settings, choose the Build Phases tab.
5. Under the Embed Frameworks section, choose "+" to add a new Embedded Framework.
6. Select the DatacapMobileToken.framework bundle, and click Add.

### Include the framework in your code
```objective-c
#import <DatacapMobileToken/DatacapMobileToken.h>
```

### Implement the tokenization delegate
##### Implement the `DatacapTokenDelegate` protocol
```objective-c
@interface ViewController : UIViewController <DatacapTokenDelegate>
```
##### Implement `DatacapTokenDelegate` methods

On Loading:
```objective-c
- (void)tokenLoading
{
  // The framework has begun tokenizing user-input account data.
}
```

On Success:
```objective-c
- (void)tokenCreated:(DatacapToken *)token
{
  // A token has been received!
}
```

In the `tokenCreated` method, the received `DatacapToken` object contains 5 `NSString` properties:  
* `Token`: The one-time-use token for the user-entered account data.
* `Brand`: The card brand of account represented by the token.
* `ExpirationMonth`: The 2-digit expiration month of the account.
* `ExpirationYear`: The 4-digit expiration year of the account.
* `Last4`: The last 4 digits of the account number.

On Error:
```objective-c
- (void)tokenizationError:(NSError *)error
{
  // A tokenization error has occurred!
}
```
The `tokenizationError` method will receive an `NSError` object with one of the 4 following error codes:
* `DMTConnectionError`: Failed to communicate with Datacap Token API.
* `DMTAuthenticationError`: Public key authentication failed.
* `DMTDataValidationError`: Failed to tokenize due to invalid account information.
* `DMTTokenizationError`: An error has occurred tokenizing the account data at the Datacap Token API.

On Cancel:
```objective-c
- (void)tokenizationCancelled
{
  // The user has cancelled tokenization!
}
```

### Request a token for keyed account
##### Provide a `DatacapTokenizer` object with a Datacap public key, a `DatacapTokenDelegate` object which to send events, and a `UIViewController` over which to display the account entry views
```objective-c
DatacapTokenizer *tokenizer = [DatacapTokenizer new];
[tokenizer requestKeyedTokenWithPublicKey:@"[Public Key Goes Here]"
			  isCertification:true // <-- remove for production
                              andDelegate:self
                       overViewController:self];
```

### Report bugs
If you encounter any bugs or issues with the latest version of MobileToken for iOS, please report them to us by opening a [GitHub Issue](https://github.com/datacapsystems/MobileToken-iOS/issues)!
