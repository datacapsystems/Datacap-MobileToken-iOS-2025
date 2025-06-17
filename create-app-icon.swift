#!/usr/bin/env swift

import Foundation
import CoreGraphics
import AppKit

// Datacap App Icon Generator
// Creates all required icon sizes for iOS App Store submission

class AppIconGenerator {
    
    static func generateIcon(size: CGSize) -> NSImage? {
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        // Background - Datacap Red
        let backgroundPath = NSBezierPath(rect: NSRect(origin: .zero, size: size))
        NSColor(red: 148/255, green: 26/255, blue: 37/255, alpha: 1.0).setFill()
        backgroundPath.fill()
        
        // Add subtle gradient overlay
        let gradient = NSGradient(colors: [
            NSColor(white: 1.0, alpha: 0.2),
            NSColor(white: 0.0, alpha: 0.1)
        ])
        gradient?.draw(in: NSRect(origin: .zero, size: size), angle: -45)
        
        // Glass layer
        let glassInset = size.width * 0.1
        let glassRect = NSRect(x: glassInset, y: glassInset, 
                               width: size.width - (glassInset * 2), 
                               height: size.height - (glassInset * 2))
        let glassPath = NSBezierPath(roundedRect: glassRect, 
                                      xRadius: size.width * 0.15, 
                                      yRadius: size.width * 0.15)
        NSColor(white: 1.0, alpha: 0.1).setFill()
        glassPath.fill()
        
        // Draw credit card
        let cardWidth = size.width * 0.6
        let cardHeight = cardWidth * 0.63 // Standard card ratio
        let cardX = (size.width - cardWidth) / 2
        let cardY = (size.height - cardHeight) / 2 - size.height * 0.05
        
        let cardRect = NSRect(x: cardX, y: cardY, width: cardWidth, height: cardHeight)
        let cardPath = NSBezierPath(roundedRect: cardRect, 
                                    xRadius: cardWidth * 0.06, 
                                    yRadius: cardWidth * 0.06)
        
        // Card fill with gradient
        let cardGradient = NSGradient(colors: [
            NSColor(white: 1.0, alpha: 0.95),
            NSColor(white: 0.9, alpha: 0.85)
        ])
        cardGradient?.draw(in: cardPath, angle: -45)
        
        // Card border
        NSColor(white: 1.0, alpha: 0.8).setStroke()
        cardPath.lineWidth = size.width * 0.02
        cardPath.stroke()
        
        // Draw chip
        let chipWidth = cardWidth * 0.15
        let chipHeight = chipWidth * 0.75
        let chipX = cardX + cardWidth * 0.1
        let chipY = cardY + cardHeight * 0.55
        
        let chipRect = NSRect(x: chipX, y: chipY, width: chipWidth, height: chipHeight)
        let chipPath = NSBezierPath(roundedRect: chipRect, 
                                    xRadius: chipWidth * 0.1, 
                                    yRadius: chipWidth * 0.1)
        NSColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 0.8).setFill()
        chipPath.fill()
        
        // Draw card lines
        let lineY1 = cardY + cardHeight * 0.3
        let lineY2 = cardY + cardHeight * 0.15
        
        // Line 1
        let line1 = NSBezierPath()
        line1.move(to: NSPoint(x: cardX + cardWidth * 0.1, y: lineY1))
        line1.line(to: NSPoint(x: cardX + cardWidth * 0.9, y: lineY1))
        NSColor(white: 0.7, alpha: 0.5).setStroke()
        line1.lineWidth = size.width * 0.015
        line1.stroke()
        
        // Line 2
        let line2 = NSBezierPath()
        line2.move(to: NSPoint(x: cardX + cardWidth * 0.1, y: lineY2))
        line2.line(to: NSPoint(x: cardX + cardWidth * 0.6, y: lineY2))
        line2.stroke()
        
        // Draw lock overlay
        let lockSize = size.width * 0.25
        let lockX = cardX + cardWidth - lockSize * 0.7
        let lockY = cardY + cardHeight - lockSize * 1.2
        
        // Lock shackle
        let shacklePath = NSBezierPath()
        let shackleRect = NSRect(x: lockX, y: lockY + lockSize * 0.4, 
                                 width: lockSize * 0.6, height: lockSize * 0.5)
        shacklePath.appendArc(withCenter: NSPoint(x: lockX + lockSize * 0.3, y: lockY + lockSize * 0.65),
                              radius: lockSize * 0.3,
                              startAngle: 180,
                              endAngle: 0,
                              clockwise: true)
        NSColor(white: 1.0, alpha: 0.9).setStroke()
        shacklePath.lineWidth = size.width * 0.025
        shacklePath.stroke()
        
        // Lock body
        let bodyRect = NSRect(x: lockX - lockSize * 0.05, y: lockY, 
                              width: lockSize * 0.7, height: lockSize * 0.5)
        let bodyPath = NSBezierPath(roundedRect: bodyRect, 
                                    xRadius: lockSize * 0.05, 
                                    yRadius: lockSize * 0.05)
        NSColor(white: 1.0, alpha: 0.95).setFill()
        bodyPath.fill()
        
