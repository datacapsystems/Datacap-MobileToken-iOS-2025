# Manual Screenshot Capture Guide 📸

Since the automated script is having issues, here's how to capture screenshots manually:

## Option 1: Using Simulator Menu (Easiest)

1. **Navigate to each screen in the app**
2. **Press ⌘+S** (or Device → Screenshot in menu)
3. **Save with these names:**
   - `1_Home.png` - Main screen
   - `2_CardEntry.png` - Card input with keyboard
   - `3_Success.png` - Token success
   - `4_Settings.png` - API settings
   - `5_Help.png` - Help overlay
   - `6_Transaction.png` - Transaction screen

## Option 2: Using Terminal Commands

For each screen, run:

```bash
# Navigate to the screen in the app, then run:
xcrun simctl io booted screenshot 1_Home.png
xcrun simctl io booted screenshot 2_CardEntry.png
xcrun simctl io booted screenshot 3_Success.png
xcrun simctl io booted screenshot 4_Settings.png
xcrun simctl io booted screenshot 5_Help.png
xcrun simctl io booted screenshot 6_Transaction.png
```

## Option 3: Create Screenshots Directory First

```bash
# Create a directory
mkdir -p AppStoreAssets/Screenshots/Final

# Navigate to it
cd AppStoreAssets/Screenshots/Final

# Then capture each screen:
xcrun simctl io booted screenshot 1_Home.png
# ... navigate to next screen ...
xcrun simctl io booted screenshot 2_CardEntry.png
# ... and so on
```

## Screen Setup Guide

### 1_Home.png
- Main screen
- Logo visible
- "Get Secure Token" button
- "Process Transaction" button
- DEMO MODE indicator

### 2_CardEntry.png
- Tap "Get Secure Token"
- Type: 4111 1111
- Keyboard visible
- Visa icon showing

### 3_Success.png
- Complete card: 4111 1111 1111 1111
- Expiry: 12/28
- CVV: 123
- Tap Submit
- Green checkmark visible

### 4_Settings.png
- Close success (OK)
- Tap gear icon
- API Configuration visible
- Demo mode selected

### 5_Help.png
- Back to main
- Tap ? icon
- "How It Works" visible
- Mode cards visible

### 6_Transaction.png
- Close help (X)
- Tap "Process Transaction"
- Enter $25.00
- Number pad visible

## Troubleshooting

If `xcrun simctl io booted` doesn't work, try:

1. **Check simulator is running:**
   ```bash
   xcrun simctl list devices | grep Booted
   ```

2. **Get the device ID and use it directly:**
   ```bash
   xcrun simctl io [DEVICE-ID] screenshot filename.png
   ```

3. **Or just use Simulator's built-in screenshot:**
   - Focus on Simulator
   - Press ⌘+S
   - Save to Desktop
   - Move to project folder later