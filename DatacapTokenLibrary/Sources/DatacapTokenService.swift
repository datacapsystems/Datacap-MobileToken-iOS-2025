//
//  DatacapTokenService.swift
//  DatacapTokenLibrary
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

import UIKit

// MARK: - Public API

/// The main service class for Datacap tokenization
public class DatacapTokenService {
    
    /// The delegate to receive tokenization callbacks
    public weak var delegate: DatacapTokenServiceDelegate?
    
    private let publicKey: String
    private let isCertification: Bool
    private let apiEndpoint: String
    
    /// Initialize the Datacap Token Service
    /// - Parameters:
    ///   - publicKey: Your merchant's public API key
    ///   - isCertification: Use certification environment (true) or production (false)
    ///   - apiEndpoint: Optional custom endpoint (defaults to official Datacap API)
    public init(publicKey: String, 
                isCertification: Bool = true,
                apiEndpoint: String = "https://api.datacapsystems.com/v1/tokenize") {
        self.publicKey = publicKey
        self.isCertification = isCertification
        self.apiEndpoint = apiEndpoint
    }
    
    /// Request a token by presenting the card input UI
    /// - Parameter viewController: The view controller to present the card input from
    public func requestToken(from viewController: UIViewController) {
        let tokenViewController = DatacapTokenViewController()
        tokenViewController.delegate = self
        tokenViewController.modalPresentationStyle = .fullScreen
        viewController.present(tokenViewController, animated: true)
    }
}

// MARK: - Public Protocols

/// Delegate protocol for receiving tokenization results
public protocol DatacapTokenServiceDelegate: AnyObject {
    /// Called when tokenization succeeds
    func tokenRequestDidSucceed(_ token: DatacapToken)
    
    /// Called when tokenization fails
    func tokenRequestDidFail(error: DatacapTokenError)
    
    /// Called when user cancels the tokenization
    func tokenRequestDidCancel()
}

// MARK: - Public Models

/// The tokenization result
public struct DatacapToken {
    public let token: String
    public let maskedCardNumber: String
    public let cardType: String
    public let expirationDate: String
    public let responseCode: String
    public let responseMessage: String
    public let timestamp: Date
}

/// Tokenization error types
public enum DatacapTokenError: LocalizedError {
    case invalidPublicKey
    case invalidCardNumber
    case invalidExpirationDate
    case invalidCVV
    case networkError(String)
    case tokenizationFailed(String)
    case userCancelled
    case missingAPIConfiguration
    
    public var errorDescription: String? {
        switch self {
        case .invalidPublicKey:
            return "Invalid public key provided"
        case .invalidCardNumber:
            return "Invalid card number"
        case .invalidExpirationDate:
            return "Invalid expiration date"
        case .invalidCVV:
            return "Invalid CVV"
        case .networkError(let message):
            return "Network error: \(message)"
        case .tokenizationFailed(let message):
            return "Tokenization failed: \(message)"
        case .userCancelled:
            return "User cancelled the operation"
        case .missingAPIConfiguration:
            return "API endpoint and key must be configured"
        }
    }
}

// MARK: - Private Implementation

extension DatacapTokenService {
    
