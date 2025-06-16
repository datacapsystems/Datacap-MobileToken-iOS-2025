//
//  ModernViewController.swift
//  DatacapMobileTokenDemo
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

import UIKit

class ModernViewController: UIViewController {
    
    // MARK: - Properties
    
    private var tokenService: DatacapTokenService!
    private var currentPublicKey: String = "cd67abe67d544936b0f3708b9fda7238"
    private var currentEndpoint: String?
    
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
        view.isHidden = true
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
        label.text = "Secure Payment Tokenization"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = UIColor.Datacap.nearBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Transform payment data into secure tokens"
        label.font = .systemFont(ofSize: 16, weight: .regular)
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
        button.setTitle("Get Secure Token", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let loadingView: LiquidGlassLoadingView = {
        let loading = LiquidGlassLoadingView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.isHidden = true
        return loading
    }()
    
    private let featureStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTokenService()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
        
        // Debug button
        print("Button frame: \(getTokenButton.frame)")
        print("Button superview: \(getTokenButton.superview)")
        print("Button is enabled: \(getTokenButton.isEnabled)")
        print("Button is user interaction enabled: \(getTokenButton.isUserInteractionEnabled)")
        print("Container user interaction: \(containerView.isUserInteractionEnabled)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Setup
    
    private func setupTokenService() {
        // Load saved settings
        let isDemoMode = UserDefaults.standard.object(forKey: "DatacapDemoMode") as? Bool ?? true
        let savedPublicKey = UserDefaults.standard.string(forKey: "DatacapPublicKey") ?? currentPublicKey
        let savedEndpoint = UserDefaults.standard.string(forKey: "DatacapAPIEndpoint")
        
        currentPublicKey = savedPublicKey.isEmpty ? currentPublicKey : savedPublicKey
        currentEndpoint = isDemoMode ? nil : savedEndpoint
        
        tokenService = DatacapTokenService(
            publicKey: currentPublicKey,
            isCertification: true,
            apiEndpoint: currentEndpoint
        )
        tokenService.delegate = self
        
        updateModeIndicator()
    }
    
    private func setupUI() {
        // Background gradient
        backgroundGradient.colors = [
            UIColor.Datacap.lightBackground.cgColor,
            UIColor.white.cgColor,
            UIColor.Datacap.lightBackground.cgColor
        ]
        backgroundGradient.locations = [0.0, 0.5, 1.0]
        backgroundGradient.frame = view.bounds
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        // Add subviews
        view.addSubview(settingsButton)
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(containerView)
        view.addSubview(featureStackView)
        view.addSubview(modeIndicator)
        modeIndicator.addSubview(modeLabel)
        containerView.addSubview(getTokenButton)
        containerView.addSubview(loadingView)
        
        // Apply glass morphism to container
        containerView.applyLiquidGlass(intensity: 0.85, cornerRadius: 24, shadowOpacity: 0.1)
        
        // Add feature cards
        setupFeatureCards()
        
        // Style button with darker red for primary action
        styleGetTokenButton()
    }
    
    private func styleGetTokenButton() {
        // Create a darker red for primary CTA
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0) // Darker than #941a25
        
        getTokenButton.backgroundColor = darkRed
        getTokenButton.setTitleColor(.white, for: .normal)
        getTokenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        getTokenButton.layer.cornerRadius = 16
        getTokenButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        
        // Add stronger shadow for emphasis
        getTokenButton.layer.shadowColor = darkRed.cgColor
        getTokenButton.layer.shadowOpacity = 0.3
        getTokenButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        getTokenButton.layer.shadowRadius = 8
        
        // Add press animations
        getTokenButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        getTokenButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.getTokenButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.getTokenButton.layer.shadowOpacity = 0.2
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.getTokenButton.transform = .identity
            self.getTokenButton.layer.shadowOpacity = 0.3
        }
    }
    
    private func setupFeatureCards() {
        let features = [
            ("shield.fill", "Bank-Level Security", "Your payment data is encrypted and tokenized"),
            ("bolt.fill", "Lightning Fast", "Get tokens in milliseconds"),
            ("checkmark.seal.fill", "PCI Compliant", "Meet all regulatory requirements")
        ]
        
        for (icon, title, subtitle) in features {
            let card = createFeatureCard(icon: icon, title: title, subtitle: subtitle)
            featureStackView.addArrangedSubview(card)
        }
    }
    
