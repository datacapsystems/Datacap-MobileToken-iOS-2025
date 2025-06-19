//
//  HelpOverlayView.swift
//  DatacapMobileTokenDemo
//
//  iOS 26 Liquid Glass Help Overlay
//

import UIKit

class HelpOverlayView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dismissButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Background blur
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        
        // Card container
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor.white.withAlphaComponent(0.98)
        card.layer.cornerRadius = 32
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.2
        card.layer.shadowOffset = CGSize(width: 0, height: 10)
        card.layer.shadowRadius = 20
        addSubview(card)
        
        // Header
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = UIColor(red: 246/255, green: 249/255, blue: 252/255, alpha: 0.5)
        headerView.layer.cornerRadius = 20
        card.addSubview(headerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Quick Start Guide"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = UIColor(red: 35/255, green: 31/255, blue: 32/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = UIColor(red: 84/255, green: 89/255, blue: 95/255, alpha: 1.0)
        closeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        // Scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        card.addSubview(scrollView)
        
        // Content view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Add content sections
        var previousView: UIView? = nil
        let sections = [
            ("What is this?", "Official Datacap tool for instant payment tokenization. Transform card data into secure tokens without writing code.", false),
            ("Key Features", "• Generate tokens in seconds\n• Switch environments instantly\n• Enterprise-grade security\n• PCI compliance ready\n• All major card brands", false),
            ("Two Environments", "Certification: Development testing\nProduction: Live transactions\n\nBoth use real Datacap infrastructure.", false),
            ("Simple Process", "1. Add API key in Settings\n2. Choose environment\n3. Tap Generate Token\n4. Enter card details\n5. Copy & use token", false),
            ("Get Started", "Get your API keys at:\ndsidevportal.com\n\nQuestions? Contact:\nsupport@datacapsystems.com", false)
        ]
        
        for (title, content, isCode) in sections {
            let sectionView = createSection(title: title, content: content, isCode: isCode)
            contentView.addSubview(sectionView)
            
            NSLayoutConstraint.activate([
                sectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                sectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                sectionView.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? contentView.topAnchor, constant: previousView == nil ? 20 : 16)
            ])
            
            previousView = sectionView
        }
        
        // Add bottom constraint for the last section
        if let lastView = previousView {
            NSLayoutConstraint.activate([
                lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
        
        // Got it button
        dismissButton.setTitle("Got it!", for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        dismissButton.backgroundColor = UIColor(red: 148/255, green: 26/255, blue: 37/255, alpha: 1.0)
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.layer.cornerRadius = 16
        dismissButton.layer.shadowColor = UIColor(red: 148/255, green: 26/255, blue: 37/255, alpha: 1.0).cgColor
        dismissButton.layer.shadowOpacity = 0.3
        dismissButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        dismissButton.layer.shadowRadius = 8
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        card.addSubview(dismissButton)
        
        // Determine if this is an iPad
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        
        // Constraints
        NSLayoutConstraint.activate([
            // Blur view
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Card
            card.centerXAnchor.constraint(equalTo: centerXAnchor),
            card.centerYAnchor.constraint(equalTo: centerYAnchor),
            card.heightAnchor.constraint(equalToConstant: 600),
        ])
        
        // Width constraints based on device
        if isIPad {
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
                card.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
                card.widthAnchor.constraint(lessThanOrEqualToConstant: 800)
            ])
        } else {
            NSLayoutConstraint.activate([
                card.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                card.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ])
        }
        
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            headerView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            // Close button
            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -20),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Dismiss button
            dismissButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            dismissButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            dismissButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -24),
            dismissButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Add tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        addGestureRecognizer(tapGesture)
        
        // Initial state for animation
        alpha = 0
        card.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).translatedBy(x: 0, y: 50)
        card.alpha = 0
        card.tag = 1002
        tag = 1001
    }
    
    private func createSection(title: String, content: String, isCode: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor(red: 35/255, green: 31/255, blue: 32/255, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = isCode ? .monospacedSystemFont(ofSize: 14, weight: .regular) : .systemFont(ofSize: 16, weight: .regular)
        contentLabel.textColor = isCode ? UIColor(red: 84/255, green: 89/255, blue: 95/255, alpha: 1.0) : UIColor(red: 35/255, green: 31/255, blue: 32/255, alpha: 1.0)
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if isCode {
            contentLabel.backgroundColor = UIColor(red: 246/255, green: 249/255, blue: 252/255, alpha: 0.5)
            contentLabel.layer.cornerRadius = 8
            contentLabel.layer.masksToBounds = true
            contentLabel.textAlignment = .left
            // Add padding for code blocks
            let paddedContainer = UIView()
            paddedContainer.translatesAutoresizingMaskIntoConstraints = false
            paddedContainer.backgroundColor = UIColor(red: 246/255, green: 249/255, blue: 252/255, alpha: 0.5)
            paddedContainer.layer.cornerRadius = 8
            container.addSubview(paddedContainer)
            paddedContainer.addSubview(contentLabel)
            
            NSLayoutConstraint.activate([
                paddedContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                paddedContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                paddedContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                paddedContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                
                contentLabel.topAnchor.constraint(equalTo: paddedContainer.topAnchor, constant: 12),
                contentLabel.leadingAnchor.constraint(equalTo: paddedContainer.leadingAnchor, constant: 12),
                contentLabel.trailingAnchor.constraint(equalTo: paddedContainer.trailingAnchor, constant: -12),
                contentLabel.bottomAnchor.constraint(equalTo: paddedContainer.bottomAnchor, constant: -12)
            ])
        } else {
            container.addSubview(contentLabel)
            NSLayoutConstraint.activate([
                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
    
    func show() {
        guard let card = viewWithTag(1002) else { return }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.alpha = 1
        }
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.3) {
            card.alpha = 1
            card.transform = .identity
        }
    }
    
    @objc private func dismiss() {
        guard let card = viewWithTag(1002) else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            card.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            card.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if let card = viewWithTag(1002), !card.frame.contains(location) {
            dismiss()
        }
    }
}