#!/bin/bash
set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   Installing Ahoy Language Support for VS Code                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Install dependencies
echo "📦 Step 1/4: Installing dependencies..."
npm install --silent

# Step 2: Compile TypeScript
echo "🔨 Step 2/4: Compiling TypeScript..."
npm run compile

# Step 3: Package extension
echo "📦 Step 3/4: Packaging extension..."
echo "y" | npm run package

# Step 4: Install in VS Code
echo "🚀 Step 4/4: Installing in VS Code..."
code --install-extension ahoy-lang-0.1.0.vsix

echo ""
echo "✅ Installation complete!"
echo ""
echo "To test:"
echo "  1. Open VS Code"
echo "  2. Open a .ahoy file"
echo "  3. Syntax highlighting should work!"
echo ""
echo "Test files available in: ../ahoy/test/input/"
