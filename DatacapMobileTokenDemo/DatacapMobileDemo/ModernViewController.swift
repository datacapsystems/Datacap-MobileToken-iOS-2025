//
//  ModernViewController.swift
//  DatacapMobileTokenDemo
//
//  Clean version focused on token generation library
//

import UIKit

class ModernViewController: UIViewController {
    
    // MARK: - Properties
    
    private var tokenService: DatacapTokenService!
    private var currentPublicKey: String = ""
    private var currentEndpoint: String = "https://api.datacapsystems.com/v1/tokenize"
    private var isCertification: Bool = true
    
    // MARK: - UI Components
    
    private let backgroundGradient = CAGradientLayer()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = UIColor.Datacap.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let modeIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .black
        return view
    }()
    
    private let modeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo.png")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Datacap Token Demo"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor.Datacap.nearBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test your payment tokenization integration"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.Datacap.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let getTokenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate Token", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var loadingView: LiquidGlassLoadingView = {
        let loading = LiquidGlassLoadingView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.isHidden = true
        return loading
    }()
    
    private let helpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        button.tintColor = UIColor.Datacap.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        updateModeIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor.Datacap.lightBackground
        
        // Background gradient
        backgroundGradient.colors = [
            UIColor.Datacap.lightBackground.cgColor,
            UIColor.white.cgColor,
            UIColor.Datacap.lightBackground.cgColor
        ]
        backgroundGradient.locations = [0, 0.5, 1]
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        // Glass morphism container
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        containerView.applyLiquidGlass(intensity: 0.9, cornerRadius: 32, shadowOpacity: 0.1)
        
        // Setup button with dark red color like Save Configuration
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0)
        getTokenButton.backgroundColor = darkRed
        getTokenButton.setTitleColor(.white, for: .normal)
        getTokenButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        getTokenButton.layer.cornerRadius = 16
        getTokenButton.layer.shadowColor = darkRed.cgColor
        getTokenButton.layer.shadowOpacity = 0.2
        getTokenButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        getTokenButton.layer.shadowRadius = 8
        getTokenButton.addTarget(self, action: #selector(getTokenTapped), for: .touchUpInside)
        
        // Settings button
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        // Help button
        helpButton.addTarget(self, action: #selector(helpTapped), for: .touchUpInside)
        
        // Add mode indicator
        modeIndicator.addSubview(modeLabel)
        
        // Add subviews
        view.addSubview(modeIndicator)
        view.addSubview(settingsButton)
        view.addSubview(helpButton)
        view.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(getTokenButton)
        containerView.addSubview(loadingView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Mode indicator
            modeIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            modeIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modeIndicator.heightAnchor.constraint(equalToConstant: 30),
            
            modeLabel.leadingAnchor.constraint(equalTo: modeIndicator.leadingAnchor, constant: 12),
            modeLabel.trailingAnchor.constraint(equalTo: modeIndicator.trailingAnchor, constant: -12),
            modeLabel.centerYAnchor.constraint(equalTo: modeIndicator.centerYAnchor),
            
            // Settings button
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Help button
            helpButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor),
            helpButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -8),
            helpButton.widthAnchor.constraint(equalToConstant: 44),
            helpButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Container
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 180),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            // Get Token Button
            getTokenButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            getTokenButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            getTokenButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            getTokenButton.heightAnchor.constraint(equalToConstant: 56),
            getTokenButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -48),
            
            // Loading view
            loadingView.centerXAnchor.constraint(equalTo: getTokenButton.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: getTokenButton.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 60),
            loadingView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Actions
    
    @objc private func getTokenTapped() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Load settings
        let savedPublicKey = UserDefaults.standard.string(forKey: "DatacapPublicKey") ?? ""
        let savedEndpoint = UserDefaults.standard.string(forKey: "DatacapAPIEndpoint") ?? "https://api.datacapsystems.com/v1/tokenize"
        let savedIsCertification = UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
        
        if savedPublicKey.isEmpty {
            presentCustomAlert(
                title: "Configuration Required",
                message: "Please configure your API settings before generating tokens.",
                actionTitle: "Go to Settings",
                action: { [weak self] in
                    self?.settingsTapped()
                }
            )
            return
        }
        
        // Show loading
        getTokenButton.isHidden = true
        loadingView.startAnimating()
        
        // Create token service
        tokenService = DatacapTokenService(
            publicKey: savedPublicKey,
            isCertification: savedIsCertification,
            apiEndpoint: savedEndpoint
        )
        tokenService.delegate = self
        
        // Request token
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tokenService.requestToken(from: self)
        }
    }
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        settingsVC.modalPresentationStyle = .pageSheet
        
        if let sheet = settingsVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(settingsVC, animated: true)
    }
    
    @objc private func helpTapped() {
        // Create a simple help overlay for now
        let helpView = createSimpleHelpOverlay()
        view.addSubview(helpView)
        
        NSLayoutConstraint.activate([
            helpView.topAnchor.constraint(equalTo: view.topAnchor),
            helpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            helpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            helpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Helpers
    
    private func updateModeIndicator() {
        let isCertification = UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
        modeLabel.text = isCertification ? "CERTIFICATION MODE" : "PRODUCTION MODE"
    }
    
    private func animateIn() {
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    private func presentCustomAlert(title: String, message: String, actionTitle: String = "OK", action: (() -> Void)? = nil) {
        // Create custom alert view
        let alertView = UIView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alertView.alpha = 0
        
        let alertCard = UIView()
        alertCard.translatesAutoresizingMaskIntoConstraints = false
        alertCard.backgroundColor = .white
        alertCard.layer.cornerRadius = 20
        alertCard.applyLiquidGlass(intensity: 0.95, cornerRadius: 20, shadowOpacity: 0.2)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = UIColor.Datacap.darkGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        let button = UIButton(type: .system)
        button.setTitle(actionTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0)
        button.backgroundColor = darkRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = darkRed.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        
        button.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.3, animations: {
                alertView.alpha = 0
                alertCard.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                alertView.removeFromSuperview()
                action?()
            }
        }, for: .touchUpInside)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(button)
        
        alertCard.addSubview(stackView)
        alertView.addSubview(alertCard)
        self.view.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            alertView.topAnchor.constraint(equalTo: self.view.topAnchor),
            alertView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            alertView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            alertCard.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            alertCard.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            alertCard.leadingAnchor.constraint(greaterThanOrEqualTo: alertView.leadingAnchor, constant: 40),
            alertCard.trailingAnchor.constraint(lessThanOrEqualTo: alertView.trailingAnchor, constant: -40),
            alertCard.widthAnchor.constraint(lessThanOrEqualToConstant: 340),
            
            stackView.topAnchor.constraint(equalTo: alertCard.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: alertCard.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: alertCard.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: alertCard.bottomAnchor, constant: -30),
            
            // Make button bigger
            button.heightAnchor.constraint(equalToConstant: 56),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
        
        alertCard.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.3) {
            alertView.alpha = 1
            alertCard.transform = .identity
        }
    }
}