    private func createFeatureCard(icon: String, title: String, subtitle: String) -> UIView {
        let card = UIView()
        card.applyLiquidGlass(intensity: 0.7, cornerRadius: 16, shadowOpacity: 0.05)
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor.Datacap.primaryRed
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor.Datacap.darkGray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 80),
            
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Settings button
            settingsButton.centerYAnchor.constraint(equalTo: modeIndicator.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Mode indicator
            modeIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            modeIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            modeIndicator.heightAnchor.constraint(equalToConstant: 28),
            
            modeLabel.leadingAnchor.constraint(equalTo: modeIndicator.leadingAnchor, constant: 12),
            modeLabel.trailingAnchor.constraint(equalTo: modeIndicator.trailingAnchor, constant: -12),
            modeLabel.centerYAnchor.constraint(equalTo: modeIndicator.centerYAnchor),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: modeIndicator.bottomAnchor, constant: 24),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Container
            containerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Button
            getTokenButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            getTokenButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            getTokenButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            // Loading
            loadingView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 60),
            loadingView.heightAnchor.constraint(equalToConstant: 60),
            
            // Feature Stack
            featureStackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            featureStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            featureStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            featureStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupActions() {
        getTokenButton.addTarget(self, action: #selector(getTokenTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        // Add debug tap gesture to container
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func containerTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: containerView)
        print("Container tapped at: \(location)")
        print("Button frame in container: \(getTokenButton.frame)")
        
        if getTokenButton.frame.contains(location) {
            print("Tap was inside button frame!")
            getTokenTapped()
        }
    }
    
    // MARK: - Actions
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .overFullScreen
        settingsVC.modalTransitionStyle = .crossDissolve
        
        settingsVC.onSettingsChanged = { [weak self] (publicKey: String, endpoint: String?) in
            self?.currentPublicKey = publicKey
            self?.currentEndpoint = endpoint
            self?.setupTokenService()
        }
        
        present(settingsVC, animated: true)
    }
    
    @objc private func getTokenTapped() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Show loading
        getTokenButton.isHidden = true
        loadingView.startAnimating()
        
        // Request token using the new service
        tokenService.requestToken(from: self)
    }
    
    // MARK: - Animations
    
    private func animateIn() {
        // Initial state
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(translationX: 0, y: -20)
        
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        
        subtitleLabel.alpha = 0
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        featureStackView.alpha = 0
        featureStackView.transform = CGAffineTransform(translationX: 0, y: 20)
        
        // Animate
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.15, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.subtitleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.featureStackView.alpha = 1
            self.featureStackView.transform = .identity
        }
    }
}

// MARK: - DatacapTokenServiceDelegate

extension ModernViewController: DatacapTokenServiceDelegate {
    
    func tokenRequestDidSucceed(_ token: DatacapToken) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopAnimating()
            self?.presentSuccessAlert(token: token)
        }
    }
    
    func tokenRequestDidFail(error: DatacapTokenError) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopAnimating()
            self?.getTokenButton.isHidden = false
            self?.presentErrorAlert(error: error)
        }
    }
    
    func tokenRequestDidCancel() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopAnimating()
            self?.getTokenButton.isHidden = false
        }
    }
    
    // MARK: - Alert Presentation
    
    private func presentSuccessAlert(token: DatacapToken) {
        let successView = createSuccessView(token: token)
        presentCustomAlert(view: successView)
    }
    
    private func presentErrorAlert(error: DatacapTokenError) {
        let errorView = createErrorView(
            title: "Tokenization Error",
            message: error.localizedDescription
        )
        presentCustomAlert(view: errorView)
    }
    
    private func createSuccessView(token: DatacapToken) -> UIView {
        let container = UIView()
        container.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.15)
        
        let checkmarkView = UIImageView()
        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0) // Forest green - much darker
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Success!"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tokenLabel = UILabel()
        tokenLabel.text = "Token: \(token.token)"
        tokenLabel.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        tokenLabel.textColor = UIColor.Datacap.darkGray
        tokenLabel.numberOfLines = 0
        tokenLabel.textAlignment = .center
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cardLabel = UILabel()
        cardLabel.text = "\(token.cardType) \(token.maskedCardNumber)"
        cardLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cardLabel.textColor = UIColor.Datacap.darkGray
        cardLabel.textAlignment = .center
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let okButton = UIButton(type: .system)
        okButton.setTitle("OK", for: .normal)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.backgroundColor = UIColor.Datacap.primaryRed
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        okButton.layer.cornerRadius = 16
        okButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        container.addSubview(checkmarkView)
        container.addSubview(titleLabel)
        container.addSubview(tokenLabel)
        container.addSubview(cardLabel)
        container.addSubview(okButton)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 300),
            
            checkmarkView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            checkmarkView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 60),
            checkmarkView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: checkmarkView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            cardLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            cardLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            cardLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            tokenLabel.topAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: 12),
            tokenLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            tokenLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            okButton.topAnchor.constraint(equalTo: tokenLabel.bottomAnchor, constant: 24),
            okButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 100),
            okButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24)
        ])
        
        return container
    }
    
    private func createErrorView(title: String, message: String) -> UIView {
        let container = UIView()
        container.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.15)
        
        let errorView = UIImageView()
        errorView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        errorView.tintColor = UIColor.Datacap.primaryRed
        errorView.contentMode = .scaleAspectFit
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = UIColor.Datacap.darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Try Again", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)  // Smaller font to fit
        retryButton.backgroundColor = UIColor.Datacap.primaryRed
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 16
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)  // Smaller padding
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(errorView)
        container.addSubview(titleLabel)
        container.addSubview(messageLabel)
        container.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 280),
            
            errorView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            errorView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            errorView.widthAnchor.constraint(equalToConstant: 48),
            errorView.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.topAnchor.constraint(equalTo: errorView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            retryButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24)
        ])
        
        retryButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
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
            self.getTokenButton.isHidden = false
        }
    }
    
    // MARK: - UI Updates
    
    private func updateModeIndicator() {
        let isDemoMode = currentEndpoint == nil || currentEndpoint?.isEmpty == true
        
        // Always use black background with white text
        modeIndicator.backgroundColor = UIColor.Datacap.nearBlack
        modeLabel.textColor = .white
        
        if isDemoMode {
            modeLabel.text = "DEMO MODE"
        } else {
            modeLabel.text = "LIVE MODE"
        }
        
        modeIndicator.isHidden = false
        
        // Add subtle animation
        modeIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.modeIndicator.transform = .identity
        })
    }
}