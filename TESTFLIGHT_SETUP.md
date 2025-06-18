# TestFlight Setup Guide 🚀

TestFlight lets you test your app on real devices before it's approved for the App Store.

## Quick Setup Steps

### 1. Check Build Status
First, make sure your build is processed:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app "Datacap Token"
3. Click on **"TestFlight"** tab
4. You should see your build (1.1) listed

**Note**: If the build shows a yellow warning icon, you may need to:
- Answer export compliance questions (just confirm HTTPS only)
- Provide missing information

### 2. Enable TestFlight Testing

#### Internal Testing (Fastest - Test Now!)
1. In TestFlight tab, click **"Internal Testing"** in the left sidebar
2. Click the **"+"** to create a new Internal Group
3. Name it "Datacap Team" or similar
4. Click **"Create"**

#### Add Testers to Internal Group
1. Click on your new group
2. Click **"+"** next to Testers
3. Add yourself and any team members (up to 100 people)
4. They must be members of your App Store Connect team

#### Add Build to Test
1. Still in your Internal Group
2. Click **"+"** next to Builds
3. Select build 1.1
4. Click **"Add"**

### 3. Install TestFlight on Your iPhone

1. On your iPhone, download **TestFlight** from the App Store
2. Open TestFlight
3. Sign in with the same Apple ID used in App Store Connect

### 4. Install Your App

Once you're added as a tester:
1. You'll receive an email invitation
2. Open the email on your iPhone
3. Tap **"View in TestFlight"**
4. Or just open TestFlight - the app should appear
5. Tap **"Install"**

## External Testing (For Non-Team Members)

If you want to test with people outside your team:

1. Click **"External Testing"** in the left sidebar
2. Click **"+"** to create a new group
3. Add up to 10,000 testers by email
4. **IMPORTANT**: External testing requires App Review (1-2 days)

### External Testing Requirements
- Test Information (what to test)
- Contact information
- Privacy Policy URL
- Beta App Description

## Quick Internal Testing (Do This Now!)

Since you want to test immediately:

1. Go to TestFlight → Internal Testing
2. Create a group
3. Add yourself
4. Add build 1.1
5. Install TestFlight on your phone
6. The app should appear immediately!

## Troubleshooting

### Build Not Showing?
- Wait 5-10 minutes for processing
- Refresh the page
- Check your email for processing errors

### Can't Install?
- Make sure you're using the same Apple ID
- Check that you're added to the Internal Testing group
- Verify the build is added to your group

### Export Compliance Warning?
- Click on the warning
- Select "Use Encryption: Yes"
- Select "Exempt from ERN"
- Save

## TestFlight Features

- **90-day expiration**: Builds expire after 90 days
- **Automatic updates**: Testers get new builds automatically
- **Feedback**: Testers can send feedback with screenshots
- **Crash reports**: Get symbolicated crash logs

## Next Steps

1. Test all features on real device
2. Test on different iOS versions
3. Test on both WiFi and cellular
4. Submit feedback through TestFlight
5. Fix any issues found
6. Upload new builds as needed

Remember: Internal testing is available immediately, while external testing requires review!