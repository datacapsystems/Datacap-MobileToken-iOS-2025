//
//  TransactionViewController.swift
//  DatacapMobileTokenDemo
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

import UIKit

// MARK: - Transaction Model

struct Transaction {
    let id: String
    let amount: Double
    let token: String
    let maskedCard: String
    let cardType: String
    let status: TransactionStatus
    let responseCode: String?
    let responseMessage: String?
    let timestamp: Date
    
    enum TransactionStatus {
        case pending
        case processing
        case approved
        case declined
        case error
    }
}

// MARK: - Pay API Service

class PayAPIService {
    
    private let apiKey: String
    private let mode: String
    private let baseURL: String
    
    init(apiKey: String, mode: String) {
        self.apiKey = apiKey
        self.mode = mode
        
        switch mode {
        case "certification":
            self.baseURL = "https://pay-cert.dcap.com/v2"
        case "production":
            self.baseURL = "https://pay.dcap.com/v2"
        default:
            self.baseURL = "" // Demo mode - no real API calls
        }
    }
    
    func processSale(token: String, amount: Double, completion: @escaping (Result<Transaction, Error>) -> Void) {
        if mode == "demo" {
            // Demo mode - simulate success
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let transaction = Transaction(
                    id: "DEMO-\(UUID().uuidString.prefix(8))",
                    amount: amount,
                    token: token,
                    maskedCard: "****DEMO",
                    cardType: "Demo Card",
                    status: .approved,
                    responseCode: "00",
                    responseMessage: "Demo transaction approved",
                    timestamp: Date()
                )
                completion(.success(transaction))
            }
            return
        }
        
        // Real API call
        guard let url = URL(string: "\(baseURL)/sale") else {
            completion(.failure(PayAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(apiKey.data(using: .utf8)?.base64EncodedString() ?? "")", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "token": token,
            "amount": Int(amount * 100), // Convert to cents
            "currency": "USD",
            "test": mode == "certification"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(.failure(PayAPIError.invalidResponse))
                return
            }
            
            let transaction = Transaction(
                id: json["transactionId"] as? String ?? UUID().uuidString,
                amount: amount,
                token: token,
                maskedCard: json["maskedCard"] as? String ?? "****",
                cardType: json["cardType"] as? String ?? "Unknown",
                status: (json["responseCode"] as? String == "00") ? .approved : .declined,
                responseCode: json["responseCode"] as? String,
                responseMessage: json["responseMessage"] as? String,
                timestamp: Date()
            )
            
            completion(.success(transaction))
        }.resume()
    }
}

enum PayAPIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API endpoint"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}

// MARK: - Transaction View Controller

class TransactionViewController: UIViewController {
    
    // MARK: - Properties
    
    private var payAPI: PayAPIService?
    private var savedTokens: [DatacapToken] = []
    private var selectedToken: DatacapToken?
    private var currentAmount: Double = 0.0
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    private let amountSection = UIView()
    private let amountLabel = UILabel()
    private let amountDisplay = UILabel()
    private let numberPad = UIView()
    
    private let tokenSection = UIView()
    private let tokenSectionTitle = UILabel()
    private let tokenScrollView = UIScrollView()
    private let tokenStackView = UIStackView()
    private let noTokensLabel = UILabel()
    
    private let processButton = UIButton(type: .system)
    private let loadingView = LiquidGlassLoadingView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAPI()
        setupUI()
        setupConstraints()
        loadSavedTokens()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    // MARK: - Setup
    
