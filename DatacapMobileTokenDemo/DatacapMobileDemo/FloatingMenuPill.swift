//
//  FloatingMenuPill.swift
//  DatacapMobileTokenDemo
//
//  iOS 26 Liquid Glass Floating Menu Pill
//

import UIKit

class FloatingMenuPill: UIView {
    
    // MARK: - Properties
    
    weak var delegate: FloatingMenuPillDelegate?
    
    private let containerView = UIView()
    private let blurView = UIVisualEffectView()
    private let glassLayer = CAGradientLayer()
    
    private let modeButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let helpButton = UIButton(type: .system)
    
    // iOS 26 3D circle containers
    private let settingsCircle = UIView()
    private let helpCircle = UIView()
    
    private let modeIndicator = UIView()
    private let modeLabel = UILabel()
    
    // Always expanded - no toggle functionality
    private var buttons: [UIButton] = []
    private var circles: [UIView] = []
    private var widthConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        // Container setup
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 28
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        
        // Blur effect - adaptive for dark mode
        updateBlurEffect()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(blurView)
        
        // Glass layer for iOS 26 effect
        setupGlassLayer()
        
        // Mode button (no longer toggles)
        modeButton.translatesAutoresizingMaskIntoConstraints = false
        modeButton.isUserInteractionEnabled = false  // Disable interaction
        containerView.addSubview(modeButton)
        
        // Mode indicator
        modeIndicator.translatesAutoresizingMaskIntoConstraints = false
        modeIndicator.layer.cornerRadius = 14
        modeIndicator.isUserInteractionEnabled = false
        modeButton.addSubview(modeIndicator)
        
        // Mode label
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        modeLabel.textColor = .white
        modeLabel.textAlignment = .center
        modeLabel.adjustsFontSizeToFitWidth = true
        modeLabel.minimumScaleFactor = 0.8
        modeIndicator.addSubview(modeLabel)
        
        // Settings circle (iOS 26 3D style)
        settingsCircle.translatesAutoresizingMaskIntoConstraints = false
        settingsCircle.backgroundColor = UIColor.Datacap.menuIconBackground
        settingsCircle.layer.cornerRadius = 20
        settingsCircle.alpha = 1  // Always visible
        settingsCircle.layer.shadowColor = UIColor.black.cgColor
        settingsCircle.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.1
        settingsCircle.layer.shadowOffset = CGSize(width: 0, height: 2)
        settingsCircle.layer.shadowRadius = 4
        containerView.addSubview(settingsCircle)
        
        // Settings button - Modern iOS 26 icon
        settingsButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        settingsButton.tintColor = UIColor.Datacap.menuIconTint
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        settingsCircle.addSubview(settingsButton)
        
        // Help circle (iOS 26 3D style)
        helpCircle.translatesAutoresizingMaskIntoConstraints = false
        helpCircle.backgroundColor = UIColor.Datacap.menuIconBackground
        helpCircle.layer.cornerRadius = 20
        helpCircle.alpha = 1  // Always visible
        helpCircle.layer.shadowColor = UIColor.black.cgColor
        helpCircle.layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.1
        helpCircle.layer.shadowOffset = CGSize(width: 0, height: 2)
        helpCircle.layer.shadowRadius = 4
        containerView.addSubview(helpCircle)
        
        // Help button - Modern iOS 26 icon
        helpButton.setImage(UIImage(systemName: "questionmark.bubble"), for: .normal)
        helpButton.tintColor = UIColor.Datacap.menuIconTint
        helpButton.translatesAutoresizingMaskIntoConstraints = false
        helpButton.addTarget(self, action: #selector(helpTapped), for: .touchUpInside)
        helpCircle.addSubview(helpButton)
        
        buttons = [settingsButton, helpButton]
        circles = [settingsCircle, helpCircle]
        
        // Apply glass effect to circles
        settingsCircle.applyLiquidGlass(intensity: 0.7, cornerRadius: 20, shadowOpacity: 0.1)
        helpCircle.applyLiquidGlass(intensity: 0.7, cornerRadius: 20, shadowOpacity: 0.1)
        
        updateModeAppearance()
        setupConstraints()
        setupShadow()
    }
    
    private func setupGlassLayer() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        if isDarkMode {
            glassLayer.colors = [
                UIColor.white.withAlphaComponent(0.1).cgColor,
                UIColor.white.withAlphaComponent(0.05).cgColor,
                UIColor.clear.cgColor
            ]
        } else {
            glassLayer.colors = [
                UIColor.white.withAlphaComponent(0.3).cgColor,
                UIColor.white.withAlphaComponent(0.1).cgColor,
                UIColor.white.withAlphaComponent(0.05).cgColor
            ]
        }
        
