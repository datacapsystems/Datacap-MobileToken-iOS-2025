#!/bin/bash

# Resize screenshots for App Store requirements
# Target: iPhone 16 Pro Max (1290 × 2796px)

echo "📱 Screenshot Resizer for App Store"
echo "=================================="
echo ""

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick is required but not installed."
    echo "Install with: brew install imagemagick"
    echo ""
    echo "Alternative: Using sips (built-in macOS tool)..."
    USE_SIPS=true
else
    USE_SIPS=false
fi

# Create output directory in project folder
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_DIR="$SCRIPT_DIR/AppStoreAssets/Screenshots/Resized_AppStore"
mkdir -p "$OUTPUT_DIR"

# Function to resize with sips (macOS built-in)
resize_with_sips() {
    local input="$1"
    local output="$2"
    local width="$3"
    local height="$4"
    
    # First resample to exact dimensions
    sips -z "$height" "$width" "$input" --out "$output" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ Resized: $(basename "$output")"
    else
        echo "❌ Error resizing: $(basename "$input")"
    fi
}

# Function to resize with ImageMagick
resize_with_imagemagick() {
    local input="$1"
    local output="$2"
    local width="$3"
    local height="$4"
    
    convert "$input" -resize "${width}x${height}!" "$output"
    
    if [ $? -eq 0 ]; then
        echo "✅ Resized: $(basename "$output")"
    else
        echo "❌ Error resizing: $(basename "$input")"
    fi
}

# Target dimensions for iPhone 6.7" display
TARGET_WIDTH=1290
TARGET_HEIGHT=2796

echo "Target dimensions: ${TARGET_WIDTH} × ${TARGET_HEIGHT}px"
echo ""

# Screenshots to process
screenshots=(
    "Home.png:1_Home_67.png"
    "Token_Generation.png:2_Token_67.png"
    "Transaction_Genration.png:3_Transaction_67.png"
    "API_Config.png:4_Settings_67.png"
    "Help.png:5_Help_67.png"
)

# Process each screenshot
for item in "${screenshots[@]}"; do
    IFS=':' read -r input_file output_file <<< "$item"
    input_path="$HOME/Desktop/$input_file"
    output_path="$OUTPUT_DIR/$output_file"
    
    if [ -f "$input_path" ]; then
        echo "Processing: $input_file"
        
        if [ "$USE_SIPS" = true ]; then
            resize_with_sips "$input_path" "$output_path" "$TARGET_WIDTH" "$TARGET_HEIGHT"
        else
            resize_with_imagemagick "$input_path" "$output_path" "$TARGET_WIDTH" "$TARGET_HEIGHT"
        fi
    else
        echo "⚠️  Not found: $input_file"
    fi
done

echo ""
echo "🎉 Resizing complete!"
echo "📁 Resized screenshots saved to: $OUTPUT_DIR"
echo ""
echo "Upload these to App Store Connect in order:"
echo "1. 1_Home_67.png"
echo "2. 2_Token_67.png"
echo "3. 3_Transaction_67.png"
echo "4. 4_Settings_67.png"
echo "5. 5_Help_67.png"
echo ""

# Open the output directory
open "$OUTPUT_DIR"