//
//  ModernViewController.swift
//  DatacapMobileTokenDemo
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

import UIKit

class ModernViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let backgroundGradient = CAGradientLayer()
    
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
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.Datacap.nearBlack
        label.textAlignment = .center
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
        return view
    }()
    
    private let getTokenButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Secure Token", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Properties
    
    private let tokenizer = DatacapTokenizer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Setup
    
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
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(containerView)
        view.addSubview(featureStackView)
        containerView.addSubview(getTokenButton)
        containerView.addSubview(loadingView)
        
        // Apply glass morphism to container
        containerView.applyLiquidGlass(intensity: 0.85, cornerRadius: 24, shadowOpacity: 0.1)
        
        // Style button
        getTokenButton.applyDatacapGlassStyle(isPrimary: true)
        
        // Add feature cards
        setupFeatureCards()
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
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = UIColor.Datacap.darkGray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            
            card.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add shimmer effect
        card.addGlassShimmer()
        
        return card
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 56),
            
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
    }
    
    // MARK: - Actions
    
    @objc private func getTokenTapped() {
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Show loading
        getTokenButton.isHidden = true
        loadingView.startAnimating()
        
        // Request token
        tokenizer.requestKeyedToken(
            withPublicKey: "cd67abe67d544936b0f3708b9fda7238",
            isCertification: true,
            andDelegate: self,
            overViewController: self
        )
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
}

// MARK: - DatacapTokenDelegate

extension ModernViewController: DatacapTokenDelegate {
    
    func tokenLoading() {
        // Already showing loading indicator
    }
    
    func tokenCreated(_ token: DatacapToken!) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopAnimating()
            self?.presentSuccessAlert(token: token)
        }
    }
    
    func tokenizationError(_ error: Error!) {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopAnimating()
            self?.getTokenButton.isHidden = false
            self?.presentErrorAlert(error: error)
        }
    }
    
    func tokenizationCancelled() {
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
    
    private func presentErrorAlert(error: Error) {
        let nsError = error as NSError
        let errorView = createErrorView(
            title: nsError.localizedFailureReason ?? "Tokenization Error",
            message: nsError.localizedRecoverySuggestion ?? "Please try again"
        )
        presentCustomAlert(view: errorView)
    }
    
    private func createSuccessView(token: DatacapToken) -> UIView {
        let view = UIView()
        view.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmark.tintColor = UIColor.Datacap.primaryRed
        checkmark.contentMode = .scaleAspectFit
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Token Created Successfully!"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let detailsLabel = UILabel()
        detailsLabel.text = """
        Token: \(String(token.token.prefix(20)))...
        Card: \(token.brand ?? "Unknown") •••• \(token.last4 ?? "")
        Expires: \(token.expirationMonth ?? "")/\(token.expirationYear ?? "")
        """
        detailsLabel.font = .systemFont(ofSize: 14, weight: .regular)
        detailsLabel.textColor = UIColor.Datacap.darkGray
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(checkmark)
        view.addSubview(titleLabel)
        view.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            checkmark.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            checkmark.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 60),
            checkmark.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: checkmark.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            detailsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
        
        return view
    }
    
    private func createErrorView(title: String, message: String) -> UIView {
        let view = UIView()
        view.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        
        let errorIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        errorIcon.tintColor = UIColor.systemRed
        errorIcon.contentMode = .scaleAspectFit
        errorIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 16, weight: .regular)
        messageLabel.textColor = UIColor.Datacap.darkGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorIcon)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            errorIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            errorIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorIcon.widthAnchor.constraint(equalToConstant: 60),
            errorIcon.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: errorIcon.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
        
        return view
    }
    
    private func presentCustomAlert(view: UIView) {
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimView.frame = self.view.bounds
        dimView.alpha = 0
        
        let containerView = UIView()
        containerView.addSubview(view)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(dimView)
        self.view.addSubview(containerView)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 40),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -40),
            
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Add tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCustomAlert))
        dimView.addGestureRecognizer(tapGesture)
        
        // Animate in
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            dimView.alpha = 1
            containerView.alpha = 1
            containerView.transform = .identity
        }
        
        // Auto dismiss after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.dismissCustomAlert()
        }
        
        // Store references for dismissal
        dimView.tag = 999
        containerView.tag = 998
    }
    
    @objc private func dismissCustomAlert() {
        guard let dimView = view.viewWithTag(999),
              let containerView = view.viewWithTag(998) else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            dimView.alpha = 0
            containerView.alpha = 0
            containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            dimView.removeFromSuperview()
            containerView.removeFromSuperview()
            self.getTokenButton.isHidden = false
        }
    }
}