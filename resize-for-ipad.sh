#!/bin/bash

echo "📱 Resizing Screenshots for iPad (2048 × 2732px)"
echo "=============================================="
echo ""

# Create output directory
OUTPUT_DIR="$HOME/Desktop/iPad_Screenshots"
mkdir -p "$OUTPUT_DIR"

# iPad Pro 12.9" dimensions (portrait)
TARGET_WIDTH=2048
TARGET_HEIGHT=2732

echo "Target dimensions: ${TARGET_WIDTH} × ${TARGET_HEIGHT}px"
echo ""

# Source screenshots
SOURCE_DIR="$HOME/Desktop"
SCREENSHOTS=(
    "Home.png"
    "Token_Generation.png"
    "Transaction_Genration.png"
    "API_Config.png"
    "Help.png"
)

# Process each screenshot
for screenshot in "${SCREENSHOTS[@]}"; do
    if [ -f "$SOURCE_DIR/$screenshot" ]; then
        output_name="${screenshot%.png}_iPad.png"
        echo "Processing: $screenshot"
        
        # Resize to iPad dimensions
        sips -z $TARGET_HEIGHT $TARGET_WIDTH "$SOURCE_DIR/$screenshot" --out "$OUTPUT_DIR/$output_name" >/dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "✅ Created: $output_name"
        else
            echo "❌ Failed: $screenshot"
        fi
    else
        echo "⚠️  Not found: $screenshot"
    fi
done

# Also try the resized App Store screenshots
echo ""
echo "Also converting existing iPhone screenshots..."
IPHONE_DIR="$HOME/Documents/Datacap-MobileToken-iOS-2025/AppStoreAssets/Screenshots/Resized_AppStore"

if [ -d "$IPHONE_DIR" ]; then
    for file in "$IPHONE_DIR"/*.png; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            output_name="${filename%.png}_iPad.png"
            
            echo "Converting: $filename"
            sips -z $TARGET_HEIGHT $TARGET_WIDTH "$file" --out "$OUTPUT_DIR/$output_name" >/dev/null 2>&1
            
            if [ $? -eq 0 ]; then
                echo "✅ Created: $output_name"
            fi
        fi
    done
fi

echo ""
echo "🎉 iPad screenshots ready!"
echo "📁 Location: $OUTPUT_DIR"
echo ""
echo "Upload any of these to App Store Connect for iPad 13-inch display"

# Open the folder
open "$OUTPUT_DIR"