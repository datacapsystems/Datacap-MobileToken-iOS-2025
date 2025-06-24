//
//  GlassMorphismExtensions.swift
//  DatacapMobileTokenDemo
//
//  Copyright © 2025 Datacap Systems, Inc. All rights reserved.
//

import UIKit

// MARK: - Glass Morphism Extensions for iOS 26 Liquid Glass Design

extension UIView {
    
    /// Applies iOS 26 Liquid Glass effect to the view
    func applyLiquidGlass(
        intensity: CGFloat = 0.85,
        cornerRadius: CGFloat = 20,
        shadowOpacity: Float = 0.15
    ) {
        // Background blur effect - adapts to dark mode
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        let blurStyle: UIBlurEffect.Style = isDarkMode ? .systemMaterialDark : .systemUltraThinMaterial
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = cornerRadius
        blurView.clipsToBounds = true
        
        // Insert blur view at the bottom
        insertSubview(blurView, at: 0)
        
        // Glass overlay with gradient - different for dark mode
        let glassOverlay = CAGradientLayer()
        glassOverlay.frame = bounds
        
        if isDarkMode {
            glassOverlay.colors = [
                UIColor.white.withAlphaComponent(0.08).cgColor,
                UIColor.white.withAlphaComponent(0.03).cgColor,
                UIColor.clear.cgColor
            ]
        } else {
            glassOverlay.colors = [
                UIColor.white.withAlphaComponent(0.15).cgColor,
                UIColor.white.withAlphaComponent(0.05).cgColor,
                UIColor.clear.cgColor
            ]
        }
        
        glassOverlay.locations = [0.0, 0.5, 1.0]
        glassOverlay.startPoint = CGPoint(x: 0, y: 0)
        glassOverlay.endPoint = CGPoint(x: 1, y: 1)
        glassOverlay.cornerRadius = cornerRadius
        
        layer.insertSublayer(glassOverlay, at: 1)
        
        // Specular highlight for glass effect - reduced in dark mode
        let specularLayer = CAGradientLayer()
        specularLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.3)
        specularLayer.colors = [
            UIColor.white.withAlphaComponent(isDarkMode ? 0.12 : 0.25).cgColor,
            UIColor.clear.cgColor
        ]
        specularLayer.startPoint = CGPoint(x: 0, y: 0)
        specularLayer.endPoint = CGPoint(x: 0, y: 1)
        specularLayer.cornerRadius = cornerRadius
        
        layer.insertSublayer(specularLayer, at: 2)
        
        // Configure view properties - different background for dark mode
        layer.cornerRadius = cornerRadius
        if isDarkMode {
            backgroundColor = UIColor(white: 0.1, alpha: intensity * 0.2)
        } else {
            backgroundColor = UIColor.white.withAlphaComponent(intensity * 0.1)
        }
        
        // Soft shadow for depth - lighter in dark mode
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = isDarkMode ? shadowOpacity * 0.5 : shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 16
        
        // Border for glass edge - adjusted for dark mode
        layer.borderWidth = 0.5
        layer.borderColor = isDarkMode ? 
            UIColor.white.withAlphaComponent(0.1).cgColor : 
            UIColor.white.withAlphaComponent(0.2).cgColor
    }
    
    /// Adds a subtle glass shimmer animation
    func addGlassShimmer() {
        let shimmerLayer = CAGradientLayer()
        shimmerLayer.frame = CGRect(x: -bounds.width, y: 0, width: bounds.width * 3, height: bounds.height)
        shimmerLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.15).cgColor,
            UIColor.clear.cgColor
        ]
        shimmerLayer.locations = [0.3, 0.5, 0.7]
        shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
        shimmerLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 1)
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width * 2
        animation.duration = 3
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        shimmerLayer.add(animation, forKey: "shimmer")
        layer.addSublayer(shimmerLayer)
    }
}

// MARK: - Datacap Brand Colors

extension UIColor {
    
    struct Datacap {
        // Core brand colors (unchanged)
        static let primaryRed = UIColor(red: 148/255, green: 26/255, blue: 37/255, alpha: 1.0) // #941a25
        
