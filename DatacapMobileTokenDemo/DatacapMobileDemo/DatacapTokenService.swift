//
//  DatacapTokenService.swift
//  DatacapMobileTokenDemo
//
//  Production-ready implementation of Datacap tokenization
//  
//  API Documentation:
//  - Certification endpoint: https://token-cert.dcap.com/v1/otu
//  - Production endpoint: https://token.dcap.com/v1/otu
//  - Method: POST with Authorization header containing token key
//
//  Integration Guide:
//  1. Copy this file into your iOS project
//  2. Initialize with your public key (token key)
//  3. Call requestToken() to show UI or generateTokenDirect() for custom UI
//  4. Handle delegate callbacks for success/failure
//
//  Version: 2.0
//  Last Updated: 2025
//

import UIKit
import CommonCrypto

// MARK: - Token Response Model
struct DatacapToken {
    let token: String
    let maskedCardNumber: String
    let cardType: String
    let expirationDate: String
    let responseCode: String
    let responseMessage: String
    let timestamp: Date
}

// MARK: - Saved Token Model
struct SavedToken: Codable {
    let token: String
    let maskedCardNumber: String
    let cardType: String
    let expirationDate: String
    let timestamp: Date
}

// MARK: - Token Delegate Protocol
protocol DatacapTokenServiceDelegate: AnyObject {
    func tokenRequestDidSucceed(_ token: DatacapToken)
    func tokenRequestDidFail(error: DatacapTokenError)
    func tokenRequestDidCancel()
}

// MARK: - Error Types
enum DatacapTokenError: LocalizedError {
    case invalidPublicKey
    case invalidCardNumber
    case invalidExpirationDate
    case invalidCVV
    case networkError(String)
    case tokenizationFailed(String)
    case userCancelled
    case missingAPIConfiguration
    
