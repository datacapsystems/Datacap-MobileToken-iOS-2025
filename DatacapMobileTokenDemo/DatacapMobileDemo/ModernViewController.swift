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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    // MARK: - Setup
    
    private func setupTokenService() {
        // Load saved settings
        let savedPublicKey = UserDefaults.standard.string(forKey: "DatacapPublicKey") ?? ""
        let savedEndpoint = UserDefaults.standard.string(forKey: "DatacapAPIEndpoint") ?? currentEndpoint
        let savedCertMode = UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
        
        // Always require API configuration
        if savedPublicKey.isEmpty {
            // No API key configured yet
            currentPublicKey = ""
            modeIndicator.isHidden = true
        } else {
            currentPublicKey = savedPublicKey
            currentEndpoint = savedEndpoint
            isCertification = savedCertMode
            
            tokenService = DatacapTokenService(
                publicKey: currentPublicKey,
                isCertification: isCertification,
                apiEndpoint: currentEndpoint
            )
            tokenService.delegate = self
            
            updateModeIndicator()
        }
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
        view.addSubview(helpButton)
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
        
        // Style button
        styleGetTokenButton()
    }
    
    private func styleGetTokenButton() {
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0)
        
        getTokenButton.backgroundColor = darkRed
        getTokenButton.setTitleColor(.white, for: .normal)
        getTokenButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        getTokenButton.layer.cornerRadius = 16
        getTokenButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        
        getTokenButton.layer.shadowColor = darkRed.cgColor
        getTokenButton.layer.shadowOpacity = 0.3
        getTokenButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        getTokenButton.layer.shadowRadius = 8
        
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
            ("shield.fill", "Bank-Level Security", "256-bit encryption protects your data"),
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
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        return card
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Settings button
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Mode indicator
            modeIndicator.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor),
            modeIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modeIndicator.heightAnchor.constraint(equalToConstant: 28),
            
            modeLabel.leadingAnchor.constraint(equalTo: modeIndicator.leadingAnchor, constant: 12),
            modeLabel.trailingAnchor.constraint(equalTo: modeIndicator.trailingAnchor, constant: -12),
            modeLabel.centerYAnchor.constraint(equalTo: modeIndicator.centerYAnchor),
            
            // Help button
            helpButton.centerYAnchor.constraint(equalTo: modeIndicator.centerYAnchor),
            helpButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -8),
            helpButton.widthAnchor.constraint(equalToConstant: 44),
            helpButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: modeIndicator.bottomAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Container
            containerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Get Token Button
            getTokenButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            getTokenButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            getTokenButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Loading view
            loadingView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 60),
            loadingView.heightAnchor.constraint(equalToConstant: 60),
            
            // Features
            featureStackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            featureStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            featureStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            featureStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupActions() {
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(helpTapped), for: .touchUpInside)
        getTokenButton.addTarget(self, action: #selector(getTokenTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func settingsTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        settingsVC.modalPresentationStyle = .overFullScreen
        settingsVC.modalTransitionStyle = .crossDissolve
        
        present(settingsVC, animated: true)
    }
    
    @objc private func helpTapped() {
        let helpView = createHelpOverlay()
        presentCustomAlert(view: helpView)
    }
    
    @objc private func getTokenTapped() {
        // Check if service is configured
        guard tokenService != nil else {
            showConfigurationAlert()
            return
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Show loading
        getTokenButton.isHidden = true
        loadingView.startAnimating()
        
        // Request token
        tokenService.requestToken(from: self)
    }
    
    private func showConfigurationAlert() {
        let alert = UIAlertController(
            title: "Configuration Required",
            message: "Please configure your API settings first.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Configure", style: .default) { [weak self] _ in
            self?.settingsTapped()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
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
        
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.subtitleLabel.alpha = 1
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.featureStackView.alpha = 1
            self.featureStackView.transform = .identity
        }
    }
    
    // MARK: - Helpers
    
    private func updateModeIndicator() {
        modeIndicator.isHidden = false
        
        if isCertification {
            modeLabel.text = "CERTIFICATION MODE"
        } else {
            modeLabel.text = "PRODUCTION MODE"
        }
    }
    
    private func presentCustomAlert(view: UIView) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.alpha = 0
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        UIView.animate(withDuration: 0.3) {
            containerView.alpha = 1
        }
    }
    
    private func presentSuccessAlert(token: DatacapToken) {
        // Create success view
        let successView = UIView()
        successView.translatesAutoresizingMaskIntoConstraints = false
        
        // Background overlay
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.alpha = 0
        
        // Card container
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        card.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        card.alpha = 0
        
        // Success icon
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "checkmark.circle.fill")
        iconView.tintColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Token Generated!"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Token display
        let tokenLabel = UILabel()
        tokenLabel.text = token.token
        tokenLabel.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        tokenLabel.textColor = UIColor.Datacap.darkGray
        tokenLabel.textAlignment = .center
        tokenLabel.numberOfLines = 0
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Card info
        let cardInfoLabel = UILabel()
        cardInfoLabel.text = "\(token.cardType) ending in \(token.maskedCardNumber.suffix(4))"
        cardInfoLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cardInfoLabel.textColor = UIColor.Datacap.blueGray
        cardInfoLabel.textAlignment = .center
        cardInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Done button
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.applyDatacapGlassStyle(
            backgroundColor: UIColor.Datacap.primaryRed,
            titleColor: .white
        )
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        view.addSubview(successView)
        successView.addSubview(overlay)
        successView.addSubview(card)
        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(tokenLabel)
        card.addSubview(cardInfoLabel)
        card.addSubview(doneButton)
        
        // Layout
        NSLayoutConstraint.activate([
            successView.topAnchor.constraint(equalTo: view.topAnchor),
            successView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            successView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlay.topAnchor.constraint(equalTo: successView.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: successView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: successView.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: successView.bottomAnchor),
            
            card.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: successView.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: successView.leadingAnchor, constant: 40),
            card.trailingAnchor.constraint(equalTo: successView.trailingAnchor, constant: -40),
            
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 32),
            iconView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 80),
            iconView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            
            tokenLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tokenLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            tokenLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            
            cardInfoLabel.topAnchor.constraint(equalTo: tokenLabel.bottomAnchor, constant: 16),
            cardInfoLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            cardInfoLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            
            doneButton.topAnchor.constraint(equalTo: cardInfoLabel.bottomAnchor, constant: 32),
            doneButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            doneButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            doneButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -32),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Dismiss action
        doneButton.addTarget(self, action: #selector(dismissSuccessAlert(_:)), for: .touchUpInside)
        doneButton.tag = 999 // Tag to identify the view to remove
        
        // Add tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSuccessAlert(_:)))
        overlay.addGestureRecognizer(tapGesture)
        overlay.tag = 999
        
        // Animate in
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            card.transform = .identity
            card.alpha = 1
        }
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
    
    @objc private func dismissSuccessAlert(_ sender: Any) {
        guard let view = (sender as? UIView)?.superview?.superview ?? (sender as? UIGestureRecognizer)?.view?.superview else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            view.removeFromSuperview()
            self.resetTokenButton()
        }
    }
    
    private func resetTokenButton() {
        loadingView.stopAnimating()
        getTokenButton.isHidden = false
    }
    
    private func createHelpOverlay() -> UIView {
        let helpView = UIView()
        helpView.translatesAutoresizingMaskIntoConstraints = false
        
        // Background overlay
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.alpha = 0
        
        // Main card with improved contrast
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor.Datacap.nearBlack
        card.backgroundColor = color.withAlphaComponent(0.15)
        card.layer.cornerRadius = 24
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Datacap Token Demo"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Content
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.textAlignment = .left
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let modeText = """
        🔧 Production & Certification Modes
        Configure your API settings to test real tokenization in certification or production environments.
        
        🔐 Secure Token Generation
        Enter card details to generate secure payment tokens for testing your integration.
        
        💳 Test Card Numbers
        • Visa: 4111 1111 1111 1111
        • Mastercard: 5555 5555 5555 4444
        • Amex: 3782 822463 10005
        • Discover: 6011 1111 1111 1117
        
        📱 Integration Testing
        Perfect for developers building payment solutions with Datacap's tokenization API.
        """
        
        let attributedText = NSAttributedString(string: modeText, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ])
        
        contentLabel.attributedText = attributedText
        
        // Dismiss button
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Got it!", for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        dismissButton.backgroundColor = UIColor.Datacap.primaryRed.darker(by: 0.2)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.layer.cornerRadius = 12
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        helpView.addSubview(overlay)
        helpView.addSubview(card)
        card.addSubview(titleLabel)
        card.addSubview(contentLabel)
        card.addSubview(dismissButton)
        
        // Layout
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: helpView.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: helpView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: helpView.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: helpView.bottomAnchor),
            
            card.centerXAnchor.constraint(equalTo: helpView.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: helpView.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: helpView.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(equalTo: helpView.trailingAnchor, constant: -24),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 500),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            contentLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            contentLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            
            dismissButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 32),
            dismissButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            dismissButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            dismissButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -32),
            dismissButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Dismiss action
        dismissButton.addTarget(self, action: #selector(dismissHelp), for: .touchUpInside)
        
        // Add tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissHelp))
        overlay.addGestureRecognizer(tapGesture)
        
        // Store reference for dismissal
        overlay.tag = 1001
        card.tag = 1002
        
        // Animate in
        card.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        card.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            card.transform = .identity
            card.alpha = 1
        }
        
        return helpView
    }
    
    @objc private func dismissHelp() {
        guard let overlay = view.subviews.first(where: { $0.tag == 1001 }),
              let card = view.subviews.first(where: { $0.tag == 1002 })?.subviews.first(where: { $0.tag == 1002 }) else {
            // Find the help view container
            if let helpContainer = view.subviews.last {
                UIView.animate(withDuration: 0.3, animations: {
                    helpContainer.alpha = 0
                }) { _ in
                    helpContainer.removeFromSuperview()
                }
            }
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            overlay.alpha = 0
            card.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            card.alpha = 0
        }) { _ in
            overlay.superview?.removeFromSuperview()
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
            
            // Show error alert
            let alert = UIAlertController(
                title: "Token Generation Failed",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func tokenRequestDidCancel() {
        DispatchQueue.main.async { [weak self] in
            self?.resetTokenButton()
        }
    }
}

// MARK: - SettingsViewControllerDelegate

extension ModernViewController: SettingsViewControllerDelegate {
    func settingsDidUpdate() {
        setupTokenService()
    }
}