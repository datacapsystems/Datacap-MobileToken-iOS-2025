//
//  SettingsViewController.swift
//  DatacapMobileTokenDemo
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    var onSettingsChanged: ((String, String?) -> Void)?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    private let modeSegmentedControl = UISegmentedControl(items: ["Demo Mode", "Production"])
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
        setupConstraints()
        loadCurrentSettings()
        updateUIForMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Content container
        contentView.backgroundColor = UIColor.Datacap.lightBackground
        contentView.layer.cornerRadius = 24
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.applyLiquidGlass(intensity: 0.95, cornerRadius: 24, shadowOpacity: 0.2)
        
        // Header
        headerView.backgroundColor = .clear
        
        titleLabel.text = "API Configuration"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor.Datacap.nearBlack
        
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor.Datacap.darkGray
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        // Mode selector - use lighter red for selected segment
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        modeSegmentedControl.backgroundColor = UIColor.Datacap.lightBackground
        modeSegmentedControl.selectedSegmentTintColor = UIColor.Datacap.primaryRed.withAlphaComponent(0.8) // Lighter red
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Datacap.darkGray]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        modeSegmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        modeSegmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        modeDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        modeDescriptionLabel.textColor = UIColor.Datacap.darkGray
        modeDescriptionLabel.numberOfLines = 0
        modeDescriptionLabel.text = "Demo mode uses mock tokenization for testing"
        
        // API Key section
        apiKeyContainerView.applyLiquidGlass(intensity: 0.8, cornerRadius: 16, shadowOpacity: 0.05)
        
        apiKeyLabel.text = "API Public Key"
        apiKeyLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        apiKeyLabel.textColor = UIColor.Datacap.nearBlack
        
        apiKeyTextField.placeholder = "Enter your public key"
        apiKeyTextField.borderStyle = .none
        apiKeyTextField.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        apiKeyTextField.textColor = UIColor.Datacap.nearBlack
        apiKeyTextField.autocapitalizationType = .none
        apiKeyTextField.autocorrectionType = .no
        apiKeyTextField.clearButtonMode = .whileEditing
        
        apiKeyInfoButton.addTarget(self, action: #selector(apiKeyInfoTapped), for: .touchUpInside)
        
        // Endpoint section
        endpointContainerView.applyLiquidGlass(intensity: 0.8, cornerRadius: 16, shadowOpacity: 0.05)
        
        endpointLabel.text = "API Endpoint"
        endpointLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        endpointLabel.textColor = UIColor.Datacap.nearBlack
        
        endpointTextField.text = "https://api.datacapsystems.com/v1/tokenize"
        endpointTextField.placeholder = "API Endpoint URL"
        endpointTextField.borderStyle = .none
        endpointTextField.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        endpointTextField.textColor = UIColor.Datacap.nearBlack
        endpointTextField.autocapitalizationType = .none
        endpointTextField.autocorrectionType = .no
        endpointTextField.keyboardType = .URL
        endpointTextField.clearButtonMode = .never
        
        // Endpoint help label
        endpointHelpLabel.text = "Official Datacap API endpoint (rarely needs changing)"
        endpointHelpLabel.font = .systemFont(ofSize: 12, weight: .regular)
        endpointHelpLabel.textColor = UIColor.Datacap.blueGray
        endpointHelpLabel.numberOfLines = 0
        
        // Save button - use darker red like the main CTA
        saveButton.setTitle("Save Configuration", for: .normal)
        let darkRed = UIColor(red: 120/255, green: 20/255, blue: 30/255, alpha: 1.0) // Same dark red as main CTA
        saveButton.backgroundColor = darkRed
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        saveButton.layer.cornerRadius = 16
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
        
        infoTextLabel.text = "Register at dsidevportal.com to get your public key and API endpoint for production tokenization."
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
        headerView.addSubview(titleLabel)
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
    }
    
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        
        NSLayoutConstraint.activate([
            // Content view
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85),
            
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
            
            // Mode selector
            modeSegmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            modeSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            modeSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            modeSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            modeDescriptionLabel.topAnchor.constraint(equalTo: modeSegmentedControl.bottomAnchor, constant: 8),
            modeDescriptionLabel.leadingAnchor.constraint(equalTo: modeSegmentedControl.leadingAnchor),
            modeDescriptionLabel.trailingAnchor.constraint(equalTo: modeSegmentedControl.trailingAnchor),
            
            // API Key container
            apiKeyContainerView.topAnchor.constraint(equalTo: modeDescriptionLabel.bottomAnchor, constant: 24),
            apiKeyContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            apiKeyContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            apiKeyContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            apiKeyLabel.topAnchor.constraint(equalTo: apiKeyContainerView.topAnchor, constant: 12),
            apiKeyLabel.leadingAnchor.constraint(equalTo: apiKeyContainerView.leadingAnchor, constant: 16),
            
            apiKeyInfoButton.centerYAnchor.constraint(equalTo: apiKeyLabel.centerYAnchor),
            apiKeyInfoButton.leadingAnchor.constraint(equalTo: apiKeyLabel.trailingAnchor, constant: 8),
            
            apiKeyTextField.topAnchor.constraint(equalTo: apiKeyLabel.bottomAnchor, constant: 8),
            apiKeyTextField.leadingAnchor.constraint(equalTo: apiKeyContainerView.leadingAnchor, constant: 16),
            apiKeyTextField.trailingAnchor.constraint(equalTo: apiKeyContainerView.trailingAnchor, constant: -16),
            apiKeyTextField.bottomAnchor.constraint(equalTo: apiKeyContainerView.bottomAnchor, constant: -12),
            
            // Endpoint container
            endpointContainerView.topAnchor.constraint(equalTo: apiKeyContainerView.bottomAnchor, constant: 16),
            endpointContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            endpointContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            endpointContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            endpointLabel.topAnchor.constraint(equalTo: endpointContainerView.topAnchor, constant: 12),
            endpointLabel.leadingAnchor.constraint(equalTo: endpointContainerView.leadingAnchor, constant: 16),
            
            endpointTextField.topAnchor.constraint(equalTo: endpointLabel.bottomAnchor, constant: 8),
            endpointTextField.leadingAnchor.constraint(equalTo: endpointContainerView.leadingAnchor, constant: 16),
            endpointTextField.trailingAnchor.constraint(equalTo: endpointContainerView.trailingAnchor, constant: -16),
            
            endpointHelpLabel.topAnchor.constraint(equalTo: endpointTextField.bottomAnchor, constant: 4),
            endpointHelpLabel.leadingAnchor.constraint(equalTo: endpointContainerView.leadingAnchor, constant: 16),
            endpointHelpLabel.trailingAnchor.constraint(equalTo: endpointContainerView.trailingAnchor, constant: -16),
            endpointHelpLabel.bottomAnchor.constraint(equalTo: endpointContainerView.bottomAnchor, constant: -8),
            
            // Save button
            saveButton.topAnchor.constraint(equalTo: endpointContainerView.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Info card
            infoCardView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 32),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            infoCardView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -24),
            
            infoIconView.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 16),
            infoIconView.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            infoIconView.widthAnchor.constraint(equalToConstant: 24),
            infoIconView.heightAnchor.constraint(equalToConstant: 24),
            
            infoTitleLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 16),
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func closeTapped() {
        dismissKeyboard()
        animateOut()
    }
    
    @objc private func modeChanged() {
        updateUIForMode()
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    @objc private func saveTapped() {
        dismissKeyboard()
        
        let publicKey = apiKeyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let endpoint = endpointTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate inputs in production mode
        if modeSegmentedControl.selectedSegmentIndex == 1 {
            if publicKey.isEmpty {
                showError("Please enter your API public key")
                return
            }
            
            // Validate API key format (should be 32 characters for Datacap)
            if publicKey.count < 32 {
                showError("API key should be at least 32 characters")
                return
            }
            
            if endpoint?.isEmpty == true {
                showError("Please enter the API endpoint URL")
                return
            }
            
            // Validate URL format
            if let urlString = endpoint, !urlString.starts(with: "https://") && !urlString.starts(with: "http://") {
                showError("API endpoint must start with https:// or http://")
                return
            }
        }
        
        // Disable button during save
        saveButton.isEnabled = false
        saveButton.alpha = 0.6
        
        // Save to UserDefaults
        UserDefaults.standard.set(modeSegmentedControl.selectedSegmentIndex == 0, forKey: "DatacapDemoMode")
        UserDefaults.standard.set(publicKey, forKey: "DatacapPublicKey")
        UserDefaults.standard.set(endpoint, forKey: "DatacapAPIEndpoint")
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Show success animation
        showSuccess()
        
        // Notify delegate and close after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.onSettingsChanged?(publicKey, endpoint)
            self.animateOut()
        }
    }
    
    @objc private func apiKeyInfoTapped() {
        let alert = UIAlertController(title: "API Public Key", message: "Your public key is provided by Datacap Systems when you register for API access. It's used to authenticate your tokenization requests.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func infoCardTapped() {
        if let url = URL(string: "https://www.dsidevportal.com/") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
    
    // MARK: - Helper Methods
    
    private func loadCurrentSettings() {
        let isDemoMode = UserDefaults.standard.object(forKey: "DatacapDemoMode") as? Bool ?? true
        let publicKey = UserDefaults.standard.string(forKey: "DatacapPublicKey") ?? ""
        let endpoint = UserDefaults.standard.string(forKey: "DatacapAPIEndpoint") ?? "https://api.datacapsystems.com/v1/tokenize"
        
        modeSegmentedControl.selectedSegmentIndex = isDemoMode ? 0 : 1
        apiKeyTextField.text = publicKey
        endpointTextField.text = endpoint
    }
    
    private func updateUIForMode() {
        let isDemoMode = modeSegmentedControl.selectedSegmentIndex == 0
        
        UIView.animate(withDuration: 0.3) {
            self.apiKeyContainerView.alpha = isDemoMode ? 0.5 : 1.0
            self.endpointContainerView.alpha = isDemoMode ? 0.5 : 1.0
            self.apiKeyTextField.isEnabled = !isDemoMode
            self.endpointTextField.isEnabled = !isDemoMode
            
            if isDemoMode {
                self.modeDescriptionLabel.text = "Demo mode uses mock tokenization for testing"
            } else {
                self.modeDescriptionLabel.text = "Production mode uses real API for tokenization"
            }
        }
    }
    
    private func showError(_ message: String) {
        let errorView = UIView()
        errorView.backgroundColor = UIColor.systemRed
        errorView.layer.cornerRadius = 8
        errorView.alpha = 0
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        
        errorView.addSubview(label)
        view.addSubview(errorView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            errorView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            errorView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            label.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -12),
            label.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -16)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            errorView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                errorView.alpha = 0
            }) { _ in
                errorView.removeFromSuperview()
            }
        }
    }
    
    private func showSuccess() {
        let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmark.tintColor = UIColor.systemGreen
        checkmark.contentMode = .scaleAspectFit
        checkmark.alpha = 0
        checkmark.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        view.addSubview(checkmark)
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkmark.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            checkmark.widthAnchor.constraint(equalToConstant: 60),
            checkmark.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            checkmark.alpha = 1
            checkmark.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.3, options: [], animations: {
                checkmark.alpha = 0
            }) { _ in
                checkmark.removeFromSuperview()
            }
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