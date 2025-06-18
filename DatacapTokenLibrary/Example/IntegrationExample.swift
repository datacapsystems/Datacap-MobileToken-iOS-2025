//
//  IntegrationExample.swift
//  Example of how to integrate DatacapTokenLibrary
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

import UIKit
import DatacapTokenLibrary // Import the library

class PaymentViewController: UIViewController {
    
    // Initialize the token service with your merchant's public key
    private lazy var tokenService: DatacapTokenService = {
        return DatacapTokenService(
            publicKey: "YOUR_MERCHANT_PUBLIC_KEY",
            isCertification: true // Use false for production
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate to receive callbacks
        tokenService.delegate = self
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add a button to trigger tokenization
        let tokenizeButton = UIButton(type: .system)
        tokenizeButton.setTitle("Add Payment Method", for: .normal)
        tokenizeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        tokenizeButton.addTarget(self, action: #selector(tokenizeCard), for: .touchUpInside)
        
        tokenizeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tokenizeButton)
        
        NSLayoutConstraint.activate([
            tokenizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tokenizeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tokenizeButton.widthAnchor.constraint(equalToConstant: 200),
            tokenizeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func tokenizeCard() {
        // This will present the card input UI
        tokenService.requestToken(from: self)
    }
}

// MARK: - DatacapTokenServiceDelegate

extension PaymentViewController: DatacapTokenServiceDelegate {
    
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        // Token generated successfully!
        print("✅ Token Generated: \(token.token)")
        print("Card: \(token.cardType) \(token.maskedCardNumber)")
        print("Expires: \(token.expirationDate)")
        
        // Send the token to your backend server
        sendTokenToServer(token.token)
        
        // Show success to user
        let alert = UIAlertController(
            title: "Success",
            message: "Payment method added successfully",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        // Handle the error
        print("❌ Tokenization failed: \(error.localizedDescription)")
        
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tokenRequestDidCancel() {
        // User cancelled the card input
        print("User cancelled tokenization")
    }
    
    private func sendTokenToServer(_ token: String) {
        // Example: Send token to your backend
        // Your backend should use this token to process payments
        // Never send card details to your server, only the token!
        
        /*
        let url = URL(string: "https://your-backend.com/api/payment-methods")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response
        }.resume()
        */
    }
}