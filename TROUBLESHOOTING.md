# Troubleshooting Guide

## Common Build Issues

### 1. "Module 'DatacapMobileToken' not found"
**Solution**: 
- Ensure the xcframework is properly linked
- Clean build folder: `⌘+Shift+K`
- Check that framework is set to "Embed & Sign"

### 2. "Use of undeclared type 'ModernViewController'"
**Solution**:
- Verify bridging header path is correct
- Ensure Swift files are added to the target
- Try deleting derived data:
  ```bash
  rm -rf ~/Library/Developer/Xcode/DerivedData
  ```

### 3. "Could not launch app - Code signing error"
**Solution**:
- Go to Signing & Capabilities
- Ensure a team is selected
- For free Apple ID, you may need to delete the app from device every 7 days

### 4. "This app could not be installed at this time"
**Solution**:
- Delete the app from device/simulator
- Clean build folder
- Restart Xcode and device
- Check provisioning profile is valid

### 5. Build Succeeds but App Crashes
**Solution**:
- Check the console for error messages
- Verify iOS deployment target is 13.0+
- Ensure all required frameworks are embedded

## Quick Commands

```bash
# Clean build
cmd+shift+K

# Build only
cmd+B

# Run
cmd+R

# Stop
cmd+.

# Show console
cmd+shift+Y

# Device logs
cmd+shift+2
```

## Testing Tips

1. **Always test on multiple screen sizes**
2. **Check both light and dark mode**
3. **Test with airplane mode to verify error handling**
4. **Use different test cards for comprehensive testing**

## Device-Specific Issues

### iPhone 15 Pro / Pro Max
- Ensure Dynamic Island doesn't interfere with UI
- Test with different display zoom settings

### Older Devices (iPhone X/11)
- Verify glass morphism performance
- Check memory usage with Instruments

## Need More Help?

1. Check Xcode's Issue Navigator (⌘+5)
2. View device logs in Console app
3. Use breakpoints to debug specific issues
4. Check the CLAUDE.md file for development guidelines