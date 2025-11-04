#!/bin/bash

echo "=== Verifying Ahoy VSCode Extension ==="
echo ""

# Check extension is installed
echo "1. Checking extension installation..."
if code --list-extensions | grep -q "ahoy-lang.ahoy-lang"; then
    echo "✓ Extension is installed"
else
    echo "✗ Extension is NOT installed"
    exit 1
fi

# Check extension directory
EXT_DIR="$HOME/.vscode/extensions/ahoy-lang.ahoy-lang-0.1.0"
echo ""
echo "2. Checking extension directory: $EXT_DIR"
if [ -d "$EXT_DIR" ]; then
    echo "✓ Extension directory exists"
else
    echo "✗ Extension directory NOT found"
    exit 1
fi

# Check required files
echo ""
echo "3. Checking required files..."
FILES=(
    "$EXT_DIR/out/extension.js"
    "$EXT_DIR/package.json"
    "$EXT_DIR/syntaxes/ahoy.tmLanguage.json"
    "$EXT_DIR/node_modules/vscode-languageclient/node.js"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $(basename $file)"
    else
        echo "✗ Missing: $(basename $file)"
        exit 1
    fi
done

# Check ahoy-lsp is available
echo ""
echo "4. Checking ahoy-lsp..."
if which ahoy-lsp > /dev/null 2>&1; then
    echo "✓ ahoy-lsp found at: $(which ahoy-lsp)"
else
    echo "✗ ahoy-lsp NOT found in PATH"
    exit 1
fi

echo ""
echo "=== All checks passed! ==="
echo ""
echo "To test the extension:"
echo "1. Open VSCode: code /tmp/test_lsp_check.ahoy"
echo "2. Check that syntax highlighting works"
echo "3. Look for LSP diagnostics (errors/warnings)"
echo "4. Test autocompletion by typing"
echo ""
echo "If LSP doesn't work, check VSCode Output panel:"
echo "- View -> Output -> Select 'Ahoy Language Server'"
