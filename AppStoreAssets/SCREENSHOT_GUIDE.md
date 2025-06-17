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