    private func setupAPI() {
        let mode = UserDefaults.standard.string(forKey: "DatacapOperationMode") ?? "demo"
        let apiKey = UserDefaults.standard.string(forKey: "DatacapPublicKey") ?? ""
        
        payAPI = PayAPIService(apiKey: apiKey, mode: mode)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Content container
        contentView.backgroundColor = UIColor.Datacap.lightBackground
        contentView.layer.cornerRadius = 24
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        
        // Header
        titleLabel.text = "Process Transaction"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor.Datacap.darkGray
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        // Amount section
        amountSection.applyLiquidGlass(intensity: 0.85, cornerRadius: 16, shadowOpacity: 0.05)
        
        amountLabel.text = "Transaction Amount"
        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.textColor = UIColor.Datacap.darkGray
        
        amountDisplay.text = "$0.00"
        amountDisplay.font = .monospacedSystemFont(ofSize: 48, weight: .bold)
        amountDisplay.textColor = UIColor.Datacap.nearBlack
        amountDisplay.textAlignment = .center
        
        setupNumberPad()
        
        // Token section
        tokenSection.applyLiquidGlass(intensity: 0.85, cornerRadius: 16, shadowOpacity: 0.05)
        
        tokenSectionTitle.text = "Select Token"
        tokenSectionTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        tokenSectionTitle.textColor = UIColor.Datacap.darkGray
        
        tokenScrollView.showsHorizontalScrollIndicator = false
        tokenStackView.axis = .horizontal
        tokenStackView.spacing = 12
        tokenStackView.distribution = .fillEqually
        
        noTokensLabel.text = "No saved tokens. Generate a token first."
        noTokensLabel.font = .systemFont(ofSize: 14, weight: .regular)
        noTokensLabel.textColor = UIColor.Datacap.blueGray
        noTokensLabel.textAlignment = .center
        noTokensLabel.numberOfLines = 0
        
        // Process button
        processButton.setTitle("Process Transaction", for: .normal)
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0)
        processButton.backgroundColor = darkRed
        processButton.setTitleColor(.white, for: .normal)
        processButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)  // Match main button
        processButton.layer.cornerRadius = 16
        processButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)  // Match main button padding
        processButton.layer.shadowColor = darkRed.cgColor
        processButton.layer.shadowOpacity = 0.3  // Match main button shadow
        processButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        processButton.layer.shadowRadius = 8
        processButton.addTarget(self, action: #selector(processTapped), for: .touchUpInside)
        processButton.isEnabled = false
        processButton.alpha = 0.6
        
        // Loading view
        loadingView.isHidden = true
        
        // Add to view hierarchy
        view.addSubview(contentView)
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        
        scrollView.addSubview(amountSection)
        amountSection.addSubview(amountLabel)
        amountSection.addSubview(amountDisplay)
        amountSection.addSubview(numberPad)
        
        scrollView.addSubview(tokenSection)
        tokenSection.addSubview(tokenSectionTitle)
        tokenSection.addSubview(tokenScrollView)
        tokenScrollView.addSubview(tokenStackView)
        tokenSection.addSubview(noTokensLabel)
        
        scrollView.addSubview(processButton)
        scrollView.addSubview(loadingView)
    }
    
    private func setupNumberPad() {
        let buttons = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            [".", "0", "⌫"]
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for row in buttons {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8
            
            for digit in row {
                let button = UIButton(type: .system)
                button.setTitle(digit, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
                button.setTitleColor(UIColor.Datacap.nearBlack, for: .normal)
                button.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                button.layer.cornerRadius = 12
                button.addTarget(self, action: #selector(numberPadTapped(_:)), for: .touchUpInside)
                
                // Add press animation
                button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
                button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
                
                rowStack.addArrangedSubview(button)
            }
            
            stackView.addArrangedSubview(rowStack)
        }
        
        numberPad.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: numberPad.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: numberPad.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: numberPad.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: numberPad.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        amountSection.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountDisplay.translatesAutoresizingMaskIntoConstraints = false
        numberPad.translatesAutoresizingMaskIntoConstraints = false
        tokenSection.translatesAutoresizingMaskIntoConstraints = false
        tokenSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        tokenScrollView.translatesAutoresizingMaskIntoConstraints = false
        tokenStackView.translatesAutoresizingMaskIntoConstraints = false
        noTokensLabel.translatesAutoresizingMaskIntoConstraints = false
        processButton.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Content view
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9),
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Amount section
            amountSection.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            amountSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            amountSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            amountLabel.topAnchor.constraint(equalTo: amountSection.topAnchor, constant: 16),
            amountLabel.leadingAnchor.constraint(equalTo: amountSection.leadingAnchor, constant: 16),
            
            amountDisplay.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8),
            amountDisplay.leadingAnchor.constraint(equalTo: amountSection.leadingAnchor, constant: 16),
            amountDisplay.trailingAnchor.constraint(equalTo: amountSection.trailingAnchor, constant: -16),
            
            numberPad.topAnchor.constraint(equalTo: amountDisplay.bottomAnchor, constant: 16),
            numberPad.leadingAnchor.constraint(equalTo: amountSection.leadingAnchor, constant: 16),
            numberPad.trailingAnchor.constraint(equalTo: amountSection.trailingAnchor, constant: -16),
            numberPad.bottomAnchor.constraint(equalTo: amountSection.bottomAnchor, constant: -16),
            
            // Token section
            tokenSection.topAnchor.constraint(equalTo: amountSection.bottomAnchor, constant: 16),
            tokenSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            tokenSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            tokenSection.heightAnchor.constraint(equalToConstant: 140),
            
            tokenSectionTitle.topAnchor.constraint(equalTo: tokenSection.topAnchor, constant: 16),
            tokenSectionTitle.leadingAnchor.constraint(equalTo: tokenSection.leadingAnchor, constant: 16),
            
            tokenScrollView.topAnchor.constraint(equalTo: tokenSectionTitle.bottomAnchor, constant: 12),
            tokenScrollView.leadingAnchor.constraint(equalTo: tokenSection.leadingAnchor, constant: 16),
            tokenScrollView.trailingAnchor.constraint(equalTo: tokenSection.trailingAnchor, constant: -16),
            tokenScrollView.bottomAnchor.constraint(equalTo: tokenSection.bottomAnchor, constant: -16),
            
            tokenStackView.topAnchor.constraint(equalTo: tokenScrollView.topAnchor),
            tokenStackView.leadingAnchor.constraint(equalTo: tokenScrollView.leadingAnchor),
            tokenStackView.trailingAnchor.constraint(equalTo: tokenScrollView.trailingAnchor),
            tokenStackView.bottomAnchor.constraint(equalTo: tokenScrollView.bottomAnchor),
            tokenStackView.heightAnchor.constraint(equalTo: tokenScrollView.heightAnchor),
            
            noTokensLabel.centerXAnchor.constraint(equalTo: tokenSection.centerXAnchor),
            noTokensLabel.centerYAnchor.constraint(equalTo: tokenScrollView.centerYAnchor),
            noTokensLabel.leadingAnchor.constraint(equalTo: tokenSection.leadingAnchor, constant: 32),
            noTokensLabel.trailingAnchor.constraint(equalTo: tokenSection.trailingAnchor, constant: -32),
            
            // Process button
            processButton.topAnchor.constraint(equalTo: tokenSection.bottomAnchor, constant: 32),
            processButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            processButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            processButton.heightAnchor.constraint(equalToConstant: 56),
            processButton.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -24),
            
            // Loading view
            loadingView.centerXAnchor.constraint(equalTo: processButton.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: processButton.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 60),
            loadingView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Token Management
    
    private func loadSavedTokens() {
        // Load saved tokens from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "SavedDatacapTokens"),
           let tokens = try? JSONDecoder().decode([SavedToken].self, from: data) {
            savedTokens = tokens.map { savedToken in
                DatacapToken(
                    token: savedToken.token,
                    maskedCardNumber: savedToken.maskedCardNumber,
                    cardType: savedToken.cardType,
                    expirationDate: savedToken.expirationDate,
                    responseCode: "00",
                    responseMessage: "Saved token",
                    timestamp: savedToken.timestamp
                )
            }
        }
        
        updateTokenDisplay()
    }
    
    private func updateTokenDisplay() {
        // Clear existing token views
        tokenStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if savedTokens.isEmpty {
            noTokensLabel.isHidden = false
            tokenScrollView.isHidden = true
        } else {
            noTokensLabel.isHidden = true
            tokenScrollView.isHidden = false
            
            for token in savedTokens {
                let tokenCard = createTokenCard(for: token)
                tokenStackView.addArrangedSubview(tokenCard)
            }
        }
    }
    
    private func createTokenCard(for token: DatacapToken) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.clear.cgColor
        
        let cardTypeLabel = UILabel()
        cardTypeLabel.text = token.cardType
        cardTypeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        cardTypeLabel.textColor = UIColor.Datacap.darkGray
        
        let maskedNumberLabel = UILabel()
        maskedNumberLabel.text = token.maskedCardNumber
        maskedNumberLabel.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        maskedNumberLabel.textColor = UIColor.Datacap.nearBlack
        
        let expiryLabel = UILabel()
        expiryLabel.text = token.expirationDate
        expiryLabel.font = .systemFont(ofSize: 12, weight: .regular)
        expiryLabel.textColor = UIColor.Datacap.blueGray
        
        card.addSubview(cardTypeLabel)
        card.addSubview(maskedNumberLabel)
        card.addSubview(expiryLabel)
        
        cardTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        maskedNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        expiryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalToConstant: 180),  // Increased width for better padding
            
            cardTypeLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            cardTypeLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            
            maskedNumberLabel.topAnchor.constraint(equalTo: cardTypeLabel.bottomAnchor, constant: 4),
            maskedNumberLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            maskedNumberLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),  // Add trailing constraint
            
            expiryLabel.topAnchor.constraint(equalTo: maskedNumberLabel.bottomAnchor, constant: 4),
            expiryLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            expiryLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -12)
        ])
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tokenCardTapped(_:)))
        card.addGestureRecognizer(tapGesture)
        card.isUserInteractionEnabled = true
        card.tag = savedTokens.firstIndex(where: { $0.token == token.token }) ?? 0
        
        return card
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        animateOut()
    }
    
    @objc private func numberPadTapped(_ sender: UIButton) {
        guard let digit = sender.title(for: .normal) else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        var amountString = String(format: "%.2f", currentAmount)
        
        if digit == "⌫" {
            // Backspace
            if currentAmount > 0 {
                amountString = amountString.replacingOccurrences(of: ".", with: "")
                amountString = String(amountString.dropLast())
                if amountString.isEmpty {
                    amountString = "0"
                }
                currentAmount = Double(amountString)! / 100.0
            }
        } else if digit == "." {
            // Ignore decimal point (we handle it automatically)
            return
        } else {
            // Add digit
            amountString = amountString.replacingOccurrences(of: ".", with: "")
            amountString += digit
            currentAmount = Double(amountString)! / 100.0
            
            // Limit to reasonable amount
            if currentAmount > 99999.99 {
                currentAmount = 99999.99
            }
        }
        
        updateUI()
    }
    
    @objc private func tokenCardTapped(_ gesture: UITapGestureRecognizer) {
        guard let card = gesture.view,
              card.tag < savedTokens.count else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        // Deselect all cards
        tokenStackView.arrangedSubviews.forEach { view in
            view.layer.borderColor = UIColor.clear.cgColor
        }
        
        // Select this card
        card.layer.borderColor = UIColor.Datacap.primaryRed.cgColor
        selectedToken = savedTokens[card.tag]
        
        updateUI()
    }
    
    @objc private func processTapped() {
        guard let token = selectedToken,
              currentAmount > 0,
              let payAPI = payAPI else { return }
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Show loading
        processButton.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
        
        // Process transaction
        payAPI.processSale(token: token.token, amount: currentAmount) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingView.stopAnimating()
                self?.loadingView.isHidden = true
                self?.processButton.isHidden = false
                
                switch result {
                case .success(let transaction):
                    self?.presentTransactionResult(transaction)
                case .failure(let error):
                    self?.presentError(error)
                }
            }
        }
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    
    // MARK: - UI Updates
    
    private func updateUI() {
        amountDisplay.text = String(format: "$%.2f", currentAmount)
        
        let canProcess = currentAmount > 0 && selectedToken != nil
        processButton.isEnabled = canProcess
        processButton.alpha = canProcess ? 1.0 : 0.6
    }
    
    // MARK: - Result Presentation
    
    private func presentTransactionResult(_ transaction: Transaction) {
        let resultView = createTransactionResultView(transaction)
        presentCustomAlert(view: resultView)
    }
    
    private func presentError(_ error: Error) {
        let errorView = createErrorView(error: error)
        presentCustomAlert(view: errorView)
    }
    
    private func createTransactionResultView(_ transaction: Transaction) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.Datacap.lightBackground
        container.layer.cornerRadius = 24
        container.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.15)
        
        let iconView = UIImageView()
        let iconName = transaction.status == .approved ? "checkmark.circle.fill" : "xmark.circle.fill"
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = transaction.status == .approved ? UIColor.systemGreen : UIColor.systemRed
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = transaction.status == .approved ? "Transaction Approved!" : "Transaction Declined"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        
        let amountLabel = UILabel()
        amountLabel.text = String(format: "$%.2f", transaction.amount)
        amountLabel.font = .monospacedSystemFont(ofSize: 36, weight: .bold)
        amountLabel.textColor = UIColor.Datacap.primaryRed
        amountLabel.textAlignment = .center
        
        let detailsLabel = UILabel()
        detailsLabel.text = """
        Transaction ID: \(transaction.id)
        Card: \(transaction.cardType) \(transaction.maskedCard)
        \(transaction.responseMessage ?? "")
        """
        detailsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        detailsLabel.textColor = UIColor.Datacap.darkGray
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = UIColor.Datacap.primaryRed
        doneButton.layer.cornerRadius = 12
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        doneButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        doneButton.addTarget(self, action: #selector(dismissResultAndClose), for: .touchUpInside)
        
        // Add subviews
        [iconView, titleLabel, amountLabel, detailsLabel, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 320),
            
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            amountLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            amountLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            detailsLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            detailsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            doneButton.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 24),
            doneButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -32)
        ])
        
        return container
    }
    
    private func createErrorView(error: Error) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.Datacap.lightBackground
        container.layer.cornerRadius = 24
        container.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.15)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        iconView.tintColor = UIColor.systemOrange
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = "Transaction Error"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel()
        messageLabel.text = error.localizedDescription
        messageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = UIColor.Datacap.darkGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("OK", for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = UIColor.Datacap.primaryRed
        retryButton.layer.cornerRadius = 12
        retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        retryButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        // Add subviews
        [iconView, titleLabel, messageLabel, retryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 300),
            
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 32),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            retryButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            retryButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -32)
        ])
        
        return container
    }
    
    private func presentCustomAlert(view: UIView) {
        let alertContainer = UIView()
        alertContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alertContainer.alpha = 0
        alertContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.alpha = 0
        
        self.view.addSubview(alertContainer)
        alertContainer.addSubview(view)
        
        NSLayoutConstraint.activate([
            alertContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
            alertContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            alertContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            alertContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            view.centerXAnchor.constraint(equalTo: alertContainer.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: alertContainer.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            alertContainer.alpha = 1
            view.transform = .identity
            view.alpha = 1
        }
        
        alertContainer.tag = 999
    }
    
    @objc private func dismissAlert() {
        guard let alertContainer = view.viewWithTag(999) else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            alertContainer.alpha = 0
        }) { _ in
            alertContainer.removeFromSuperview()
        }
    }
    
    @objc private func dismissResultAndClose() {
        dismissAlert()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateOut()
        }
    }
    
    // MARK: - Animations
    
    private func animateIn() {
        contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.contentView.transform = .identity
        })
    }
    
    private func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
}

// MARK: - Saved Token Model
// SavedToken struct is now defined in DatacapTokenService.swift