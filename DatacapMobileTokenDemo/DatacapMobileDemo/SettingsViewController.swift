//
//  SettingsViewController.swift
//  DatacapMobileTokenDemo
//
//  Clean version for tokenization library - Certification/Production only
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsDidUpdate()
}

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SettingsViewControllerDelegate?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    private let modeSegmentedControl = UISegmentedControl(items: ["Certification", "Production"])
    private let modeDescriptionLabel = UILabel()
    
    private let apiKeyContainerView = UIView()
    private let apiKeyLabel = UILabel()
    private let apiKeyTextField = UITextField()
    private let apiKeyInfoButton = UIButton(type: .infoLight)
    
    private let endpointContainerView = UIView()
    private let endpointLabel = UILabel()
    private let endpointTextField = UITextField()
    private let endpointHelpLabel = UILabel()
    
    private let saveButton = UIButton(type: .system)
    
    private let infoCardView = UIView()
    private let infoIconView = UIImageView()
    private let infoTitleLabel = UILabel()
    private let infoTextLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureForDevice()
        setupConstraints()
        loadCurrentSettings()
        updateUIForMode()
        
        // Add navigation bar for iPad full screen
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle == .fullScreen {
            setupIPadNavigationBar()
        }
    }
    
    private func configureForDevice() {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
        // Mode segmented control font
        let segmentedFont = isIPad ? UIFont.systemFont(ofSize: 20, weight: .medium) : UIFont.systemFont(ofSize: 17, weight: .regular)
        modeSegmentedControl.setTitleTextAttributes([.font: segmentedFont], for: .normal)
        modeSegmentedControl.setTitleTextAttributes([.font: segmentedFont], for: .selected)
        
        // Labels
        modeDescriptionLabel.font = isIPad ? .systemFont(ofSize: 18, weight: .regular) : .systemFont(ofSize: 14, weight: .regular)
        apiKeyLabel.font = isIPad ? .systemFont(ofSize: 20, weight: .semibold) : .systemFont(ofSize: 16, weight: .semibold)
        apiKeyTextField.font = isIPad ? .monospacedSystemFont(ofSize: 18, weight: .regular) : .monospacedSystemFont(ofSize: 14, weight: .regular)
        endpointLabel.font = isIPad ? .systemFont(ofSize: 20, weight: .semibold) : .systemFont(ofSize: 16, weight: .semibold)
        endpointTextField.font = isIPad ? .monospacedSystemFont(ofSize: 18, weight: .regular) : .monospacedSystemFont(ofSize: 14, weight: .regular)
        endpointHelpLabel.font = isIPad ? .systemFont(ofSize: 16, weight: .regular) : .systemFont(ofSize: 12, weight: .regular)
        
        // Save button
        saveButton.titleLabel?.font = isIPad ? .systemFont(ofSize: 20, weight: .semibold) : .systemFont(ofSize: 17, weight: .semibold)
        
        // Info card
        infoTitleLabel.font = isIPad ? .systemFont(ofSize: 20, weight: .semibold) : .systemFont(ofSize: 16, weight: .semibold)
        infoTextLabel.font = isIPad ? .systemFont(ofSize: 18, weight: .regular) : .systemFont(ofSize: 14, weight: .regular)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update background colors when switching between light/dark mode
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            updateBackgroundColors()
        }
    }
    
    private func updateBackgroundColors() {
        // Update container backgrounds
        apiKeyContainerView.backgroundColor = UIColor.Datacap.formBackground
        endpointContainerView.backgroundColor = UIColor.Datacap.formBackground
        
        // Update text fields
        apiKeyTextField.textColor = UIColor.Datacap.formText
        endpointTextField.textColor = UIColor.Datacap.formText
    }
    
    // MARK: - Setup
    
    private func setupIPadNavigationBar() {
        // Create a custom navigation bar for iPad
        let navBar = UIView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backgroundColor = UIColor.Datacap.lightBackground.withAlphaComponent(0.95)
        navBar.applyLiquidGlass(intensity: 0.9, cornerRadius: 0, shadowOpacity: 0.1)
        
        let titleLabel = UILabel()
        titleLabel.text = "API Configuration"
        titleLabel.font = .systemFont(ofSize: 48, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Done", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        closeButton.setTitleColor(UIColor.Datacap.primaryRed, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        navBar.addSubview(titleLabel)
        navBar.addSubview(closeButton)
        view.addSubview(navBar)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 32),
            titleLabel.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -16),
            
            closeButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -32),
            closeButton.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -16),
        ])
        
        // Adjust content view top constraint
        contentView.backgroundColor = UIColor.Datacap.lightBackground
        contentView.layer.cornerRadius = 0
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupUI() {
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle == .fullScreen {
            view.backgroundColor = UIColor.Datacap.lightBackground
        } else {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        
        // Content container
        contentView.backgroundColor = UIColor.Datacap.lightBackground
        contentView.layer.cornerRadius = 24
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        
        // Header
        headerView.backgroundColor = .clear
        
        // Only show title on iPad when not in full screen mode
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle != .fullScreen {
            titleLabel.text = "API Configuration"
            titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
            titleLabel.textColor = UIColor.Datacap.nearBlack
        }
        
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor.Datacap.darkGray
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        // Mode selector
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        modeSegmentedControl.backgroundColor = UIColor.Datacap.lightBackground
        modeSegmentedControl.selectedSegmentTintColor = UIColor.Datacap.primaryRed.withAlphaComponent(0.8)
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Datacap.darkGray]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        modeSegmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        modeSegmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        modeDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        modeDescriptionLabel.textColor = UIColor.Datacap.darkGray
        modeDescriptionLabel.numberOfLines = 0
        modeDescriptionLabel.text = "Select environment for secure payment tokenization"
        
        // API Key section
        apiKeyContainerView.backgroundColor = UIColor.Datacap.formBackground
        apiKeyContainerView.applyLiquidGlass(intensity: 0.8, cornerRadius: 16, shadowOpacity: 0.05)
        
        apiKeyLabel.text = "API Public Key"
        apiKeyLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        apiKeyLabel.textColor = UIColor.Datacap.nearBlack
        
        apiKeyTextField.placeholder = "Enter your public key"
        apiKeyTextField.borderStyle = .none
        apiKeyTextField.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        apiKeyTextField.textColor = UIColor.Datacap.formText
        apiKeyTextField.backgroundColor = .clear
        apiKeyTextField.autocapitalizationType = .none
        apiKeyTextField.autocorrectionType = .no
        apiKeyTextField.clearButtonMode = .whileEditing
        
        apiKeyInfoButton.addTarget(self, action: #selector(apiKeyInfoTapped), for: .touchUpInside)
        
        // Endpoint section
        endpointContainerView.backgroundColor = UIColor.Datacap.formBackground
        endpointContainerView.applyLiquidGlass(intensity: 0.8, cornerRadius: 16, shadowOpacity: 0.05)
        
        endpointLabel.text = "API Endpoint"
        endpointLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        endpointLabel.textColor = UIColor.Datacap.nearBlack
        
        // Tokenization endpoints are fixed based on mode
        let isCertMode = UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
        endpointTextField.text = isCertMode ? "https://token-cert.dcap.com/v1/tokenize" : "https://token.dcap.com/v1/tokenize"
        endpointTextField.isEnabled = false // Endpoints are fixed for tokenization
        endpointHelpLabel.text = "Tokenization endpoint (automatically set based on mode)"
        endpointTextField.placeholder = "API Endpoint URL"
        endpointTextField.borderStyle = .none
        endpointTextField.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        endpointTextField.textColor = UIColor.Datacap.formText
        endpointTextField.backgroundColor = .clear
        endpointTextField.autocapitalizationType = .none
        endpointTextField.autocorrectionType = .no
        endpointTextField.keyboardType = .URL
        endpointTextField.clearButtonMode = .never
        
        // Endpoint help label
        endpointHelpLabel.text = "Official Datacap API endpoint (rarely needs changing)"
        endpointHelpLabel.font = .systemFont(ofSize: 12, weight: .regular)
        endpointHelpLabel.textColor = UIColor.Datacap.blueGray
        endpointHelpLabel.numberOfLines = 0
        
        // Save button
        saveButton.setTitle("Save Configuration", for: .normal)
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0)
        saveButton.backgroundColor = darkRed
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        saveButton.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        saveButton.layer.shadowColor = darkRed.cgColor
        saveButton.layer.shadowOpacity = 0.2
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        saveButton.layer.shadowRadius = 8
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // Info card
        infoCardView.applyLiquidGlass(intensity: 0.85, cornerRadius: 16, shadowOpacity: 0.08)
        infoCardView.backgroundColor = UIColor.Datacap.primaryRed.withAlphaComponent(0.05)
        
        infoIconView.image = UIImage(systemName: "info.circle.fill")
        infoIconView.tintColor = UIColor.Datacap.primaryRed
        infoIconView.contentMode = .scaleAspectFit
        
        infoTitleLabel.text = "Get Your API Credentials"
        infoTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        infoTitleLabel.textColor = UIColor.Datacap.nearBlack
        
        infoTextLabel.text = "Register at dsidevportal.com to get your public key for generating real tokens in both certification and production environments."
        infoTextLabel.font = .systemFont(ofSize: 14, weight: .regular)
        infoTextLabel.textColor = UIColor.Datacap.darkGray
        infoTextLabel.numberOfLines = 0
        
        // Add tap gesture to info card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(infoCardTapped))
        infoCardView.addGestureRecognizer(tapGesture)
        infoCardView.isUserInteractionEnabled = true
        
        // View hierarchy
        view.addSubview(contentView)
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(headerView)
        
        // Only add titleLabel on iPad when not in full screen mode
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle != .fullScreen {
            headerView.addSubview(titleLabel)
        }
        
        headerView.addSubview(closeButton)
        
        scrollView.addSubview(modeSegmentedControl)
        scrollView.addSubview(modeDescriptionLabel)
        
        scrollView.addSubview(apiKeyContainerView)
        apiKeyContainerView.addSubview(apiKeyLabel)
        apiKeyContainerView.addSubview(apiKeyTextField)
        apiKeyContainerView.addSubview(apiKeyInfoButton)
        
        scrollView.addSubview(endpointContainerView)
        endpointContainerView.addSubview(endpointLabel)
        endpointContainerView.addSubview(endpointTextField)
        endpointContainerView.addSubview(endpointHelpLabel)
        
        scrollView.addSubview(saveButton)
        
        scrollView.addSubview(infoCardView)
        infoCardView.addSubview(infoIconView)
        infoCardView.addSubview(infoTitleLabel)
        infoCardView.addSubview(infoTextLabel)
        
        // Setup keyboard handling
        setupKeyboardHandling()
        
        // Translates autoresizing mask into constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        modeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        modeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        apiKeyContainerView.translatesAutoresizingMaskIntoConstraints = false
        apiKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        apiKeyTextField.translatesAutoresizingMaskIntoConstraints = false
        apiKeyInfoButton.translatesAutoresizingMaskIntoConstraints = false
        endpointContainerView.translatesAutoresizingMaskIntoConstraints = false
        endpointLabel.translatesAutoresizingMaskIntoConstraints = false
        endpointTextField.translatesAutoresizingMaskIntoConstraints = false
        endpointHelpLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        infoCardView.translatesAutoresizingMaskIntoConstraints = false
        infoIconView.translatesAutoresizingMaskIntoConstraints = false
        infoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        // Skip content view constraints for iPad full screen (handled in setupIPadNavigationBar)
        if !(UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle == .fullScreen) {
            NSLayoutConstraint.activate([
                // Content view - full width for both iPhone and non-fullscreen iPad
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85),
            ])
        }
        
        NSLayoutConstraint.activate([
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            headerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Mode control
            modeSegmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            modeSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        // Add titleLabel constraints only when it's shown
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle != .fullScreen {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            ])
        }
        
        // Adjust constraints based on device
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle == .fullScreen {
            NSLayoutConstraint.activate([
                modeSegmentedControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                modeSegmentedControl.widthAnchor.constraint(equalToConstant: 600),
            ])
        } else {
            NSLayoutConstraint.activate([
                modeSegmentedControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
                modeSegmentedControl.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
                modeSegmentedControl.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48),
            ])
        }
        
        NSLayoutConstraint.activate([
            
            modeDescriptionLabel.topAnchor.constraint(equalTo: modeSegmentedControl.bottomAnchor, constant: 8),
            modeDescriptionLabel.leadingAnchor.constraint(equalTo: modeSegmentedControl.leadingAnchor),
            modeDescriptionLabel.trailingAnchor.constraint(equalTo: modeSegmentedControl.trailingAnchor),
            
            // API Key container
            apiKeyContainerView.topAnchor.constraint(equalTo: modeDescriptionLabel.bottomAnchor, constant: 24),
            apiKeyContainerView.heightAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 100 : 80),
        ])
        
        // API Key container width constraints
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle == .fullScreen {
            NSLayoutConstraint.activate([
                apiKeyContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                apiKeyContainerView.widthAnchor.constraint(equalToConstant: 600),
            ])
        } else {
            NSLayoutConstraint.activate([
                apiKeyContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
                apiKeyContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
                apiKeyContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48),
            ])
        }
        
        NSLayoutConstraint.activate([
            
            apiKeyLabel.topAnchor.constraint(equalTo: apiKeyContainerView.topAnchor, constant: 16),
            apiKeyLabel.leadingAnchor.constraint(equalTo: apiKeyContainerView.leadingAnchor, constant: 16),
            
            apiKeyInfoButton.centerYAnchor.constraint(equalTo: apiKeyLabel.centerYAnchor),
            apiKeyInfoButton.leadingAnchor.constraint(equalTo: apiKeyLabel.trailingAnchor, constant: 8),
            apiKeyInfoButton.widthAnchor.constraint(equalToConstant: 20),
            apiKeyInfoButton.heightAnchor.constraint(equalToConstant: 20),
            
            apiKeyTextField.topAnchor.constraint(equalTo: apiKeyLabel.bottomAnchor, constant: 8),
            apiKeyTextField.leadingAnchor.constraint(equalTo: apiKeyContainerView.leadingAnchor, constant: 16),
            apiKeyTextField.trailingAnchor.constraint(equalTo: apiKeyContainerView.trailingAnchor, constant: -16),
            apiKeyTextField.bottomAnchor.constraint(equalTo: apiKeyContainerView.bottomAnchor, constant: -16),
            
            // Endpoint container
            endpointContainerView.topAnchor.constraint(equalTo: apiKeyContainerView.bottomAnchor, constant: 16),
            endpointContainerView.heightAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 120 : 100),
        ])
        
        // Endpoint container width constraints
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle == .fullScreen {
            NSLayoutConstraint.activate([
                endpointContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                endpointContainerView.widthAnchor.constraint(equalToConstant: 600),
            ])
        } else {
            NSLayoutConstraint.activate([
                endpointContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
                endpointContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
                endpointContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48),
            ])
        }
        
        NSLayoutConstraint.activate([
            
            endpointLabel.topAnchor.constraint(equalTo: endpointContainerView.topAnchor, constant: 16),
            endpointLabel.leadingAnchor.constraint(equalTo: endpointContainerView.leadingAnchor, constant: 16),
            
            endpointTextField.topAnchor.constraint(equalTo: endpointLabel.bottomAnchor, constant: 8),
            endpointTextField.leadingAnchor.constraint(equalTo: endpointContainerView.leadingAnchor, constant: 16),
            endpointTextField.trailingAnchor.constraint(equalTo: endpointContainerView.trailingAnchor, constant: -16),
            
            endpointHelpLabel.topAnchor.constraint(equalTo: endpointTextField.bottomAnchor, constant: 4),
            endpointHelpLabel.leadingAnchor.constraint(equalTo: endpointTextField.leadingAnchor),
            endpointHelpLabel.trailingAnchor.constraint(equalTo: endpointTextField.trailingAnchor),
            endpointHelpLabel.bottomAnchor.constraint(lessThanOrEqualTo: endpointContainerView.bottomAnchor, constant: -8),
            
            // Save button
            saveButton.topAnchor.constraint(equalTo: endpointContainerView.bottomAnchor, constant: 32),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 70 : 56),
            saveButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 200),
            
            // Info card
            infoCardView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 32),
            infoCardView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -32),
        ])
        
        // Info card width constraints
        if UIDevice.current.userInterfaceIdiom == .pad && modalPresentationStyle == .fullScreen {
            NSLayoutConstraint.activate([
                infoCardView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                infoCardView.widthAnchor.constraint(equalToConstant: 600),
            ])
        } else {
            NSLayoutConstraint.activate([
                infoCardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
                infoCardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
                infoCardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48),
            ])
        }
        
        NSLayoutConstraint.activate([
            
            infoIconView.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 16),
            infoIconView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            infoIconView.widthAnchor.constraint(equalToConstant: 24),
            infoIconView.heightAnchor.constraint(equalToConstant: 24),
            
            infoTitleLabel.topAnchor.constraint(equalTo: infoIconView.topAnchor),
            infoTitleLabel.leadingAnchor.constraint(equalTo: infoIconView.trailingAnchor, constant: 12),
            infoTitleLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            
            infoTextLabel.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 4),
            infoTextLabel.leadingAnchor.constraint(equalTo: infoTitleLabel.leadingAnchor),
            infoTextLabel.trailingAnchor.constraint(equalTo: infoTitleLabel.trailingAnchor),
            infoTextLabel.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Configuration
    
    private func loadCurrentSettings() {
        let isCertification = UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
        
        // Migration: If using old single key system, migrate to separate keys
        if let oldKey = UserDefaults.standard.string(forKey: "DatacapPublicKey"), !oldKey.isEmpty {
            let certKey = UserDefaults.standard.string(forKey: "DatacapCertificationPublicKey") ?? ""
            let prodKey = UserDefaults.standard.string(forKey: "DatacapProductionPublicKey") ?? ""
            
            // If the mode-specific keys are empty, migrate the old key
            if certKey.isEmpty && prodKey.isEmpty {
                if isCertification {
                    UserDefaults.standard.set(oldKey, forKey: "DatacapCertificationPublicKey")
                } else {
                    UserDefaults.standard.set(oldKey, forKey: "DatacapProductionPublicKey")
                }
            }
        }
        
        // Load the appropriate key based on current mode
        let certKey = UserDefaults.standard.string(forKey: "DatacapCertificationPublicKey") ?? ""
        let prodKey = UserDefaults.standard.string(forKey: "DatacapProductionPublicKey") ?? ""
        
        // Set the appropriate key based on mode
        apiKeyTextField.text = isCertification ? certKey : prodKey
        
        // Set endpoint based on mode (now using v1/otu)
        endpointTextField.text = isCertification ? "https://token-cert.dcap.com/v1/otu" : "https://token.dcap.com/v1/otu"
        modeSegmentedControl.selectedSegmentIndex = isCertification ? 0 : 1
    }
    
    private func updateUIForMode() {
        let isCertification = modeSegmentedControl.selectedSegmentIndex == 0
        
        // Load the saved keys
        let certKey = UserDefaults.standard.string(forKey: "DatacapCertificationPublicKey") ?? ""
        let prodKey = UserDefaults.standard.string(forKey: "DatacapProductionPublicKey") ?? ""
        
        if isCertification {
            modeDescriptionLabel.text = "Certification environment for merchant integration"
            endpointTextField.text = "https://token-cert.dcap.com/v1/otu"
            apiKeyTextField.text = certKey
        } else {
            modeDescriptionLabel.text = "Production environment for live payment processing"
            endpointTextField.text = "https://token.dcap.com/v1/otu"
            apiKeyTextField.text = prodKey
        }
        
        // API key is always required
        apiKeyContainerView.alpha = 1.0
        endpointContainerView.alpha = 1.0
        apiKeyTextField.isEnabled = true
        endpointTextField.isEnabled = false // Endpoint is fixed based on mode
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func modeChanged() {
        updateUIForMode()
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    @objc private func saveTapped() {
        // Validate inputs
        guard let publicKey = apiKeyTextField.text, !publicKey.isEmpty else {
            showAlert(title: "Missing API Key", message: "Please enter your API public key")
            return
        }
        
        guard let endpoint = endpointTextField.text, !endpoint.isEmpty else {
            showAlert(title: "Missing Endpoint", message: "Please enter the API endpoint URL")
            return
        }
        
        // Validate endpoint URL
        guard URL(string: endpoint) != nil else {
            showAlert(title: "Invalid Endpoint", message: "Please enter a valid URL")
            return
        }
        
        // Save settings
        let isCertification = modeSegmentedControl.selectedSegmentIndex == 0
        
        // Save the key to the appropriate mode-specific key
        if isCertification {
            UserDefaults.standard.set(publicKey, forKey: "DatacapCertificationPublicKey")
        } else {
            UserDefaults.standard.set(publicKey, forKey: "DatacapProductionPublicKey")
        }
        
        // Also save to the legacy key for backwards compatibility
        UserDefaults.standard.set(publicKey, forKey: "DatacapPublicKey")
        UserDefaults.standard.set(endpoint, forKey: "DatacapAPIEndpoint")
        UserDefaults.standard.set(isCertification, forKey: "DatacapCertificationMode")
        
        // Notify delegate
        delegate?.settingsDidUpdate()
        
        // Show success animation
        showSuccessAndDismiss()
    }
    
    @objc private func apiKeyInfoTapped() {
        showAlert(
            title: "API Public Key",
            message: "Your unique public key for authenticating with the Datacap API. Get yours at dsidevportal.com"
        )
    }
    
    @objc private func infoCardTapped() {
        // Open dev portal in Safari
        if let url = URL(string: "https://www.dsidevportal.com") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
    
    // MARK: - Helpers
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAndDismiss() {
        // Create success overlay
        let successView = UIView()
        successView.backgroundColor = UIColor.Datacap.primaryRed
        successView.alpha = 0
        successView.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkImageView = UIImageView()
        checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkImageView.tintColor = .white
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let successLabel = UILabel()
        successLabel.text = "Settings Saved!"
        successLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        successLabel.textColor = .white
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(successView)
        successView.addSubview(checkmarkImageView)
        successView.addSubview(successLabel)
        
        NSLayoutConstraint.activate([
            successView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successView.widthAnchor.constraint(equalToConstant: 200),
            successView.heightAnchor.constraint(equalToConstant: 200),
            
            checkmarkImageView.centerXAnchor.constraint(equalTo: successView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: successView.centerYAnchor, constant: -20),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 60),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 60),
            
            successLabel.topAnchor.constraint(equalTo: checkmarkImageView.bottomAnchor, constant: 16),
            successLabel.centerXAnchor.constraint(equalTo: successView.centerXAnchor)
        ])
        
        successView.layer.cornerRadius = 16
        
        // Animate
        UIView.animate(withDuration: 0.3, animations: {
            successView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
                successView.alpha = 0
            }) { _ in
                self.dismiss(animated: true)
            }
        }
        
        // Haptic feedback
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.success)
    }
    
    private func animateIn() {
        contentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.contentView.transform = .identity
        }
    }
}