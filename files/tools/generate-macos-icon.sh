#!/bin/bash

# Script to generate optimized macOS .icns file from a PNG image
# Usage: ./generate-macos-icon.sh <input.png> [output.icns]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}❌ Error: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️ $1${NC}"
}

# ============================================
# Step 1: Validate input parameters first
# ============================================

# Check if input file is provided
if [ -z "$1" ]; then
    print_error "No input file specified"
    echo "Usage: $0 <input.png> [output.icns]"
    echo ""
    echo "Example:"
    echo "  $0 my_icon.png"
    echo "  $0 my_icon.png custom_name.icns"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    print_error "Input file not found: $INPUT_FILE"
    exit 1
fi

# Check if input is a PNG file
if [[ ! "$INPUT_FILE" =~ \.png$ ]]; then
    print_error "Input file must be a PNG image"
    exit 1
fi

# Set output file name
if [ -z "$2" ]; then
    # Use input filename with .icns extension
    OUTPUT_FILE="${INPUT_FILE%.png}.icns"
else
    OUTPUT_FILE="$2"
fi

print_success "Input validated: $INPUT_FILE"

# ============================================
# Step 2: Check dependencies
# ============================================

print_info "Checking dependencies..."

if ! command -v sips &> /dev/null; then
    print_error "sips is required (should be available on macOS)"
    exit 1
fi

if ! command -v pngquant &> /dev/null; then
    print_error "pngquant is required but not installed"
    echo "Install it with: brew install pngquant"
    exit 1
fi

if ! command -v iconutil &> /dev/null; then
    print_error "iconutil is required (should be available on macOS)"
    exit 1
fi

print_success "All dependencies found"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
ICONSET_DIR="${TEMP_DIR}/AppIcon.iconset"
mkdir -p "$ICONSET_DIR"

# Cleanup function
cleanup() {
    print_info "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

print_info "Processing icon: $INPUT_FILE"

# Step 1: Resize PNG with sips (macOS built-in tool)
print_info "Resizing PNG to 512x512..."
RESIZED_PNG="${TEMP_DIR}/resized_512.png"

sips -z 512 512 "$INPUT_FILE" --out "$RESIZED_PNG" &> /dev/null

if [ $? -ne 0 ]; then
    print_error "Failed to resize PNG with sips"
    exit 1
fi

print_success "PNG resized to 512x512"

# Step 2: Compress with pngquant
print_info "Compressing with pngquant..."
FINAL_PNG="${ICONSET_DIR}/icon_512x512.png"

pngquant --quality=80-95 --force "$RESIZED_PNG" --output "$FINAL_PNG" 2>/dev/null

if [ $? -ne 0 ]; then
    print_error "Failed to compress PNG with pngquant"
    exit 1
fi

print_success "PNG compressed with pngquant"

# Get file sizes for comparison
ORIGINAL_SIZE=$(du -h "$INPUT_FILE" | cut -f1)
FINAL_SIZE=$(du -h "$FINAL_PNG" | cut -f1)

print_info "Original size: $ORIGINAL_SIZE → Optimized size: $FINAL_SIZE"

# Step 3: Create .icns file
print_info "Creating .icns file..."

iconutil -c icns "$ICONSET_DIR" -o "$OUTPUT_FILE"

if [ $? -ne 0 ]; then
    print_error "Failed to create .icns file"
    exit 1
fi

ICNS_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
print_success ".icns file created: $OUTPUT_FILE ($ICNS_SIZE)"

print_success "Icon generation complete!"
echo ""
echo "Output: $OUTPUT_FILE"