        glassLayer.locations = [0, 0.5, 1]
        glassLayer.startPoint = CGPoint(x: 0, y: 0)
        glassLayer.endPoint = CGPoint(x: 1, y: 1)
        containerView.layer.insertSublayer(glassLayer, above: blurView.layer)
    }
    
    private func updateBlurEffect() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let blurStyle: UIBlurEffect.Style = isDarkMode ? .systemMaterialDark : .systemUltraThinMaterial
        blurView.effect = UIBlurEffect(style: blurStyle)
    }
    
    private func setupShadow() {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = isDarkMode ? 0.3 : 0.15
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 20
    }
    
    private func setupConstraints() {
        // Fixed width constraint - always expanded
        widthConstraint = widthAnchor.constraint(equalToConstant: 260)
        widthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Blur view
            blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Mode button (fills container when collapsed)
            modeButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            modeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            modeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            modeButton.widthAnchor.constraint(equalToConstant: 160),
            
            // Mode indicator
            modeIndicator.centerXAnchor.constraint(equalTo: modeButton.centerXAnchor),
            modeIndicator.centerYAnchor.constraint(equalTo: modeButton.centerYAnchor),
            modeIndicator.leadingAnchor.constraint(equalTo: modeButton.leadingAnchor, constant: 12),
            modeIndicator.trailingAnchor.constraint(equalTo: modeButton.trailingAnchor, constant: -12),
            modeIndicator.heightAnchor.constraint(equalToConstant: 28),
            
            // Mode label
            modeLabel.leadingAnchor.constraint(equalTo: modeIndicator.leadingAnchor, constant: 12),
            modeLabel.trailingAnchor.constraint(equalTo: modeIndicator.trailingAnchor, constant: -12),
            modeLabel.centerYAnchor.constraint(equalTo: modeIndicator.centerYAnchor),
            
            // Settings circle
            settingsCircle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            settingsCircle.leadingAnchor.constraint(equalTo: modeButton.trailingAnchor, constant: 16),
            settingsCircle.widthAnchor.constraint(equalToConstant: 40),
            settingsCircle.heightAnchor.constraint(equalToConstant: 40),
            
            // Settings button
            settingsButton.centerXAnchor.constraint(equalTo: settingsCircle.centerXAnchor),
            settingsButton.centerYAnchor.constraint(equalTo: settingsCircle.centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 24),
            settingsButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Help circle
            helpCircle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            helpCircle.leadingAnchor.constraint(equalTo: settingsCircle.trailingAnchor, constant: 8),
            helpCircle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            helpCircle.widthAnchor.constraint(equalToConstant: 40),
            helpCircle.heightAnchor.constraint(equalToConstant: 40),
            
            // Help button
            helpButton.centerXAnchor.constraint(equalTo: helpCircle.centerXAnchor),
            helpButton.centerYAnchor.constraint(equalTo: helpCircle.centerYAnchor),
            helpButton.widthAnchor.constraint(equalToConstant: 24),
            helpButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        glassLayer.frame = containerView.bounds
    }
    
    // MARK: - Actions
    
    @objc private func toggleExpanded() {
        // No longer used - always expanded
    }
    
    @objc private func settingsTapped() {
        delegate?.floatingMenuDidTapSettings()
    }
    
    @objc private func helpTapped() {
        delegate?.floatingMenuDidTapHelp()
    }
    
    // MARK: - Public Methods
    
    func updateModeAppearance() {
        let isCertification = UserDefaults.standard.bool(forKey: "DatacapCertificationMode")
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        if isCertification {
            // Datacap grey for certification - lighter in dark mode
            let datacapGrey = isDarkMode ? 
                UIColor(red: 120/255, green: 125/255, blue: 130/255, alpha: 1.0) :
                UIColor(red: 84/255, green: 89/255, blue: 95/255, alpha: 1.0)
            modeIndicator.backgroundColor = datacapGrey
            modeLabel.text = "CERTIFICATION"
        } else {
            // Production mode - red for better visibility
            modeIndicator.backgroundColor = UIColor.Datacap.primaryRed
            modeLabel.text = "PRODUCTION"
        }
    }
    
    func collapse() {
        // No longer collapsible - always stays expanded
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            // Update all UI elements for dark mode change
            updateBlurEffect()
            setupGlassLayer()
            setupShadow()
            updateModeAppearance()
            
            // Update circle backgrounds
            settingsCircle.backgroundColor = UIColor.Datacap.menuIconBackground
            helpCircle.backgroundColor = UIColor.Datacap.menuIconBackground
            
            // Update button tints
            settingsButton.tintColor = UIColor.Datacap.menuIconTint
            helpButton.tintColor = UIColor.Datacap.menuIconTint
            
            // Update shadow opacities
            let isDarkMode = traitCollection.userInterfaceStyle == .dark
            settingsCircle.layer.shadowOpacity = isDarkMode ? 0.3 : 0.1
            helpCircle.layer.shadowOpacity = isDarkMode ? 0.3 : 0.1
        }
    }
}

// MARK: - Delegate Protocol

protocol FloatingMenuPillDelegate: AnyObject {
    func floatingMenuDidTapSettings()
    func floatingMenuDidTapHelp()
}