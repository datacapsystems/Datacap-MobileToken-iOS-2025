//
//  DatacapTokenService.swift
//  DatacapMobileTokenDemo
//
//  Modern Swift implementation of Datacap tokenization
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
        }
    }
}

// MARK: - Main Service Class
class DatacapTokenService {
    
    weak var delegate: DatacapTokenServiceDelegate?
    private var publicKey: String
    private var mode: String
    private var apiEndpoint: String?
    
    init(publicKey: String, mode: String = "demo", apiEndpoint: String? = nil) {
        self.publicKey = publicKey
        self.mode = mode
        self.apiEndpoint = apiEndpoint
    }
    
    // MARK: - Public Methods
    
    func requestToken(from viewController: UIViewController) {
        let tokenViewController = DatacapTokenViewController()
        tokenViewController.delegate = self
        tokenViewController.modalPresentationStyle = .fullScreen
        viewController.present(tokenViewController, animated: true)
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
            switch ((idx % 2 == 1), digit) {
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
        } else if cleaned.hasPrefix("5") && cleaned.count >= 2 {
            let prefix = Int(cleaned.prefix(2)) ?? 0
            if prefix >= 51 && prefix <= 55 {
                return "Mastercard"
            }
        } else if cleaned.hasPrefix("3") && cleaned.count >= 2 {
            let prefix = cleaned.prefix(2)
            if prefix == "34" || prefix == "37" {
                return "American Express"
            } else if prefix == "30" || prefix == "36" || prefix == "38" {
                return "Diners Club"
            }
        } else if cleaned.hasPrefix("6") {
            return "Discover"
        }
        
        return "Unknown"
    }
    
    private func maskCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        guard cleaned.count >= 4 else { return cleaned }
        
        let lastFour = cleaned.suffix(4)
        let masked = String(repeating: "*", count: cleaned.count - 4)
        return masked + lastFour
    }
    
    private func generateToken(for cardData: CardData) -> DatacapToken {
        if mode != "demo", let apiURL = apiEndpoint {
            // CERTIFICATION/PRODUCTION MODE: Real API call
            let modeLabel = mode == "certification" ? "CERTIFICATION" : "PRODUCTION"
            print("🔐 \(modeLabel) MODE: Using real tokenization API")
            
            let cleanedCardNumber = cardData.cardNumber.replacingOccurrences(of: " ", with: "")
            
            let requestBody: [String: Any] = [
                "publicKey": publicKey,
                "cardNumber": cleanedCardNumber,
                "expirationMonth": cardData.expirationMonth,
                "expirationYear": cardData.expirationYear,
                "cvv": cardData.cvv,
                "isCertification": mode == "certification"
            ]
            
            guard let url = URL(string: apiURL) else {
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
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            
            // In production, use async/await or completion handlers
            let semaphore = DispatchSemaphore(value: 0)
            var responseData: Data?
            var urlResponse: URLResponse?
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                responseData = data
                urlResponse = response
                semaphore.signal()
            }.resume()
            
            semaphore.wait()
            
            if let error = urlResponse as? HTTPURLResponse, error.statusCode != 200 {
                return DatacapToken(
                    token: "",
                    maskedCardNumber: maskCardNumber(cardData.cardNumber),
                    cardType: detectCardType(cardData.cardNumber),
                    expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                    responseCode: "\(error.statusCode)",
                    responseMessage: "API Error: HTTP \(error.statusCode)",
                    timestamp: Date()
                )
            }
            
            if let data = responseData,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                if let errorMessage = json["error"] as? String {
                    // Handle API error
                    return DatacapToken(
                        token: "",
                        maskedCardNumber: maskCardNumber(cardData.cardNumber),
                        cardType: detectCardType(cardData.cardNumber),
                        expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                        responseCode: "999",
                        responseMessage: errorMessage,
                        timestamp: Date()
                    )
                }
                
                // Success response
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
            }
            
            return DatacapToken(
                token: "",
                maskedCardNumber: maskCardNumber(cardData.cardNumber),
                cardType: detectCardType(cardData.cardNumber),
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: "999",
                responseMessage: "Failed to parse API response",
                timestamp: Date()
            )
        } else {
            // DEMO MODE: Generate mock token
            print("⚠️ DEMO MODE: Using mock tokenization.")
            print("To use real tokenization, tap the settings icon and configure your API.")
            
            let tokenData = "DEMO_\(cardData.cardNumber):\(cardData.expirationMonth)/\(cardData.expirationYear):\(Date().timeIntervalSince1970)"
            let token = tokenData.data(using: .utf8)?.base64EncodedString() ?? ""
            
            return DatacapToken(
                token: "DC_\(token.prefix(20))...DEMO",
                maskedCardNumber: maskCardNumber(cardData.cardNumber),
                cardType: detectCardType(cardData.cardNumber),
                expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
                responseCode: "00",
                responseMessage: "Demo Mode - Success",
                timestamp: Date()
            )
        }
    }
}

