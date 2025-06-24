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
    // Endpoint is determined by certification mode
    private var isCertification: Bool = true
    
    // MARK: - UI Components
    
    private let backgroundGradient = CAGradientLayer()
    private let floatingMenu = FloatingMenuPill()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        // Set image as template to allow tinting
        imageView.image = UIImage(named: "logo.png")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Make logo adapt to dark mode
        imageView.tintColor = UIColor.Datacap.nearBlack
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Datacap Token Generator"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.Datacap.nearBlack
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Generate secure payment tokens instantly"
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
    
    private let valuePropView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Datacap.formBackground.withAlphaComponent(0.95)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0  // Will be updated based on dark mode
        view.layer.borderColor = UIColor.Datacap.darkGray.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    private let valuePropLabel: UILabel = {
        let label = UILabel()
        label.text = "✓ Instant tokenization\n✓ PCI compliance ready\n✓ Dual environment support\n✓ Enterprise security"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.Datacap.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    // iPad-specific feature cards
    private let featureCardsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureForDevice()
        setupUI()
        setupConstraints()
        floatingMenu.updateModeAppearance()
    }
    
    private func configureForDevice() {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        print("🔍 Device detection: isIPad = \(isIPad), idiom = \(UIDevice.current.userInterfaceIdiom.rawValue)")
        
        // Configure title
        titleLabel.font = isIPad ? .systemFont(ofSize: 48, weight: .bold) : .systemFont(ofSize: 28, weight: .bold)
        
        // Configure subtitle
        subtitleLabel.font = isIPad ? .systemFont(ofSize: 26, weight: .regular) : .systemFont(ofSize: 18, weight: .regular)
        
        // Configure value prop
        let valuePropFontSize: CGFloat = isIPad ? 22 : 15
        valuePropLabel.font = .systemFont(ofSize: valuePropFontSize, weight: .regular)
        valuePropLabel.textAlignment = isIPad ? .center : .left
        
        // Configure button
        let buttonFontSize: CGFloat = isIPad ? 22 : 17
        getTokenButton.titleLabel?.font = .systemFont(ofSize: buttonFontSize, weight: .semibold)
        getTokenButton.layer.cornerRadius = isIPad ? 20 : 16
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor.Datacap.lightBackground
        
        // Background gradient - adapts to dark mode
        updateBackgroundGradient()
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        // Glass morphism container
        containerView.backgroundColor = UIColor.Datacap.formBackground.withAlphaComponent(0.8)
        containerView.applyLiquidGlass(intensity: 0.9, cornerRadius: 32, shadowOpacity: 0.1)
        
        // Setup button with adaptive styling
        updateButtonAppearance()
        getTokenButton.addTarget(self, action: #selector(getTokenTapped), for: .touchUpInside)
        
        // Setup floating menu
        floatingMenu.delegate = self
        floatingMenu.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup scroll view for better iPad support
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        
        // Setup content stack
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = 0
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        view.addSubview(floatingMenu)
        contentStackView.addArrangedSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(valuePropView)
        valuePropView.addSubview(valuePropLabel)
        containerView.addSubview(getTokenButton)
        containerView.addSubview(loadingView)
        
        // Apply glass morphism to value prop view
        valuePropView.applyLiquidGlass(intensity: 0.85, cornerRadius: 16, shadowOpacity: 0.05)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: floatingMenu.topAnchor, constant: -20),
            
            // Content stack view - remove vertical centering for better iPad layout
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),
            
            // Floating menu pill
            floatingMenu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingMenu.heightAnchor.constraint(equalToConstant: 56),
            floatingMenu.widthAnchor.constraint(greaterThanOrEqualToConstant: 160),
            
            // Container - responsive width based on device
            containerView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 40),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180),
            logoImageView.heightAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 80 : 60),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 48 : 32),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            // Value Proposition
            valuePropView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 48 : 32),
            valuePropView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            valuePropView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            valuePropLabel.topAnchor.constraint(equalTo: valuePropView.topAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 32 : 20),
            valuePropLabel.leadingAnchor.constraint(equalTo: valuePropView.leadingAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 32 : 20),
            valuePropLabel.trailingAnchor.constraint(equalTo: valuePropView.trailingAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? -32 : -20),
            valuePropLabel.bottomAnchor.constraint(equalTo: valuePropView.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? -32 : -20),
            
            // Get Token Button
            getTokenButton.topAnchor.constraint(equalTo: valuePropView.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 48 : 32),
            getTokenButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            getTokenButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 200),
            getTokenButton.heightAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 70 : 56),
            
            // Loading view
            loadingView.centerXAnchor.constraint(equalTo: getTokenButton.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: getTokenButton.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 60),
            loadingView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Add device-specific container constraints
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("📱 Setting up iPad-specific layout")
            // iPad: Center content with optimal width and add feature cards
            let optimalWidth: CGFloat = 800
            NSLayoutConstraint.activate([
                containerView.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor),
                containerView.widthAnchor.constraint(equalToConstant: optimalWidth),
                containerView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: 40)
            ])
            
            // Setup feature cards for iPad
            setupFeatureCards()
            containerView.addSubview(featureCardsStackView)
            NSLayoutConstraint.activate([
                featureCardsStackView.topAnchor.constraint(equalTo: getTokenButton.bottomAnchor, constant: 40),
                featureCardsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
                featureCardsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
                featureCardsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
                featureCardsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
            ])
        } else {
            // iPhone: Keep existing narrow layout
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentStackView.leadingAnchor, constant: 20),
                containerView.trailingAnchor.constraint(lessThanOrEqualTo: contentStackView.trailingAnchor, constant: -20),
                containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 600),
                containerView.topAnchor.constraint(equalTo: contentStackView.topAnchor),
                containerView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),
                
                // iPhone specific button bottom constraint
                getTokenButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -48)
            ])
        }
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
        let savedIsCertification = UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
        
        // Load the appropriate key based on mode
        let savedPublicKey: String
        if savedIsCertification {
            savedPublicKey = UserDefaults.standard.string(forKey: "DatacapCertificationPublicKey") ?? ""
        } else {
            savedPublicKey = UserDefaults.standard.string(forKey: "DatacapProductionPublicKey") ?? ""
        }
        
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
        
        // Create token service - endpoint is determined internally based on mode
        tokenService = DatacapTokenService(
            publicKey: savedPublicKey,
            isCertification: savedIsCertification,
            apiEndpoint: "" // Not used anymore, endpoint is fixed based on mode
        )
        tokenService.delegate = self
        
        // Request token
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tokenService.requestToken(from: self)
        }
    }
    
    private func settingsTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        
        // Check if iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Use full screen presentation for iPad with custom navigation
            settingsVC.modalPresentationStyle = .fullScreen
            settingsVC.modalTransitionStyle = .crossDissolve
        } else {
            // Use page sheet for iPhone
            settingsVC.modalPresentationStyle = .pageSheet
            
            if let sheet = settingsVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        }
        
        present(settingsVC, animated: true)
    }
    
    private func helpTapped() {
        // Use the HelpOverlayView for iOS 26 styled help
        let helpView = HelpOverlayView()
        helpView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(helpView)
        
        NSLayoutConstraint.activate([
            helpView.topAnchor.constraint(equalTo: view.topAnchor),
            helpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            helpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            helpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        helpView.show()
    }
    
    // MARK: - Helpers
    
    private func updateModeIndicator() {
        floatingMenu.updateModeAppearance()
    }
    
    private func animateIn() {
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    private func setupFeatureCards() {
        print("🎯 Setting up feature cards for iPad")
        
        // Clear existing cards first
        featureCardsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Create three feature cards for iPad
        let features = [
            ("shield.checkered", "Enterprise Security", "Bank-grade encryption with PCI DSS Level 1 compliance"),
            ("bolt.fill", "Instant Processing", "Real-time tokenization with sub-second response times"),
            ("arrow.triangle.2.circlepath", "Dual Environment", "Seamless switching between certification and production")
        ]
        
        for feature in features {
            let card = createFeatureCard(icon: feature.0, title: feature.1, description: feature.2)
            featureCardsStackView.addArrangedSubview(card)
        }
    }
    
    private func createFeatureCard(icon: String, title: String, description: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.Datacap.formBackground.withAlphaComponent(0.9)
        card.layer.cornerRadius = 16
        card.applyLiquidGlass(intensity: 0.8, cornerRadius: 16, shadowOpacity: 0.08)
        
        // Add border in dark mode for better separation
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        card.layer.borderWidth = isDarkMode ? 0.5 : 0
        card.layer.borderColor = UIColor.Datacap.darkGray.withAlphaComponent(0.3).cgColor
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor.Datacap.primaryRed
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descLabel.textColor = UIColor.Datacap.darkGray
        descLabel.numberOfLines = 0  // Allow unlimited lines
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            descLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        return card
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
    
    private func updateBackgroundGradient() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        if isDarkMode {
            backgroundGradient.colors = [
                UIColor.Datacap.lightBackground.cgColor,
                UIColor(red: 25/255, green: 25/255, blue: 27/255, alpha: 1.0).cgColor,
                UIColor.Datacap.lightBackground.cgColor
            ]
        } else {
            backgroundGradient.colors = [
                UIColor.Datacap.lightBackground.cgColor,
                UIColor.white.cgColor,
                UIColor.Datacap.lightBackground.cgColor
            ]
        }
        backgroundGradient.locations = [0, 0.5, 1]
    }
    
    private func updateButtonAppearance() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        if isDarkMode {
            // Brighter red in dark mode for better visibility
            let brightRed = UIColor(red: 180/255, green: 30/255, blue: 40/255, alpha: 1.0)
            getTokenButton.backgroundColor = brightRed
            getTokenButton.layer.shadowColor = brightRed.cgColor
            getTokenButton.layer.borderWidth = 1
            getTokenButton.layer.borderColor = UIColor(red: 220/255, green: 50/255, blue: 60/255, alpha: 0.5).cgColor
        } else {
            let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0)
            getTokenButton.backgroundColor = darkRed
            getTokenButton.layer.shadowColor = darkRed.cgColor
            getTokenButton.layer.borderWidth = 0
        }
        
        getTokenButton.setTitleColor(.white, for: .normal)
        getTokenButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        getTokenButton.layer.cornerRadius = 16
        getTokenButton.layer.shadowOpacity = 0.2
        getTokenButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        getTokenButton.layer.shadowRadius = 8
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            // Update UI elements for dark mode change
            updateBackgroundGradient()
            updateButtonAppearance()
            floatingMenu.updateModeAppearance()
            
            // Update logo tint color
            logoImageView.tintColor = UIColor.Datacap.nearBlack
            
            // Update value prop view border
            valuePropView.layer.borderWidth = traitCollection.userInterfaceStyle == .dark ? 0.5 : 0
            valuePropView.layer.borderColor = UIColor.Datacap.darkGray.withAlphaComponent(0.3).cgColor
            
            // Force status bar update
            setNeedsStatusBarAppearanceUpdate()
            
            // Update container view if needed
            containerView.backgroundColor = UIColor.Datacap.formBackground.withAlphaComponent(0.8)
            
            // Re-setup feature cards on iPad
            if UIDevice.current.userInterfaceIdiom == .pad {
                setupFeatureCards()
            }
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
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0)
        doneButton.backgroundColor = darkRed
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 16
        doneButton.layer.shadowColor = darkRed.cgColor
        doneButton.layer.shadowOpacity = 0.2
        doneButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        doneButton.layer.shadowRadius = 8
        doneButton.translatesAutoresizingMaskIntoConstraints = false
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
            tokenLabel.bottomAnchor.constraint(equalTo: tokenContainer.bottomAnchor, constant: -12),
            
            // Done button constraints
            doneButton.heightAnchor.constraint(equalToConstant: 56),
            doneButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
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
        What is this?
        Official Datacap tool for instant payment tokenization.
        
        Key Features
        • Generate tokens in seconds
        • Switch environments instantly
        • Reduce PCI scope by 90%
        • Enterprise-grade security
        
        Simple Process
        1. Add API key in Settings
        2. Choose environment
        3. Tap Generate Token
        4. Enter card details
        5. Copy & use token
        
        Get Started
        Get your API keys at:
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

// MARK: - FloatingMenuPillDelegate

extension ModernViewController: FloatingMenuPillDelegate {
    func floatingMenuDidTapSettings() {
        settingsTapped()
    }
    
    func floatingMenuDidTapHelp() {
        helpTapped()
    }
}
