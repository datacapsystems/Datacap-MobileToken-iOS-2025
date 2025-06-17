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
