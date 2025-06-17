#!/bin/bash

# Datacap MobileToken iOS - App Store Asset Generator
# This script helps generate screenshots and prepare assets for App Store submission

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "================================================"
echo " Datacap Token - App Store Asset Generator"
echo " Copyright © 2025 Datacap Systems, Inc."
echo "================================================"
echo -e "${NC}"

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Check for required tools
check_requirements() {
    print_info "Checking requirements..."
    
    if ! command -v xcrun &> /dev/null; then
        print_error "Xcode Command Line Tools not installed"
        exit 1
    fi
    
    if ! command -v sips &> /dev/null; then
        print_error "sips (image processing) not available"
        exit 1
    fi
    
    print_status "All requirements met"
}

# Create directories
setup_directories() {
    print_info "Setting up directories..."
    
    mkdir -p AppStoreAssets/Screenshots/iPhone-6.7
    mkdir -p AppStoreAssets/Screenshots/iPhone-6.5
    mkdir -p AppStoreAssets/Screenshots/iPhone-5.5
    mkdir -p AppStoreAssets/Screenshots/iPad-12.9
    mkdir -p AppStoreAssets/Screenshots/iPad-11
    mkdir -p AppStoreAssets/Icons
    mkdir -p AppStoreAssets/Marketing
    
    print_status "Directories created"
}

# Generate app icon template
generate_icon_template() {
    print_info "Creating app icon template..."
    
    cat > AppStoreAssets/Icons/icon_template.svg << 'EOF'
<svg width="1024" height="1024" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="1024" height="1024" fill="#941a25" rx="0"/>
  
  <!-- Glass layer -->
  <rect x="100" y="100" width="824" height="824" fill="white" fill-opacity="0.1" rx="150"/>
  
  <!-- Credit Card Symbol -->
  <g transform="translate(512, 512)">
    <!-- Card outline -->
    <rect x="-300" y="-200" width="600" height="400" rx="40" fill="none" stroke="white" stroke-width="30"/>
    
    <!-- Chip -->
    <rect x="-250" y="-100" width="120" height="90" rx="10" fill="white" fill-opacity="0.8"/>
    
    <!-- Lines representing card number -->
    <rect x="-250" y="20" width="500" height="20" rx="10" fill="white" fill-opacity="0.6"/>
    <rect x="-250" y="60" width="300" height="20" rx="10" fill="white" fill-opacity="0.6"/>
    
    <!-- Lock symbol overlay -->
    <g transform="translate(150, -50)">
      <path d="M0,-60 C0,-90 25,-115 55,-115 C85,-115 110,-90 110,-60 L110,-30 L0,-30 Z" 
            fill="none" stroke="white" stroke-width="20"/>
      <rect x="-10" y="-30" width="130" height="80" rx="10" fill="white"/>
    </g>
  </g>
  
  <!-- Datacap "DC" monogram -->
  <text x="512" y="880" font-family="Arial, sans-serif" font-size="120" font-weight="bold" 
        text-anchor="middle" fill="white" fill-opacity="0.8">DC</text>
</svg>
EOF

    print_status "Icon template created at AppStoreAssets/Icons/icon_template.svg"
    print_warning "Please convert this SVG to PNG (1024x1024) using a design tool"
}

