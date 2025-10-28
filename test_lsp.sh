#!/bin/bash

# Test script for Ahoy LSP with VS Code extension
# This script validates the setup and creates test files

set -e

echo "=========================================="
echo "Ahoy LSP VS Code Extension Test Script"
echo "=========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if ahoy-lsp is installed
echo "1. Checking ahoy-lsp installation..."
if command -v ahoy-lsp &> /dev/null; then
    LSP_PATH=$(which ahoy-lsp)
    echo -e "${GREEN}✓${NC} ahoy-lsp found at: $LSP_PATH"
else
    echo -e "${RED}✗${NC} ahoy-lsp not found in PATH"
    echo "   Please install it first:"
    echo "   cd ../ahoy/lsp && ./build.sh && ./install.sh"
    exit 1
fi

# Check if VS Code is installed
echo ""
echo "2. Checking VS Code installation..."
if command -v code &> /dev/null; then
    echo -e "${GREEN}✓${NC} VS Code found"
else
    echo -e "${RED}✗${NC} VS Code 'code' command not found"
    echo "   Make sure VS Code is installed and 'code' is in PATH"
    exit 1
fi

# Check if extension VSIX exists
echo ""
echo "3. Checking extension package..."
if [ -f "ahoy-lang-0.1.0.vsix" ]; then
    echo -e "${GREEN}✓${NC} Extension package found: ahoy-lang-0.1.0.vsix"
else
    echo -e "${YELLOW}!${NC} Extension package not found"
    echo "   Building extension..."
    npm run package
    if [ -f "ahoy-lang-0.1.0.vsix" ]; then
        echo -e "${GREEN}✓${NC} Extension package created"
    else
        echo -e "${RED}✗${NC} Failed to create extension package"
        exit 1
    fi
fi

# Check if extension is compiled
echo ""
echo "4. Checking extension compilation..."
if [ -f "out/extension.js" ]; then
    echo -e "${GREEN}✓${NC} Extension compiled"
else
    echo -e "${YELLOW}!${NC} Extension not compiled"
    echo "   Compiling extension..."
    npm run compile
    if [ -f "out/extension.js" ]; then
        echo -e "${GREEN}✓${NC} Extension compiled successfully"
    else
        echo -e "${RED}✗${NC} Failed to compile extension"
        exit 1
    fi
fi

# Install the extension
echo ""
echo "5. Installing extension to VS Code..."
code --install-extension ahoy-lang-0.1.0.vsix --force
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Extension installed successfully"
else
    echo -e "${RED}✗${NC} Failed to install extension"
    exit 1
fi

# Create test directory
echo ""
echo "6. Creating test files..."
TEST_DIR="/tmp/ahoy-lsp-test"
mkdir -p "$TEST_DIR"

# Test file 1: Basic syntax with errors
cat > "$TEST_DIR/test_errors.ahoy" << 'EOF'
-- Test file with intentional errors for diagnostics

function greet(name)
    print("Hello, " .. name
    -- Missing closing parenthesis above (should show error)
end

function calculate(x, y
    -- Missing closing parenthesis (should show error)
    return x + y
end

-- Undefined variable usage
result = undefined_variable + 5

greet("World")
EOF

# Test file 2: Valid syntax for testing features
cat > "$TEST_DIR/test_features.ahoy" << 'EOF'
-- Test file for LSP features (go-to-def, hover, completion)

function add(a, b)
    return a + b
end

function multiply(x, y)
    return x * y
end

function calculate_area(width, height)
    local area = multiply(width, height)
    return area
end

-- Test variables
local x = 10
local y = 20
local sum = add(x, y)
local product = multiply(x, y)

-- Test conditionals
if sum > product then do
    print("Sum is greater")
end

-- Test loops
for i = 1, 10, 1 do
    print("Iteration: " .. i)
end

-- Test table
local person = {
    name = "Alice",
    age = 30,
    city = "Wonderland"
}

print(person.name)
EOF

# Test file 3: Complex code for symbol testing
cat > "$TEST_DIR/test_symbols.ahoy" << 'EOF'
-- Test file for document symbols and outline

function fibonacci(n)
    if n <= 1 then do
        return n
    end
    return fibonacci(n - 1) + fibonacci(n - 2)
end

function factorial(n)
    if n <= 1 then do
        return 1
    end
    return n * factorial(n - 1)
end

function is_prime(n)
    if n <= 1 then do
        return false
    end
    for i = 2, n - 1, 1 do
        if n % i == 0 then do
            return false
        end
    end
    return true
end

function find_primes(max)
    local primes = {}
    for i = 2, max, 1 do
        if is_prime(i) then do
            table.insert(primes, i)
        end
    end
    return primes
end

-- Global variables
local MAX_NUMBER = 100
local results = find_primes(MAX_NUMBER)

print("Found " .. #results .. " prime numbers")
EOF

echo -e "${GREEN}✓${NC} Test files created in: $TEST_DIR"
echo "   - test_errors.ahoy (syntax errors)"
echo "   - test_features.ahoy (valid code)"
echo "   - test_symbols.ahoy (symbol outline)"

# Instructions
echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Open VS Code:"
echo "   code $TEST_DIR"
echo ""
echo "2. Open any .ahoy file"
echo ""
echo "3. Test LSP features:"
echo "   ${YELLOW}Diagnostics:${NC} Open test_errors.ahoy - see red squiggles"
echo "   ${YELLOW}Go-to-Def:${NC}   Ctrl+Click on 'add' in test_features.ahoy"
echo "   ${YELLOW}Hover:${NC}       Hover over any function or keyword"
echo "   ${YELLOW}Completion:${NC}  Type 'fun' and press Ctrl+Space"
echo "   ${YELLOW}Symbols:${NC}     Press Ctrl+Shift+O in test_symbols.ahoy"
echo "   ${YELLOW}Problems:${NC}    Press Ctrl+Shift+M to see all diagnostics"
echo ""
echo "4. Check LSP output:"
echo "   View → Output → Select 'Ahoy Language Server'"
echo ""
echo "5. Verify activation:"
echo "   Help → Toggle Developer Tools → Console"
echo "   Look for 'Ahoy Language extension is now active!'"
echo ""
echo "Troubleshooting:"
echo "   - If LSP doesn't start, check: View → Output → Ahoy Language Server"
echo "   - Restart extension host: Ctrl+Shift+P → 'Restart Extension Host'"
echo "   - View logs: ~/.config/Code/logs/*/exthost/output_logging_*/*/Ahoy*"
echo ""

# Offer to open VS Code
echo ""
read -p "Open VS Code with test files now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Opening VS Code..."
    code "$TEST_DIR"
    echo ""
    echo "VS Code opened. Check the test files!"
fi

echo ""
echo "Done! 🚀"