        // DC Monogram at bottom
        let fontSize = size.width * 0.12
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .bold),
            .foregroundColor: NSColor(white: 1.0, alpha: 0.8)
        ]
        
        let text = "DC"
        let textSize = text.size(withAttributes: attributes)
        let textRect = NSRect(x: (size.width - textSize.width) / 2,
                              y: size.height * 0.08,
                              width: textSize.width,
                              height: textSize.height)
        
        text.draw(in: textRect, withAttributes: attributes)
        
        image.unlockFocus()
        
        return image
    }
    
    static func saveIcon(image: NSImage, size: Int, to url: URL) throws {
        let resized = NSImage(size: NSSize(width: size, height: size))
        resized.lockFocus()
        
        image.draw(in: NSRect(x: 0, y: 0, width: size, height: size),
                   from: NSRect(origin: .zero, size: image.size),
                   operation: .copy,
                   fraction: 1.0)
        
        resized.unlockFocus()
        
        guard let tiffData = resized.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            throw NSError(domain: "IconGenerator", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create PNG data"])
        }
        
        try pngData.write(to: url)
    }
    
    static func generateAllIcons() {
        print("🎨 Generating Datacap App Icons...")
        
        // Create output directory
        let outputDir = URL(fileURLWithPath: "AppIcons")
        try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
        
        // Generate base icon at high resolution
        guard let baseIcon = generateIcon(size: CGSize(width: 1024, height: 1024)) else {
            print("❌ Failed to generate base icon")
            return
        }
        
        // Save App Store icon
        do {
            let appStoreURL = outputDir.appendingPathComponent("AppStore-1024x1024.png")
            try saveIcon(image: baseIcon, size: 1024, to: appStoreURL)
            print("✅ App Store Icon: AppStore-1024x1024.png")
        } catch {
            print("❌ Failed to save App Store icon: \(error)")
        }
        
        // Icon sizes needed for iOS app
        let iconSizes = [
            // iPhone Notification
            (size: 40, name: "iPhone-Notification-20@2x"),
            (size: 60, name: "iPhone-Notification-20@3x"),
            
            // iPhone Settings
            (size: 58, name: "iPhone-Settings-29@2x"),
            (size: 87, name: "iPhone-Settings-29@3x"),
            
            // iPhone Spotlight
            (size: 80, name: "iPhone-Spotlight-40@2x"),
            (size: 120, name: "iPhone-Spotlight-40@3x"),
            
            // iPhone App
            (size: 120, name: "iPhone-App-60@2x"),
            (size: 180, name: "iPhone-App-60@3x"),
            
            // iPad Notification
            (size: 20, name: "iPad-Notification-20@1x"),
            (size: 40, name: "iPad-Notification-20@2x"),
            
            // iPad Settings
            (size: 29, name: "iPad-Settings-29@1x"),
            (size: 58, name: "iPad-Settings-29@2x"),
            
            // iPad Spotlight
            (size: 40, name: "iPad-Spotlight-40@1x"),
            (size: 80, name: "iPad-Spotlight-40@2x"),
            
            // iPad App
            (size: 76, name: "iPad-App-76@1x"),
            (size: 152, name: "iPad-App-76@2x"),
            
            // iPad Pro App
            (size: 167, name: "iPad-Pro-App-83.5@2x")
        ]
        
        // Generate all sizes
        for icon in iconSizes {
            do {
                let url = outputDir.appendingPathComponent("\(icon.name).png")
                try saveIcon(image: baseIcon, size: icon.size, to: url)
                print("✅ \(icon.name).png (\(icon.size)x\(icon.size))")
            } catch {
                print("❌ Failed to save \(icon.name): \(error)")
            }
        }
        
        // Create Contents.json for Asset Catalog
        let contentsJSON = """
        {
          "images" : [
            {
              "filename" : "iPhone-Notification-20@2x.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "20x20"
            },
            {
              "filename" : "iPhone-Notification-20@3x.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "20x20"
            },
            {
              "filename" : "iPhone-Settings-29@2x.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "29x29"
            },
            {
              "filename" : "iPhone-Settings-29@3x.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "29x29"
            },
            {
              "filename" : "iPhone-Spotlight-40@2x.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "40x40"
            },
            {
              "filename" : "iPhone-Spotlight-40@3x.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "40x40"
            },
            {
              "filename" : "iPhone-App-60@2x.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "60x60"
            },
            {
              "filename" : "iPhone-App-60@3x.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "60x60"
            },
            {
              "filename" : "iPad-Notification-20@1x.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "20x20"
            },
            {
              "filename" : "iPad-Notification-20@2x.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "20x20"
            },
            {
              "filename" : "iPad-Settings-29@1x.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "29x29"
            },
            {
              "filename" : "iPad-Settings-29@2x.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "29x29"
            },
            {
              "filename" : "iPad-Spotlight-40@1x.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "40x40"
            },
            {
              "filename" : "iPad-Spotlight-40@2x.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "40x40"
            },
            {
              "filename" : "iPad-App-76@1x.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "76x76"
            },
            {
              "filename" : "iPad-App-76@2x.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "76x76"
            },
            {
              "filename" : "iPad-Pro-App-83.5@2x.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "83.5x83.5"
            },
            {
              "filename" : "AppStore-1024x1024.png",
              "idiom" : "ios-marketing",
              "scale" : "1x",
              "size" : "1024x1024"
            }
          ],
          "info" : {
            "author" : "xcode",
            "version" : 1
          }
        }
        """
        
        do {
            let contentsURL = outputDir.appendingPathComponent("Contents.json")
            try contentsJSON.write(to: contentsURL, atomically: true, encoding: .utf8)
            print("✅ Contents.json created")
        } catch {
            print("❌ Failed to create Contents.json: \(error)")
        }
        
        print("\n📁 All icons generated in: \(outputDir.path)")
        print("\n📝 To use in Xcode:")
        print("1. Open your project in Xcode")
        print("2. Select Assets.xcassets")
        print("3. Delete the existing AppIcon")
        print("4. Drag the entire 'AppIcons' folder into Assets.xcassets")
        print("5. Rename it to 'AppIcon'")
    }
}

// Run the generator
AppIconGenerator.generateAllIcons()