// MARK: - Token View Controller Delegate
extension DatacapTokenService: DatacapTokenViewControllerDelegate {
    func tokenViewController(_ controller: DatacapTokenViewController, didCollectCardData cardData: CardData) {
        print("DatacapTokenService received card data!")
        
        // Validate card data
        let cleanedNumber = cardData.cardNumber.replacingOccurrences(of: " ", with: "")
        print("Validating card number: \(cleanedNumber)")
        
        guard validateCardNumber(cleanedNumber) else {
            print("Card validation failed!")
            // Dismiss the card input view first, then show error
            controller.dismiss(animated: true) {
                self.delegate?.tokenRequestDidFail(error: .invalidCardNumber)
            }
            return
        }
        
        print("Card validation passed!")
        
        // Generate token (in production, this would be an API call)
        let token = generateToken(for: cardData)
        print("Generated token: \(token.token)")
        
        // Check if token generation failed (responseCode not "00")
        if token.responseCode != "00" && !token.responseCode.isEmpty {
            print("Token generation failed with response code: \(token.responseCode)")
            // Dismiss the card input view first, then show error
            controller.dismiss(animated: true) {
                let error = DatacapTokenError.tokenizationFailed(token.responseMessage)
                self.delegate?.tokenRequestDidFail(error: error)
            }
            return
        }
        
        // Dismiss the view controller
        controller.dismiss(animated: true) {
            print("View dismissed, calling success delegate")
            self.delegate?.tokenRequestDidSucceed(token)
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
        view.backgroundColor = UIColor(red: 246/255, green: 249/255, blue: 252/255, alpha: 1.0)
        
        // Configure text fields
        cardNumberField.placeholder = "Card Number"
        cardNumberField.keyboardType = .numberPad
        cardNumberField.borderStyle = .roundedRect
        cardNumberField.delegate = self
        
        expirationField.placeholder = "MM/YY"
        expirationField.borderStyle = .roundedRect
        expirationField.delegate = self
        
        // Configure date picker
        expirationDatePicker.datePickerMode = .date
        expirationDatePicker.preferredDatePickerStyle = .wheels
        expirationDatePicker.minimumDate = Date()
        expirationDatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 20, to: Date())
        expirationDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        // Set date picker as input view for expiration field
        expirationField.inputView = expirationDatePicker
        
        // Add toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        expirationField.inputAccessoryView = toolbar
        
        cvvField.placeholder = "CVV"
        cvvField.keyboardType = .numberPad
        cvvField.borderStyle = .roundedRect
        cvvField.isSecureTextEntry = true
        cvvField.delegate = self
        
        // Configure buttons
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor(red: 148/255, green: 26/255, blue: 37/255, alpha: 1.0)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 148/255, green: 26/255, blue: 37/255, alpha: 1.0), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cardNumberField.translatesAutoresizingMaskIntoConstraints = false
        expirationField.translatesAutoresizingMaskIntoConstraints = false
        cvvField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardNumberField)
        contentView.addSubview(expirationField)
        contentView.addSubview(cvvField)
        contentView.addSubview(submitButton)
        contentView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Card number field
            cardNumberField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            cardNumberField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardNumberField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardNumberField.heightAnchor.constraint(equalToConstant: 44),
            
            // Expiration field
            expirationField.topAnchor.constraint(equalTo: cardNumberField.bottomAnchor, constant: 20),
            expirationField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            expirationField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4, constant: -30),
            expirationField.heightAnchor.constraint(equalToConstant: 44),
            
            // CVV field
            cvvField.topAnchor.constraint(equalTo: cardNumberField.bottomAnchor, constant: 20),
            cvvField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cvvField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4, constant: -30),
            cvvField.heightAnchor.constraint(equalToConstant: 44),
            
            // Submit button
            submitButton.topAnchor.constraint(equalTo: expirationField.bottomAnchor, constant: 40),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Cancel button
            cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10),
            cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func datePickerChanged() {
        expirationField.text = dateFormatter.string(from: expirationDatePicker.date)
    }
    
    @objc private func dismissDatePicker() {
        expirationField.resignFirstResponder()
    }
    
    @objc private func submitTapped() {
        print("Submit button tapped!")
        
        guard let cardNumber = cardNumberField.text, !cardNumber.isEmpty,
              let expiration = expirationField.text, !expiration.isEmpty,
              let cvv = cvvField.text, !cvv.isEmpty else {
            print("Missing fields - Card: \(cardNumberField.text ?? "nil"), Exp: \(expirationField.text ?? "nil"), CVV: \(cvvField.text ?? "nil")")
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        // Parse expiration date from MM/yy format
        let components = expiration.split(separator: "/")
        guard components.count == 2,
              let month = String(components[0]).count == 2 ? String(components[0]) : nil,
              let year = String(components[1]).count == 2 ? String(components[1]) : nil else {
            print("Invalid expiration format: \(expiration)")
            showAlert(title: "Error", message: "Invalid expiration date format")
            return
        }
        
        print("Creating card data - Number: \(cardNumber), Month: \(month), Year: \(year), CVV: \(cvv)")
        
        let cardData = CardData(
            cardNumber: cardNumber,
            expirationMonth: month,
            expirationYear: year,
            cvv: cvv
        )
        
        print("Calling delegate with card data")
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
    
    // MARK: - Card Type Detection Helpers
    
    private func getMaxLengthForCardNumber(_ number: String) -> Int {
        if number.isEmpty { return 19 }
        
        // American Express: 15 digits
        if number.hasPrefix("34") || number.hasPrefix("37") {
            return 15
        }
        
        // Diners Club: 14 digits
        if number.hasPrefix("36") || number.hasPrefix("38") ||
           (number.hasPrefix("30") && number.count >= 3) {
            let prefix = number.prefix(3)
            if prefix >= "300" && prefix <= "305" {
                return 14
            }
        }
        
        // Discover: 16 digits
        if number.hasPrefix("6011") || number.hasPrefix("65") ||
           (number.hasPrefix("64") && number.count >= 3 && number.prefix(3) >= "644") {
            return 16
        }
        
        // Mastercard: 16 digits
        if number.count >= 2 {
            let prefix = Int(number.prefix(2)) ?? 0
            if (prefix >= 51 && prefix <= 55) || (prefix >= 22 && prefix <= 27) {
                return 16
            }
        }
        
        // Visa: 16 digits (can be 13-19, but most common is 16)
        if number.hasPrefix("4") {
            return 16
        }
        
        // Default to 16 for unknown types
        return 16
    }
    
    private func formatCardNumber(_ number: String) -> String {
        if number.isEmpty { return number }
        
        var formatted = ""
        
        // American Express: 4-6-5
        if number.hasPrefix("34") || number.hasPrefix("37") {
            for (index, character) in number.enumerated() {
                if index == 4 || index == 10 {
                    formatted += " "
                }
                formatted += String(character)
            }
            return formatted
        }
        
        // Diners Club: 4-6-4
        if number.hasPrefix("36") || number.hasPrefix("38") ||
           (number.hasPrefix("30") && number.count >= 3) {
            let prefix = number.prefix(3)
            if prefix >= "300" && prefix <= "305" {
                for (index, character) in number.enumerated() {
                    if index == 4 || index == 10 {
                        formatted += " "
                    }
                    formatted += String(character)
                }
                return formatted
            }
        }
        
        // Default formatting: 4-4-4-4
        for (index, character) in number.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted += String(character)
        }
        
        return formatted
    }
    
    private func updateCardNumberPlaceholder(for number: String) {
        if number.isEmpty {
            cardNumberField.placeholder = "Card Number"
            return
        }
        
        let maxLength = getMaxLengthForCardNumber(number)
        var cardType = ""
        
        // Detect card type for placeholder
        if number.hasPrefix("34") || number.hasPrefix("37") {
            cardType = "Amex"
        } else if number.hasPrefix("4") {
            cardType = "Visa"
        } else if number.count >= 2 {
            let prefix = Int(number.prefix(2)) ?? 0
            if (prefix >= 51 && prefix <= 55) || (prefix >= 22 && prefix <= 27) {
                cardType = "Mastercard"
            } else if number.hasPrefix("6011") || number.hasPrefix("65") {
                cardType = "Discover"
            } else if number.hasPrefix("36") || number.hasPrefix("38") {
                cardType = "Diners"
            }
        }
        
        if !cardType.isEmpty {
            cardNumberField.placeholder = "\(cardType) (\(maxLength) digits)"
        }
    }
    
    private func updateCVVPlaceholder(for cardNumber: String) {
        if cardNumber.hasPrefix("34") || cardNumber.hasPrefix("37") {
            cvvField.placeholder = "CVV (4 digits)"
        } else {
            cvvField.placeholder = "CVV (3 digits)"
        }
    }
}

// MARK: - Text Field Delegate
extension DatacapTokenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        
        if textField == cardNumberField {
            // Format card number with spaces
            let cleaned = newText.replacingOccurrences(of: " ", with: "")
            
            // Determine max length based on card type
            let maxLength = getMaxLengthForCardNumber(cleaned)
            if cleaned.count > maxLength { return false }
            
            // Format based on card type
            let formatted = formatCardNumber(cleaned)
            textField.text = formatted
            
            // Update placeholder to show expected length
            updateCardNumberPlaceholder(for: cleaned)
            
            // Update CVV placeholder based on card type
            updateCVVPlaceholder(for: cleaned)
            
            return false
        } else if textField == expirationField {
            // Prevent manual input - user must use date picker
            return false
        } else if textField == cvvField {
            // Limit CVV based on card type
            let cardNumber = cardNumberField.text?.replacingOccurrences(of: " ", with: "") ?? ""
            let maxCVV = (cardNumber.hasPrefix("34") || cardNumber.hasPrefix("37")) ? 4 : 3
            if newText.count > maxCVV { return false }
        }
        
        return true
    }
}