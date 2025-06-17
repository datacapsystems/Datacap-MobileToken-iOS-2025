# Xcode Archive Guide for App Store 📱

Since command-line builds require signing configuration, here's how to create your App Store archive using Xcode:

## Step 1: Open Project in Xcode
```bash
open DatacapMobileTokenDemo/DatacapMobileTokenDemo.xcodeproj
```

## Step 2: Configure Signing
1. Select the **DatacapMobileTokenDemo** project in the navigator (left panel)
2. Select the **DatacapMobileTokenDemo** target
3. Go to **Signing & Capabilities** tab
4. Check **"Automatically manage signing"**
5. From the **Team** dropdown, select "Datacap Systems Inc"
6. Verify Bundle Identifier shows: `dsi.dcap.demo`

## Step 3: Select Build Destination
In the toolbar at the top:
- Click on the device selector (next to the app name)
- Choose **"Any iOS Device (arm64)"** or **"Generic iOS Device"**
- Do NOT select a simulator

## Step 4: Create Archive
1. Go to menu: **Product → Archive**
2. Wait for the build to complete (2-5 minutes)
3. The **Organizer** window will open automatically

## Step 5: Upload to App Store Connect
In the Organizer window:
1. Select your new archive (should be highlighted)
2. Click **"Distribute App"** button
3. Choose **"App Store Connect"**
4. Choose **"Upload"** (not Export)
5. Click **Next** through the options:
   - App Store Connect distribution options: Leave defaults
   - Re-sign options: **"Automatically manage signing"**
6. Review the summary
7. Click **"Upload"**

## Step 6: Wait for Processing
- Upload takes 2-5 minutes
- Processing on Apple's servers takes 5-30 minutes
- You'll get an email when processing completes

## Step 7: Complete App Store Listing
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app "Datacap Token"
3. In the **App Store** tab:
   - Scroll to **"Build"** section
   - Click **"Select a build before you submit your app"**
   - Choose your uploaded build
   - Add export compliance info when prompted

## Troubleshooting

### "No account" error
- Xcode → Settings → Accounts → Add Apple ID

### "No profiles" error  
- Enable "Automatically manage signing"
- Make sure correct team is selected

### Archive option grayed out
- Make sure you selected "Any iOS Device" not a simulator

### Upload fails
- Check your internet connection
- Verify you have App Manager role in App Store Connect
- Try again in a few minutes (Apple servers sometimes have issues)