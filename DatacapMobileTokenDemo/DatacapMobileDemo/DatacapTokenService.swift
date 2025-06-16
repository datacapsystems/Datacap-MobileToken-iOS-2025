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
    private var isCertification: Bool
    
    init(publicKey: String, isCertification: Bool = true) {
        self.publicKey = publicKey
        self.isCertification = isCertification
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
        // In a real implementation, this would make an API call to Datacap's servers
        // For demo purposes, we'll generate a mock token
        
        let tokenData = "\(cardData.cardNumber):\(cardData.expirationMonth)/\(cardData.expirationYear):\(cardData.cvv):\(Date().timeIntervalSince1970)"
        let token = tokenData.data(using: .utf8)?.base64EncodedString() ?? ""
        
        return DatacapToken(
            token: "DC_\(token.prefix(32))",
            maskedCardNumber: maskCardNumber(cardData.cardNumber),
            cardType: detectCardType(cardData.cardNumber),
            expirationDate: "\(cardData.expirationMonth)/\(cardData.expirationYear)",
            responseCode: "00",
            responseMessage: "Success",
            timestamp: Date()
        )
    }
}

// MARK: - Token View Controller Delegate
extension DatacapTokenService: DatacapTokenViewControllerDelegate {
    func tokenViewController(_ controller: DatacapTokenViewController, didCollectCardData cardData: CardData) {
        // Validate card data
        guard validateCardNumber(cardData.cardNumber) else {
            delegate?.tokenRequestDidFail(error: .invalidCardNumber)
            return
        }
        
        // Generate token (in production, this would be an API call)
        let token = generateToken(for: cardData)
        
        // Dismiss the view controller
        controller.dismiss(animated: true) {
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
    private let cvvField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
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
        expirationField.keyboardType = .numberPad
        expirationField.borderStyle = .roundedRect
        expirationField.delegate = self
        
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
    
    @objc private func submitTapped() {
        guard let cardNumber = cardNumberField.text, !cardNumber.isEmpty,
              let expiration = expirationField.text, !expiration.isEmpty,
              let cvv = cvvField.text, !cvv.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        // Parse expiration date
        let components = expiration.split(separator: "/")
        guard components.count == 2,
              let month = String(components[0]).count == 2 ? String(components[0]) : nil,
              let year = String(components[1]).count == 2 ? String(components[1]) : nil else {
            showAlert(title: "Error", message: "Invalid expiration date format")
            return
        }
        
        let cardData = CardData(
            cardNumber: cardNumber,
            expirationMonth: month,
            expirationYear: year,
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

// MARK: - Text Field Delegate
extension DatacapTokenViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        
        if textField == cardNumberField {
            // Format card number with spaces
            let cleaned = newText.replacingOccurrences(of: " ", with: "")
            if cleaned.count > 19 { return false }
            
            var formatted = ""
            for (index, character) in cleaned.enumerated() {
                if index > 0 && index % 4 == 0 {
                    formatted += " "
                }
                formatted += String(character)
            }
            textField.text = formatted
            return false
        } else if textField == expirationField {
            // Format MM/YY
            let cleaned = newText.replacingOccurrences(of: "/", with: "")
            if cleaned.count > 4 { return false }
            
            if cleaned.count >= 2 {
                let month = cleaned.prefix(2)
                let year = cleaned.dropFirst(2)
                textField.text = "\(month)/\(year)"
                return false
            }
        } else if textField == cvvField {
            // Limit CVV to 4 digits
            if newText.count > 4 { return false }
        }
        
        return true
    }
}