    private func validateCardNumber(_ number: String) -> Bool {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        guard cleaned.count >= 13 && cleaned.count <= 19 else { return false }
        
        // Luhn algorithm
        var sum = 0
        let reversedCharacters = cleaned.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch (idx % 2 == 1, digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    private func detectCardType(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        
        if cleaned.hasPrefix("4") {
            return "Visa"
        } else if let prefix = Int(cleaned.prefix(2)), (51...55).contains(prefix) {
            return "Mastercard"
        } else if let prefix = Int(cleaned.prefix(4)), (2221...2720).contains(prefix) {
            return "Mastercard"
        } else if cleaned.hasPrefix("34") || cleaned.hasPrefix("37") {
            return "American Express"
        } else if cleaned.hasPrefix("6011") || cleaned.hasPrefix("65") {
            return "Discover"
        } else if let prefix = Int(cleaned.prefix(3)), (644...649).contains(prefix) {
            return "Discover"
        } else if cleaned.hasPrefix("36") || cleaned.hasPrefix("38") {
            return "Diners Club"
        } else if let prefix = Int(cleaned.prefix(3)), (300...305).contains(prefix) {
            return "Diners Club"
        }
        
        return "Unknown"
    }
    
    private func maskCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        guard cleaned.count >= 4 else { return number }
        
        let last4 = String(cleaned.suffix(4))
        let cardType = detectCardType(cleaned)
        
        switch cardType {
        case "American Express":
            return "**** ****** *\(last4)"
        case "Diners Club":
            return "**** ****** \(last4)"
        default:
            return "**** **** **** \(last4)"
        }
    }
    
    private func generateToken(for cardData: CardData) async -> DatacapToken {
        guard let url = URL(string: apiEndpoint) else {
            return DatacapToken(
                token: "",
                maskedCardNumber: maskCardNumber(cardData.cardNumber),
                cardType: detectCardType(cardData.cardNumber),
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: "999",
                responseMessage: "Invalid API endpoint",
                timestamp: Date()
            )
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(publicKey, forHTTPHeaderField: "Authorization")
        
        if isCertification {
            request.setValue("true", forHTTPHeaderField: "X-Certification-Mode")
        }
        
        let body: [String: Any] = [
            "cardNumber": cardData.cardNumber.replacingOccurrences(of: " ", with: ""),
            "expirationMonth": cardData.expirationMonth,
            "expirationYear": cardData.expirationYear,
            "cvv": cardData.cvv
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw DatacapTokenError.networkError("Invalid response")
            }
            
            if httpResponse.statusCode != 200 {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMessage = errorData["error"] as? String {
                    throw DatacapTokenError.tokenizationFailed(errorMessage)
                }
                throw DatacapTokenError.networkError("HTTP \(httpResponse.statusCode)")
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw DatacapTokenError.tokenizationFailed("Invalid response format")
            }
            
            let token = json["token"] as? String ?? ""
            let brand = json["brand"] as? String ?? detectCardType(cardData.cardNumber)
            let last4 = json["last4"] as? String ?? String(cardData.cardNumber.suffix(4))
            
            return DatacapToken(
                token: token,
                maskedCardNumber: "**** \(last4)",
                cardType: brand,
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: json["responseCode"] as? String ?? "00",
                responseMessage: json["responseMessage"] as? String ?? "Success",
                timestamp: Date()
            )
            
        } catch let error as DatacapTokenError {
            return DatacapToken(
                token: "",
                maskedCardNumber: maskCardNumber(cardData.cardNumber),
                cardType: detectCardType(cardData.cardNumber),
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: "999",
                responseMessage: error.localizedDescription,
                timestamp: Date()
            )
        } catch {
            return DatacapToken(
                token: "",
                maskedCardNumber: maskCardNumber(cardData.cardNumber),
                cardType: detectCardType(cardData.cardNumber),
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: "999",
                responseMessage: error.localizedDescription,
                timestamp: Date()
            )
        }
    }
}

// MARK: - Token View Controller Delegate

extension DatacapTokenService: DatacapTokenViewControllerDelegate {
    func tokenViewController(_ controller: DatacapTokenViewController, didCollectCardData cardData: CardData) {
        let cleanedNumber = cardData.cardNumber.replacingOccurrences(of: " ", with: "")
        
        guard validateCardNumber(cleanedNumber) else {
            controller.dismiss(animated: true) {
                self.delegate?.tokenRequestDidFail(error: .invalidCardNumber)
            }
            return
        }
        
        Task {
            let token = await generateToken(for: cardData)
            
            if token.responseCode != "00" && !token.responseCode.isEmpty {
                await MainActor.run {
                    controller.dismiss(animated: true) {
                        let error = DatacapTokenError.tokenizationFailed(token.responseMessage)
                        self.delegate?.tokenRequestDidFail(error: error)
                    }
                }
                return
            }
            
            await MainActor.run {
                controller.dismiss(animated: true) {
                    self.delegate?.tokenRequestDidSucceed(token)
                }
            }
        }
    }
    
    func tokenViewControllerDidCancel(_ controller: DatacapTokenViewController) {
        controller.dismiss(animated: true) {
            self.delegate?.tokenRequestDidCancel()
        }
    }
}

// MARK: - Internal Models

struct CardData {
    let cardNumber: String
    let expirationMonth: String
    let expirationYear: String
    let cvv: String
}

protocol DatacapTokenViewControllerDelegate: AnyObject {
    func tokenViewController(_ controller: DatacapTokenViewController, didCollectCardData cardData: CardData)
    func tokenViewControllerDidCancel(_ controller: DatacapTokenViewController)
}