        // Dynamic colors that adapt to dark mode
        static let darkGray = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 200/255, green: 205/255, blue: 210/255, alpha: 1.0) // Lighter for better contrast
            } else {
                return UIColor(red: 84/255, green: 89/255, blue: 95/255, alpha: 1.0) // #54595f
            }
        }
        
        static let blueGray = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 180/255, green: 190/255, blue: 200/255, alpha: 1.0) // Lighter for better contrast
            } else {
                return UIColor(red: 119/255, green: 135/255, blue: 153/255, alpha: 1.0) // #778799
            }
        }
        
        static let nearBlack = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 240/255, green: 240/255, blue: 242/255, alpha: 1.0) // Light text in dark mode
            } else {
                return UIColor(red: 35/255, green: 31/255, blue: 32/255, alpha: 1.0) // #231f20
            }
        }
        
        static let lightBackground = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 18/255, green: 18/255, blue: 20/255, alpha: 1.0) // Darker background for better contrast
            } else {
                return UIColor(red: 246/255, green: 249/255, blue: 252/255, alpha: 1.0) // #f6f9fc
            }
        }
        
        // New adaptive colors for form elements
        static let formBackground = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 30/255, green: 30/255, blue: 32/255, alpha: 1.0) // Darker for better separation
            } else {
                return UIColor.white
            }
        }
        
        static let formText = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 250/255, green: 250/255, blue: 252/255, alpha: 1.0) // Brighter white for better contrast
            } else {
                return UIColor(red: 35/255, green: 31/255, blue: 32/255, alpha: 1.0)
            }
        }
        
        // New colors for better dark mode support
        static let menuBackground = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 0.95)
            } else {
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.95)
            }
        }
        
        static let menuIconBackground = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 0.9)
            } else {
                return UIColor.white.withAlphaComponent(0.9)
            }
        }
        
        static let menuIconTint = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor(red: 200/255, green: 205/255, blue: 210/255, alpha: 1.0)
            } else {
                return UIColor(red: 84/255, green: 89/255, blue: 95/255, alpha: 1.0)
            }
        }
        
        // Glass variants
        static let glassRed = primaryRed.withAlphaComponent(0.85)
        static let glassGray = darkGray.withAlphaComponent(0.7)
        static let glassBackground = lightBackground.withAlphaComponent(0.95)
    }
    
    /// Returns a darker version of the color
    func darker(by percentage: CGFloat = 0.3) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(
            red: max(red - percentage, 0),
            green: max(green - percentage, 0),
            blue: max(blue - percentage, 0),
            alpha: alpha
        )
    }
}

// MARK: - Modern Button Styles

extension UIButton {
    
    /// Applies Datacap branded glass morphism button style
    func applyDatacapGlassStyle(isPrimary: Bool = true) {
        // Remove default styling
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // Apply glass morphism
        applyLiquidGlass(intensity: 0.9, cornerRadius: 16, shadowOpacity: 0.2)
        
        // Configure colors based on button type and dark mode
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        
        if isPrimary {
            // Primary button - red remains consistent but adjust for dark mode
            if isDarkMode {
                backgroundColor = UIColor.Datacap.primaryRed.withAlphaComponent(0.9)
                layer.borderWidth = 1
                layer.borderColor = UIColor.Datacap.primaryRed.cgColor
            } else {
                backgroundColor = UIColor.Datacap.glassRed
            }
            setTitleColor(.white, for: .normal)
            setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        } else {
            // Secondary button - better contrast in dark mode
            if isDarkMode {
                backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 62/255, alpha: 0.9)
                setTitleColor(UIColor.Datacap.formText, for: .normal)
                setTitleColor(UIColor.Datacap.darkGray, for: .highlighted)
            } else {
                backgroundColor = UIColor.Datacap.glassGray
                setTitleColor(UIColor.Datacap.nearBlack, for: .normal)
                setTitleColor(UIColor.Datacap.darkGray, for: .highlighted)
            }
        }
        
        // Typography
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        // Content padding
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        
        // Store existing targets before adding animation handlers
        let hasCustomTargets = !allTargets.isEmpty
        
        // Add animation handlers without interfering with existing targets
        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpOutside, .touchCancel])
        
        // Only add touchUpInside if no custom targets exist
        if !hasCustomTargets {
            addTarget(self, action: #selector(buttonTouchUp), for: .touchUpInside)
        }
    }
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.alpha = 0.9
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.transform = .identity
            self.alpha = 1.0
        }
        
        // Send the touch up inside action if we're handling it
        if allTargets.count == 1 {
            sendActions(for: .touchUpInside)
        }
    }
}

// MARK: - Loading Indicator

class LiquidGlassLoadingView: UIView {
    
    private let spinner = CAShapeLayer()
    private let glassLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Apply glass effect
        applyLiquidGlass(intensity: 0.95, cornerRadius: 12, shadowOpacity: 0.1)
        
        // Create spinner path
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                               radius: 20,
                               startAngle: 0,
                               endAngle: .pi * 2,
                               clockwise: true)
        
        spinner.path = path.cgPath
        spinner.fillColor = UIColor.clear.cgColor
        spinner.strokeColor = UIColor.Datacap.primaryRed.cgColor
        spinner.lineWidth = 3
        spinner.strokeEnd = 0.8
        spinner.lineCap = .round
        
        layer.addSublayer(spinner)
        
        // Add rotation animation
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .infinity
        spinner.add(rotation, forKey: "rotation")
    }
    
    func startAnimating() {
        isHidden = false
    }
    
    func stopAnimating() {
        isHidden = true
    }
}