# Manual App Store Upload Guide 🚀

Since ThreatLocker is blocking the upload, here are alternative methods:

## Method 1: Export and Transfer IPA

1. **Export the archive to IPA**:
   ```bash
   ./export-archive-manual.sh
   ```

2. **Transfer the IPA file**:
   - Location: `~/Desktop/DatacapToken_Export_[timestamp]/DatacapMobileTokenDemo.ipa`
   - Copy to: USB drive, AirDrop, or cloud storage

3. **Upload from another Mac**:
   - Install [Transporter](https://apps.apple.com/us/app/transporter/id1450874784) from Mac App Store
   - Sign in with your Apple ID
   - Drag the .ipa file into Transporter
   - Click "Deliver"

## Method 2: Command Line Upload (altool)

1. **Create an app-specific password**:
   - Go to https://appleid.apple.com/account/manage
   - Under Security → App-Specific Passwords
   - Click "Generate Password"
   - Name it "Datacap Upload"
   - Save the password

2. **Run the upload script**:
   ```bash
   ./upload-with-altool.sh
   ```
   - Enter your Apple ID email
   - Enter the app-specific password (not your regular password)

## Method 3: Upload via Xcode on Another Machine

1. **Copy the entire archive**:
   ```bash
   # Create a zip of the archive
   cd ~/Desktop
   zip -r DatacapToken.xcarchive.zip DatacapToken.xcarchive
   ```

2. **On another Mac**:
   - Unzip the archive
   - Open Xcode
   - Window → Organizer
   - Drag the .xcarchive file into Organizer
   - Select it and click "Distribute App"
   - Follow the upload wizard

## Method 4: Direct Web Upload (If Available)

Sometimes App Store Connect allows direct IPA upload:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app "Datacap Token"
3. Go to "TestFlight" tab
4. Look for an "Upload Build" button
5. If available, upload the IPA directly

## Method 5: TestFlight Upload via API

If you have API credentials:

1. **Install App Store Connect CLI**:
   ```bash
   npm install -g @appstore/cli
   ```

2. **Upload using CLI**:
   ```bash
   appstore upload --ipa ~/Desktop/DatacapToken_Export/DatacapMobileTokenDemo.ipa
   ```

## Troubleshooting

### "Invalid IPA" Error
- Make sure you exported for App Store distribution
- Check that signing is correct
- Verify bundle ID matches App Store Connect

### "Authentication Failed"
- Use app-specific password, not your Apple ID password
- Make sure your account has the correct permissions
- Check if 2FA is enabled (it should be)

### "Network Error"
- ThreatLocker might be blocking even altool
- Try from personal network/device
- Use a VPN if necessary

## What Happens After Upload

1. **Processing Time**: 5-30 minutes
2. **Email Confirmation**: You'll get an email when processing completes
3. **App Store Connect**: Build appears under TestFlight tab
4. **Select for Review**: Choose the build in App Store tab

## Emergency Option: Request IT Exception

If none of these work, request a temporary ThreatLocker exception for:
- `xcrun altool`
- `Transporter.app`
- Port 443 to `*.apple.com`

Good luck with the upload! 🎉