# Screenshot capture script
generate_screenshot_script() {
    print_info "Creating screenshot capture guide..."
    
    cat > AppStoreAssets/SCREENSHOT_GUIDE.md << 'EOF'
# App Store Screenshot Guide

## Required Screenshots

### Device Configurations

1. **iPhone 16 Pro Max** (6.7" - 1290 × 2796)
2. **iPhone 14 Plus** (6.5" - 1242 × 2688)
3. **iPhone 8 Plus** (5.5" - 1242 × 2208)
4. **iPad Pro 12.9"** (2048 × 2732)
5. **iPad Pro 11"** (1668 × 2388)

## Screenshot Checklist

### 1. Home Screen
- Show main screen with logo
- "Get Secure Token" button visible
- Feature cards visible
- Mode indicator showing "DEMO MODE"
- Clean status bar (9:41 AM)

### 2. Card Entry
- Card input form open
- Partially entered card number (4111 1111...)
- Keyboard visible
- Auto-formatting in action
- Card type icon visible (Visa)

### 3. Token Success
- Success overlay showing
- Green checkmark
- Token displayed (partially masked)
- Card type and masked number
- "OK" button

### 4. Settings Screen
- API Configuration screen
- Three-mode selector visible
- Demo mode selected
- API key field (empty or with dots)
- Info card at bottom

### 5. Help Overlay
- Help screen open
- "How It Works" title
- Operation modes visible
- Key features section
- Scrollable content indicated

### 6. Transaction Screen
- Transaction amount ($25.00)
- Saved token cards visible
- One token selected
- Number pad visible
- Process Transaction button

## Capturing Screenshots

### Using Simulator

1. **Set up each device:**
   ```bash
   xcrun simctl boot "iPhone 16 Pro Max"
   xcrun simctl boot "iPad Pro (12.9-inch)"
   ```

2. **Install app on each:**
   ```bash
   xcrun simctl install booted /path/to/app.app
   ```

3. **Set status bar:**
   ```bash
   xcrun simctl status_bar booted override --time "9:41" --batteryState charged --batteryLevel 100 --cellularMode active
   ```

4. **Capture screenshots:**
   - Press ⌘+S in Simulator
   - Or use: `xcrun simctl io booted screenshot screenshot.png`

### Test Data for Consistency

- **Card Number**: 4111 1111 1111 1111
- **Expiry**: 12/28
- **CVV**: 123
- **Amount**: $25.00
- **Token**: DC_REF5cGxlIFBheSBD...DEMO

## Post-Processing

### Add Device Frames (Optional)

Use tools like:
- [Rotato](https://rotato.app)
- [Previewed](https://previewed.app)
- [Screenshot](https://screenshot.com)

### Add Marketing Text

Consider adding captions:
- "Instant Tokenization"
- "Bank-Level Security"
- "Three Operating Modes"
- "Process Transactions"
- "Beautiful iOS Design"

### File Naming Convention

```
iPhone67_1_Home.png
iPhone67_2_CardEntry.png
iPhone67_3_Success.png
iPhone67_4_Settings.png
iPhone67_5_Help.png
iPhone67_6_Transaction.png
```

## Validation

Before submitting, ensure:
- [ ] No personal information visible
- [ ] Consistent time across all screenshots
- [ ] High quality (no compression artifacts)
- [ ] All required sizes included
- [ ] Features clearly visible
- [ ] Professional appearance
EOF

    print_status "Screenshot guide created at AppStoreAssets/SCREENSHOT_GUIDE.md"
}

# Generate marketing materials checklist
generate_marketing_checklist() {
    print_info "Creating marketing materials checklist..."
    
    cat > AppStoreAssets/Marketing/CHECKLIST.md << 'EOF'
# App Store Marketing Checklist

## Required Assets

### App Icon
- [ ] 1024 × 1024 PNG (no transparency, no rounded corners)
- [ ] Saved as "AppIcon1024.png"
- [ ] sRGB or Display P3 color profile
- [ ] No alpha channel

### Screenshots (Minimum 3, Maximum 10 per device)
- [ ] iPhone 6.7" (1290 × 2796) - Required
- [ ] iPhone 6.5" (1242 × 2688) - Optional
- [ ] iPhone 5.5" (1242 × 2208) - Optional
- [ ] iPad 12.9" (2048 × 2732) - Recommended
- [ ] iPad 11" (1668 × 2388) - Optional

### App Preview Video (Optional)
- [ ] 15-30 seconds
- [ ] 1920 × 1080 or 1080 × 1920
- [ ] .mov, .m4v, or .mp4 format
- [ ] < 500 MB

## Content Checklist

### App Store Description
- [ ] App name (30 characters max)
- [ ] Subtitle (30 characters max)
- [ ] Promotional text (170 characters max)
- [ ] Description (4000 characters max)
- [ ] Keywords (100 characters total)
- [ ] What's New (4000 characters max)

### URLs
- [ ] Support URL
- [ ] Privacy Policy URL
- [ ] Marketing URL (optional)

### Categories
- [ ] Primary category selected
- [ ] Secondary category selected (optional)

### Age Rating
- [ ] Questionnaire completed
- [ ] Rating received (expected: 4+)

## Pre-Submission Validation

### Technical
- [ ] App builds without warnings
- [ ] No crashes during testing
- [ ] All features working
- [ ] API endpoints configured correctly

### Content
- [ ] No placeholder text
- [ ] No developer/debug information visible
- [ ] Professional appearance
- [ ] Consistent branding

### Legal
- [ ] Copyright information correct
- [ ] Privacy policy updated
- [ ] Terms of service (if applicable)
- [ ] Export compliance information

## Submission Process

1. **Archive App**
   ```bash
   xcodebuild archive -project DatacapMobileTokenDemo.xcodeproj \
     -scheme DatacapMobileTokenDemo \
     -archivePath build/DatacapMobileTokenDemo.xcarchive
   ```

2. **Upload to App Store Connect**
   - Use Xcode Organizer
   - Or use `xcrun altool`

3. **Complete App Information**
   - Fill in all metadata
   - Upload screenshots
   - Set pricing (Free)
   - Select territories

4. **Submit for Review**
   - Add notes for reviewer
   - Submit for review
   - Monitor status

## Timeline

- Initial Review: 24-48 hours typically
- If rejected: Address feedback and resubmit
- Updates: Usually faster (within 24 hours)

## Marketing Tips

1. **Highlight Key Benefits**
   - Security
   - Speed
   - Compliance
   - Ease of use

2. **Use Social Proof**
   - "Trusted by thousands"
   - "Industry leader since 1990"
   - "Billions processed annually"

3. **Clear Call-to-Action**
   - "Download now"
   - "Try risk-free"
   - "Get started in seconds"
EOF

    print_status "Marketing checklist created"
}

# Generate App Store Connect upload script
generate_upload_script() {
    print_info "Creating upload helper script..."
    
    cat > AppStoreAssets/upload-to-appstore.sh << 'EOF'
#!/bin/bash

# App Store Connect Upload Helper

echo "App Store Connect Upload Process"
echo "================================"

# Build and Archive
echo "1. Building and archiving app..."
xcodebuild -project ../DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj \
  -scheme DatacapMobileTokenDemo \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath DatacapMobileTokenDemo.xcarchive \
  clean archive

# Export for App Store
echo "2. Exporting for App Store..."
xcodebuild -exportArchive \
  -archivePath DatacapMobileTokenDemo.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath AppStoreExport

# Validate
echo "3. Validating app..."
xcrun altool --validate-app \
  -f AppStoreExport/DatacapMobileTokenDemo.ipa \
  -t ios \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID

# Upload
echo "4. Uploading to App Store Connect..."
xcrun altool --upload-app \
  -f AppStoreExport/DatacapMobileTokenDemo.ipa \
  -t ios \
  --apiKey YOUR_API_KEY \
  --apiIssuer YOUR_ISSUER_ID

echo "Upload complete! Check App Store Connect for processing status."
EOF

    chmod +x AppStoreAssets/upload-to-appstore.sh
    print_status "Upload script created"
}

# Generate export options plist
generate_export_options() {
    print_info "Creating export options..."
    
    cat > AppStoreAssets/ExportOptions.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>generateAppStoreInformation</key>
    <true/>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
EOF

    print_status "Export options created"
}

# Main execution
main() {
    echo -e "${BLUE}Starting App Store asset generation...${NC}\n"
    
    check_requirements
    setup_directories
    generate_icon_template
    generate_screenshot_script
    generate_marketing_checklist
    generate_upload_script
    generate_export_options
    
    echo -e "\n${GREEN}✅ Asset generation complete!${NC}"
    echo -e "\n${YELLOW}Next steps:${NC}"
    echo "1. Create app icon from template: AppStoreAssets/Icons/icon_template.svg"
    echo "2. Capture screenshots following: AppStoreAssets/SCREENSHOT_GUIDE.md"
    echo "3. Review checklist at: AppStoreAssets/Marketing/CHECKLIST.md"
    echo "4. Use APP_STORE_LISTING.md for all text content"
    echo ""
    echo -e "${BLUE}Tip:${NC} Consider using Sketch, Figma, or Adobe XD to:"
    echo "  - Convert SVG icon to PNG"
    echo "  - Add device frames to screenshots"
    echo "  - Create marketing banners"
    echo ""
    echo "Good luck with your App Store submission! 🚀"
}

# Run main function
main