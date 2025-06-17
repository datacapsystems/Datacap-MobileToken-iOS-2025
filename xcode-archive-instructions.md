# Manual Xcode Archive Instructions 🎯

Since the command-line builds are having architecture issues, let's use Xcode's GUI which handles this correctly:

## Step-by-Step Instructions:

### 1. Open Xcode
```bash
cd /Users/edcrotty/Documents/Datacap-MobileToken-iOS-2025
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
```

### 2. Configure Build Settings
- In Xcode, select the **DatacapMobileTokenDemo** project (blue icon in left panel)
- Select the **DatacapMobileTokenDemo** target
- Go to **Build Settings** tab
- Search for "Architectures"
- Make sure **Architectures** is set to "Standard Architectures (arm64)"
- Make sure **Build Active Architecture Only** is set to "No" for Release

### 3. Select Destination
- In the toolbar at the top, click on the device selector
- Choose **"Any iOS Device (arm64)"**
- Do NOT select a simulator or "My Mac"

### 4. Create Archive
- Menu: **Product → Archive**
- Wait for build to complete (2-5 minutes)
- The Organizer window will open automatically

### 5. Export IPA from Organizer
- In the Organizer, select your archive
- Click **"Distribute App"**
- Choose **"App Store Connect"**
- Choose **"Export"** (not Upload)
- Click through the options (use defaults)
- Save the IPA to your Desktop

### 6. Upload with Transporter
- Open **Transporter**
- Drag the exported IPA into Transporter
- Click **"Deliver"**

## Why This Works:
- Xcode's GUI properly configures the build for iOS devices
- The export process ensures the binary has the correct architecture
- Transporter handles the upload without ThreatLocker interference

## Quick Alternative:
If you see the archive in Organizer from earlier, you can:
1. Open Xcode
2. Go to **Window → Organizer**
3. Find your archive
4. Click **"Distribute App"** → **"App Store Connect"** → **"Export"**
5. This will create a proper IPA with the binary included