    var errorDescription: String? {
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

// MARK: - Main Service Class
class DatacapTokenService {
    
    weak var delegate: DatacapTokenServiceDelegate?
    private var publicKey: String
    private var isCertification: Bool
    private var apiEndpoint: String
    
    /// Initialize the token service
    /// - Parameters:
    ///   - publicKey: Your Datacap API public key (token key)
    ///   - isCertification: true for certification environment, false for production
    ///   - apiEndpoint: Not used - endpoint is automatically determined based on certification mode
    init(publicKey: String, isCertification: Bool = true, apiEndpoint: String = "") {
        self.publicKey = publicKey
        self.isCertification = isCertification
        self.apiEndpoint = apiEndpoint // Kept for backwards compatibility
    }
    
    // MARK: - Public Methods
    
    /// Request a token by presenting the card input UI
    func requestToken(from viewController: UIViewController) {
        // Validate configuration - only check publicKey since endpoint is determined by mode
        guard !publicKey.isEmpty else {
            delegate?.tokenRequestDidFail(error: .missingAPIConfiguration)
            return
        }
        
        let tokenViewController = DatacapTokenViewController()
        tokenViewController.delegate = self
        tokenViewController.modalPresentationStyle = .fullScreen
        viewController.present(tokenViewController, animated: true)
    }
    
    /// Generate a token directly without UI (for custom implementations)
    /// - Parameter cardData: Card information to tokenize
    /// - Returns: DatacapToken on success
    /// - Throws: DatacapTokenError on failure
    public func generateTokenDirect(for cardData: CardData) async throws -> DatacapToken {
        // Validate configuration
        guard !publicKey.isEmpty else {
            throw DatacapTokenError.missingAPIConfiguration
        }
        
        // Validate card data
        let cleanedNumber = cardData.cardNumber.replacingOccurrences(of: " ", with: "")
        guard validateCardNumber(cleanedNumber) else {
            throw DatacapTokenError.invalidCardNumber
        }
        
        // Generate token
        let token = await generateToken(for: cardData)
        
        // Check if token generation failed
        if token.responseCode != "00" && !token.responseCode.isEmpty {
            throw DatacapTokenError.tokenizationFailed(token.responseMessage)
        }
        
        return token
    }
    
    // MARK: - Private Methods
    
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
        let masked = String(repeating: "*", count: cleaned.count - 4)
        
        // Format based on card type
        let cardType = detectCardType(cleaned)
        switch cardType {
        case "American Express":
            // **** ****** *1234
            return "**** ****** *\(last4)"
        case "Diners Club":
            // **** ****** 1234
            return "**** ****** \(last4)"
        default:
            // **** **** **** 1234
            return "**** **** **** \(last4)"
        }
    }
    
    private func generateToken(for cardData: CardData) async -> DatacapToken {
        // Check if we should use demo mode for testing
        if publicKey == "demo" {
            // Demo mode - generate a fake token
            let demoToken = "tok_demo_\(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16))"
            return DatacapToken(
                token: demoToken,
                maskedCardNumber: maskCardNumber(cardData.cardNumber),
                cardType: detectCardType(cardData.cardNumber),
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: "00",
                responseMessage: "Demo token generated successfully",
                timestamp: Date()
            )
        }
        
        // Datacap tokenization endpoints - using the actual OTU (One Time Use) endpoint from WebToken
        // For certification: https://token-cert.dcap.com/v1/otu
        // For production: https://token.dcap.com/v1/otu
        let endpoint = isCertification ? "https://token-cert.dcap.com/v1/otu" : "https://token.dcap.com/v1/otu"
        
        guard let url = URL(string: endpoint) else {
            return DatacapToken(
                token: "",
                maskedCardNumber: maskCardNumber(cardData.cardNumber),
                cardType: detectCardType(cardData.cardNumber),
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: "999",
                responseMessage: "Invalid API endpoint: \(endpoint)",
                timestamp: Date()
            )
        }
        
        print("[DatacapTokenService] Using endpoint: \(endpoint)")
        print("[DatacapTokenService] Public key: \(publicKey.prefix(8))...")
        print("[DatacapTokenService] Is Certification: \(isCertification)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(publicKey, forHTTPHeaderField: "Authorization") // Token key goes in Authorization header
        
        // Prepare request body for Datacap tokenization - based on WebToken client
        // The API expects: ExpirationMonth and ExpirationYear (capitalized)
        let body: [String: Any] = [
            "Account": cardData.cardNumber.replacingOccurrences(of: " ", with: ""),
            "ExpirationMonth": cardData.expirationMonth,
            "ExpirationYear": cardData.expirationYear,
            "CVV": cardData.cvv
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            print("[DatacapTokenService] Request body: \(String(data: request.httpBody!, encoding: .utf8) ?? "nil")")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw DatacapTokenError.networkError("Invalid response")
            }
            
            print("[DatacapTokenService] Response status: \(httpResponse.statusCode)")
            print("[DatacapTokenService] Response data: \(String(data: data, encoding: .utf8) ?? "nil")")
            
            // Datacap tokenization returns 200 for success
            if httpResponse.statusCode == 200 {
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    throw DatacapTokenError.tokenizationFailed("Invalid response format")
                }
                
                // Check for errors in response
                if let errors = json["Errors"] as? [String], !errors.isEmpty {
                    throw DatacapTokenError.tokenizationFailed(errors.joined(separator: ", "))
                }
                
                // Parse successful response - exact format from working implementation
                guard let token = json["Token"] as? String, !token.isEmpty else {
                    throw DatacapTokenError.tokenizationFailed("No token in response")
                }
                
                let brand = json["Brand"] as? String ?? detectCardType(cardData.cardNumber)
                let last4 = json["Last4"] as? String ?? String(cardData.cardNumber.suffix(4).replacingOccurrences(of: " ", with: ""))
                
                return DatacapToken(
                    token: token,
                    maskedCardNumber: "**** \(last4)",
                    cardType: brand,
                    expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                    responseCode: "00",
                    responseMessage: "Success",
                    timestamp: Date()
                )
            } else {
                // Handle error response
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let errors = json["Errors"] as? [String] {
                        throw DatacapTokenError.tokenizationFailed(errors.joined(separator: ", "))
                    }
                    if let message = json["Message"] as? String {
                        throw DatacapTokenError.tokenizationFailed(message)
                    }
                }
                throw DatacapTokenError.networkError("HTTP \(httpResponse.statusCode)")
            }
            
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
        // Validate card data
        let cleanedNumber = cardData.cardNumber.replacingOccurrences(of: " ", with: "")
        
        guard validateCardNumber(cleanedNumber) else {
            controller.dismiss(animated: true) {
                self.delegate?.tokenRequestDidFail(error: .invalidCardNumber)
            }
            return
        }
        
        // Generate token asynchronously
        Task {
            let token = await generateToken(for: cardData)
            
            // Check if token generation failed
            if token.responseCode != "00" && !token.responseCode.isEmpty {
                await MainActor.run {
                    controller.dismiss(animated: true) {
                        let error = DatacapTokenError.tokenizationFailed(token.responseMessage)
                        self.delegate?.tokenRequestDidFail(error: error)
                    }
                }
                return
            }
            
            // Success - dismiss and notify delegate
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

// MARK: - Card Data Model
struct CardData {
    let cardNumber: String
    let expirationMonth: String
    let expirationYear: String
    let cvv: String
}

// MARK: - Token View Controller Protocol
protocol DatacapTokenViewControllerDelegate: AnyObject {
    func tokenViewController(_ controller: DatacapTokenViewController, didCollectCardData cardData: CardData)
    func tokenViewControllerDidCancel(_ controller: DatacapTokenViewController)
}

// MARK: - Token Input View Controller
class DatacapTokenViewController: UIViewController {
    
    weak var delegate: DatacapTokenViewControllerDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardNumberField = UITextField()
    private let expirationField = UITextField()
    private let expirationDatePicker = UIDatePicker()
    private let cvvField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardHandling()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Enter Card Details"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Card Number Field
        cardNumberField.placeholder = "Card Number"
        cardNumberField.borderStyle = .roundedRect
        cardNumberField.keyboardType = .numberPad
        cardNumberField.delegate = self
        cardNumberField.translatesAutoresizingMaskIntoConstraints = false
        cardNumberField.addTarget(self, action: #selector(cardNumberChanged), for: .editingChanged)
        contentView.addSubview(cardNumberField)
        
        // Card type icon
        let cardTypeIcon = UIImageView()
        cardTypeIcon.translatesAutoresizingMaskIntoConstraints = false
        cardTypeIcon.contentMode = .scaleAspectFit
        cardTypeIcon.tag = 100 // For easy reference
        cardNumberField.rightView = cardTypeIcon
        cardNumberField.rightViewMode = .always
        
        // Expiration Field
        expirationField.placeholder = "MM/YY"
        expirationField.borderStyle = .roundedRect
        expirationField.delegate = self
        expirationField.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup date picker
        expirationDatePicker.datePickerMode = .date
        expirationDatePicker.preferredDatePickerStyle = .wheels
        expirationDatePicker.minimumDate = Date()
        expirationDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        expirationField.inputView = expirationDatePicker
        
        // Add toolbar to date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        expirationField.inputAccessoryView = toolbar
        
        contentView.addSubview(expirationField)
        
        // CVV Field
        cvvField.placeholder = "CVV"
        cvvField.borderStyle = .roundedRect
        cvvField.keyboardType = .numberPad
        cvvField.isSecureTextEntry = true
        cvvField.delegate = self
        cvvField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cvvField)
        
        // Submit Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        submitButton.backgroundColor = UIColor(red: 148/255, green: 26/255, blue: 37/255, alpha: 1.0)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        contentView.addSubview(submitButton)
        
        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            cardNumberField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            cardNumberField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardNumberField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardNumberField.heightAnchor.constraint(equalToConstant: 50),
            
            expirationField.topAnchor.constraint(equalTo: cardNumberField.bottomAnchor, constant: 20),
            expirationField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            expirationField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4, constant: -30),
            expirationField.heightAnchor.constraint(equalToConstant: 50),
            
            cvvField.topAnchor.constraint(equalTo: cardNumberField.bottomAnchor, constant: 20),
            cvvField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cvvField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4, constant: -30),
            cvvField.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.topAnchor.constraint(equalTo: expirationField.bottomAnchor, constant: 40),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 16),
            cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupConstraints() {
        // Additional setup if needed
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    @objc private func cardNumberChanged() {
        guard let text = cardNumberField.text else { return }
        
        // Detect card type and update icon
        let cardType = detectCardType(text.replacingOccurrences(of: " ", with: ""))
        updateCardTypeIcon(cardType)
        
        // Format the card number
        let formatted = formatCardNumber(text, cardType: cardType)
        if formatted != text {
            cardNumberField.text = formatted
        }
    }
    
    private func detectCardType(_ number: String) -> String {
        if number.hasPrefix("4") {
            return "Visa"
        } else if let prefix = Int(number.prefix(2)), (51...55).contains(prefix) {
            return "Mastercard"
        } else if let prefix = Int(number.prefix(4)), (2221...2720).contains(prefix) {
            return "Mastercard"
        } else if number.hasPrefix("34") || number.hasPrefix("37") {
            return "American Express"
        } else if number.hasPrefix("6011") || number.hasPrefix("65") {
            return "Discover"
        } else if let prefix = Int(number.prefix(3)), (644...649).contains(prefix) {
            return "Discover"
        } else if number.hasPrefix("36") || number.hasPrefix("38") {
            return "Diners Club"
        } else if let prefix = Int(number.prefix(3)), (300...305).contains(prefix) {
            return "Diners Club"
        }
        return "Unknown"
    }
    
    private func updateCardTypeIcon(_ cardType: String) {
        guard let iconView = cardNumberField.rightView as? UIImageView else { return }
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        
        switch cardType {
        case "Visa":
            iconView.image = UIImage(systemName: "creditcard", withConfiguration: config)
            iconView.tintColor = .systemBlue
        case "Mastercard":
            iconView.image = UIImage(systemName: "creditcard", withConfiguration: config)
            iconView.tintColor = .systemOrange
        case "American Express":
            iconView.image = UIImage(systemName: "creditcard", withConfiguration: config)
            iconView.tintColor = .systemTeal
        case "Discover":
            iconView.image = UIImage(systemName: "creditcard", withConfiguration: config)
            iconView.tintColor = .systemPurple
        case "Diners Club":
            iconView.image = UIImage(systemName: "creditcard", withConfiguration: config)
            iconView.tintColor = .systemIndigo
        default:
            iconView.image = UIImage(systemName: "creditcard", withConfiguration: config)
            iconView.tintColor = .systemGray
        }
    }
    
    private func formatCardNumber(_ text: String, cardType: String) -> String {
        let cleaned = text.replacingOccurrences(of: " ", with: "")
        var formatted = ""
        
        switch cardType {
        case "American Express":
            // 4-6-5 format (15 digits)
            for (index, character) in cleaned.enumerated() {
                if index == 4 || index == 10 {
                    formatted += " "
                }
                formatted += String(character)
                if index >= 14 { break } // Max 15 digits
            }
        case "Diners Club":
            // 4-6-4 format (14 digits)
            for (index, character) in cleaned.enumerated() {
                if index == 4 || index == 10 {
                    formatted += " "
                }
                formatted += String(character)
                if index >= 13 { break } // Max 14 digits
            }
        default:
            // 4-4-4-4 format (16 digits)
            for (index, character) in cleaned.enumerated() {
                if index > 0 && index % 4 == 0 {
                    formatted += " "
                }
                formatted += String(character)
                if index >= 15 { break } // Max 16 digits
            }
        }
        
        return formatted
    }
    
    @objc private func datePickerChanged() {
        expirationField.text = dateFormatter.string(from: expirationDatePicker.date)
    }
    
    @objc private func dismissDatePicker() {
        expirationField.resignFirstResponder()
    }
    
    @objc private func submitTapped() {
        guard let cardNumber = cardNumberField.text, !cardNumber.isEmpty,
              let expiration = expirationField.text, !expiration.isEmpty,
              let cvv = cvvField.text, !cvv.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill in all fields")
            return
        }
        
        // Extract month and year
        let components = expiration.split(separator: "/")
        guard components.count == 2 else {
            showAlert(title: "Invalid Date", message: "Please select a valid expiration date")
            return
        }
        
        let cardData = CardData(
            cardNumber: cardNumber,
            expirationMonth: String(components[0]),
            expirationYear: String(components[1]),
            cvv: cvv
        )
        
        delegate?.tokenViewController(self, didCollectCardData: cardData)
    }
    
    @objc private func cancelTapped() {
        delegate?.tokenViewControllerDidCancel(self)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextField Delegate
extension DatacapTokenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberField {
            // Only allow numbers
            let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: " "))
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // Handle max length based on card type
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let cleaned = prospectiveText.replacingOccurrences(of: " ", with: "")
            
            let cardType = detectCardType(cleaned)
            let maxLength: Int
            switch cardType {
            case "American Express": maxLength = 15
            case "Diners Club": maxLength = 14
            default: maxLength = 16
            }
            
            return cleaned.count <= maxLength
        } else if textField == cvvField {
            // Only allow numbers for CVV
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // CVV length based on card type
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            let cardType = detectCardType(cardNumberField.text?.replacingOccurrences(of: " ", with: "") ?? "")
            let maxLength = cardType == "American Express" ? 4 : 3
            
            return prospectiveText.count <= maxLength
        }
        
        return true
    }
}