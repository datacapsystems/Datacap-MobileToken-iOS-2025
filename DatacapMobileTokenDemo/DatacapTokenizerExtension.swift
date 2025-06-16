//
//  DatacapTokenizerExtension.swift
//  DatacapMobileTokenDemo
//
//  Extension to provide DatacapTokenizer functionality in Swift
//

import UIKit

// Create a Swift-friendly wrapper for DatacapTokenizer
class DatacapTokenizerWrapper: NSObject {
    
    // Create the tokenizer using Objective-C runtime
    private var tokenizer: AnyObject?
    
    override init() {
        super.init()
        
        // Get the DatacapTokenizer class dynamically
        if let tokenizerClass = NSClassFromString("DatacapTokenizer") {
            self.tokenizer = tokenizerClass.alloc() as AnyObject
            if let tokenizer = self.tokenizer {
                tokenizer.perform(NSSelectorFromString("init"))
            }
        }
    }
    
    // Wrapper method for requesting token
    func requestKeyedToken(withPublicKey publicKey: String, 
                          isCertification: Bool,
                          delegate: DatacapTokenDelegate,
                          overViewController viewController: UIViewController) {
        
        guard let tokenizer = self.tokenizer else { return }
        
        // Build the selector
        let selector = NSSelectorFromString("requestKeyedTokenWithPublicKey:isCertification:andDelegate:overViewController:")
        
        if tokenizer.responds(to: selector) {
            // Use NSInvocation alternative for Swift
            let methodSignature = tokenizer.method(for: selector)
            if methodSignature != nil {
                tokenizer.perform(selector, 
                                with: publicKey, 
                                with: NSNumber(value: isCertification),
                                afterDelay: 0,
                                inModes: [.default])
            }
        }
    }
}