// MARK: - DatacapTokenServiceDelegate

extension ModernViewController: DatacapTokenServiceDelegate {
    
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        resetTokenButton()
        
        // Create success view
        let successView = UIView()
        successView.translatesAutoresizingMaskIntoConstraints = false
        successView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        successView.alpha = 0
        
        let successCard = UIView()
        successCard.translatesAutoresizingMaskIntoConstraints = false
        successCard.backgroundColor = .white
        successCard.layer.cornerRadius = 24
        successCard.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkView.tintColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0) // Forest green
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        let successLabel = UILabel()
        successLabel.text = "Token Generated!"
        successLabel.font = .systemFont(ofSize: 24, weight: .bold)
        successLabel.textColor = UIColor.Datacap.nearBlack
        
        let tokenContainer = UIView()
        tokenContainer.backgroundColor = UIColor.Datacap.lightBackground
        tokenContainer.layer.cornerRadius = 12
        tokenContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let tokenTitleLabel = UILabel()
        tokenTitleLabel.text = "Token"
        tokenTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        tokenTitleLabel.textColor = UIColor.Datacap.darkGray
        tokenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tokenLabel = UILabel()
        tokenLabel.text = token.token
        tokenLabel.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        tokenLabel.textColor = UIColor.Datacap.nearBlack
        tokenLabel.numberOfLines = 0
        tokenLabel.textAlignment = .center
        tokenLabel.lineBreakMode = .byCharWrapping
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tokenContainer.addSubview(tokenTitleLabel)
        tokenContainer.addSubview(tokenLabel)
        
        let cardInfoLabel = UILabel()
        cardInfoLabel.text = "\(token.cardType) Token Generated"
        cardInfoLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cardInfoLabel.textColor = UIColor.Datacap.darkGray
        
        let copyButton = UIButton(type: .system)
        copyButton.setTitle("Copy Token", for: .normal)
        copyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        copyButton.setTitleColor(UIColor.Datacap.primaryRed, for: .normal)
        copyButton.addAction(UIAction { _ in
            UIPasteboard.general.string = token.token
            copyButton.setTitle("Copied!", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                copyButton.setTitle("Copy Token", for: .normal)
            }
        }, for: .touchUpInside)
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        doneButton.backgroundColor = UIColor.Datacap.primaryRed
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 12
        // Style done button
        doneButton.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.3, animations: {
                successView.alpha = 0
            }) { _ in
                successView.removeFromSuperview()
            }
        }, for: .touchUpInside)
        
        stackView.addArrangedSubview(checkmarkView)
        stackView.addArrangedSubview(successLabel)
        stackView.addArrangedSubview(tokenContainer)
        stackView.addArrangedSubview(cardInfoLabel)
        stackView.addArrangedSubview(copyButton)
        stackView.addArrangedSubview(doneButton)
        
        successCard.addSubview(stackView)
        successView.addSubview(successCard)
        view.addSubview(successView)
        
        NSLayoutConstraint.activate([
            successView.topAnchor.constraint(equalTo: view.topAnchor),
            successView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            successView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            successCard.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
            successCard.centerYAnchor.constraint(equalTo: successView.centerYAnchor),
            successCard.leadingAnchor.constraint(greaterThanOrEqualTo: successView.leadingAnchor, constant: 20),
            successCard.trailingAnchor.constraint(lessThanOrEqualTo: successView.trailingAnchor, constant: -20),
            successCard.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            
            stackView.topAnchor.constraint(equalTo: successCard.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: successCard.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: successCard.trailingAnchor, constant: -40),
            stackView.bottomAnchor.constraint(equalTo: successCard.bottomAnchor, constant: -40),
            
            checkmarkView.widthAnchor.constraint(equalToConstant: 80),
            checkmarkView.heightAnchor.constraint(equalToConstant: 80),
            
            tokenContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tokenContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            tokenContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            tokenTitleLabel.topAnchor.constraint(equalTo: tokenContainer.topAnchor, constant: 12),
            tokenTitleLabel.centerXAnchor.constraint(equalTo: tokenContainer.centerXAnchor),
            
            tokenLabel.topAnchor.constraint(equalTo: tokenTitleLabel.bottomAnchor, constant: 8),
            tokenLabel.leadingAnchor.constraint(equalTo: tokenContainer.leadingAnchor, constant: 16),
            tokenLabel.trailingAnchor.constraint(equalTo: tokenContainer.trailingAnchor, constant: -16),
            tokenLabel.bottomAnchor.constraint(equalTo: tokenContainer.bottomAnchor, constant: -12)
        ])
        
        // Animate in
        successCard.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            successView.alpha = 1
            successCard.transform = .identity
        }
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        resetTokenButton()
        
        presentCustomAlert(
            title: "Token Generation Failed",
            message: error.localizedDescription,
            actionTitle: "Try Again"
        )
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.error)
    }
    
    func tokenRequestDidCancel() {
        resetTokenButton()
    }
    
    private func resetTokenButton() {
        loadingView.stopAnimating()
        getTokenButton.isHidden = false
    }
    
    private func createSimpleHelpOverlay() -> UIView {
        let helpView = UIView()
        helpView.translatesAutoresizingMaskIntoConstraints = false
        helpView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        helpView.alpha = 0
        
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.textColor = UIColor.Datacap.nearBlack
        contentLabel.text = """
        🚀 Datacap Token Library Demo
        
        📦 SDK Integration
        Swift Package Manager:
        .package(url: "github.com/datacapsystems/ios-sdk", from: "2.0.0")
        
        💳 Test Cards (Certification Mode)
        Visa: 4111 1111 1111 1111
        Mastercard: 5555 5555 5555 4444
        Amex: 3782 822463 10005
        Discover: 6011 1111 1111 1117
        
        🔐 Security Features
        • PCI DSS Level 1 Compliant
        • Zero Card Storage
        • Real-time Validation
        
        📱 Quick Implementation
        let tokenService = DatacapTokenService(
            publicKey: "pk_live_abc123",
            isCertification: false
        )
        tokenService.requestToken(from: self)
        
        🌐 Resources
        docs.datacapsystems.com
        dsidevportal.com
        """
        
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Got it!", for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        dismissButton.backgroundColor = UIColor.Datacap.primaryRed
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.layer.cornerRadius = 12
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissSimpleHelp), for: .touchUpInside)
        
        scrollView.addSubview(contentLabel)
        card.addSubview(scrollView)
        card.addSubview(dismissButton)
        helpView.addSubview(card)
        
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: helpView.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: helpView.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: helpView.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: helpView.trailingAnchor, constant: -20),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 600),
            card.heightAnchor.constraint(equalToConstant: 500),
            
            scrollView.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -20),
            
            contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            dismissButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            dismissButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            dismissButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSimpleHelp))
        helpView.addGestureRecognizer(tapGesture)
        helpView.tag = 2001
        
        // Animate in
        UIView.animate(withDuration: 0.3) {
            helpView.alpha = 1
        }
        
        return helpView
    }
    
    @objc private func dismissSimpleHelp() {
        if let helpView = view.viewWithTag(2001) {
            UIView.animate(withDuration: 0.3, animations: {
                helpView.alpha = 0
            }) { _ in
                helpView.removeFromSuperview()
            }
        }
    }
}

// MARK: - SettingsViewControllerDelegate

extension ModernViewController: SettingsViewControllerDelegate {
    func settingsDidUpdate() {
        updateModeIndicator()
    }
}
