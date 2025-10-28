#!/bin/bash

# Debug script for Ahoy LSP - tests the server independently of VS Code

echo "=========================================="
echo "Ahoy LSP Debug Script"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if ahoy-lsp exists
echo -e "${BLUE}1. Checking ahoy-lsp binary...${NC}"
if command -v ahoy-lsp &> /dev/null; then
    LSP_PATH=$(which ahoy-lsp)
    echo -e "${GREEN}✓${NC} Found at: $LSP_PATH"
    ls -lh "$LSP_PATH"
else
    echo -e "${RED}✗${NC} ahoy-lsp not found in PATH"
    exit 1
fi

# Test if binary is executable
echo ""
echo -e "${BLUE}2. Testing binary execution...${NC}"
if [ -x "$LSP_PATH" ]; then
    echo -e "${GREEN}✓${NC} Binary is executable"
else
    echo -e "${RED}✗${NC} Binary is not executable"
    exit 1
fi

# Create a test file
echo ""
echo -e "${BLUE}3. Creating test Ahoy file...${NC}"
TEST_FILE="/tmp/test_debug.ahoy"
cat > "$TEST_FILE" << 'EOF'
-- Test file for LSP debugging
function add(a, b)
    return a + b
end

local result = add(5, 10)
print(result)
EOF
echo -e "${GREEN}✓${NC} Created: $TEST_FILE"

# Prepare LSP request
echo ""
echo -e "${BLUE}4. Preparing LSP initialize request...${NC}"

FILE_URI="file://$TEST_FILE"
CONTENT=$(cat "$TEST_FILE")

# Create proper LSP initialize request with Content-Length header
INIT_REQUEST=$(cat << EOF
{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":$$,"clientInfo":{"name":"test","version":"1.0"},"capabilities":{"textDocument":{"hover":{"contentFormat":["markdown","plaintext"]},"completion":{"completionItem":{"snippetSupport":false}},"definition":{"linkSupport":false}}},"rootUri":"file:///tmp","workspaceFolders":null}}
EOF
)

INIT_LENGTH=${#INIT_REQUEST}

echo "Request length: $INIT_LENGTH bytes"

# Test 1: Send initialize request
echo ""
echo -e "${BLUE}5. Testing LSP initialize...${NC}"
RESPONSE=$(printf "Content-Length: %d\r\n\r\n%s" "$INIT_LENGTH" "$INIT_REQUEST" | timeout 5 ahoy-lsp 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 124 ]; then
    echo -e "${RED}✗${NC} Timeout - server didn't respond within 5 seconds"
    echo ""
    echo "This suggests the server is waiting for input but not responding."
elif [ $EXIT_CODE -ne 0 ]; then
    echo -e "${RED}✗${NC} Server exited with code: $EXIT_CODE"
    echo ""
    echo "Server output:"
    echo "$RESPONSE"
else
    echo -e "${GREEN}✓${NC} Server responded"
    echo ""
    echo "Response preview:"
    echo "$RESPONSE" | head -20
fi

# Test 2: Check if server accepts stdio
echo ""
echo -e "${BLUE}6. Testing stdio communication...${NC}"
(
    echo -e "Starting LSP server in background..."
    ahoy-lsp > /tmp/ahoy-lsp-out.log 2> /tmp/ahoy-lsp-err.log &
    LSP_PID=$!

    sleep 1

    if ps -p $LSP_PID > /dev/null; then
        echo -e "${GREEN}✓${NC} Server started with PID: $LSP_PID"
        kill $LSP_PID 2>/dev/null
        wait $LSP_PID 2>/dev/null
    else
        echo -e "${RED}✗${NC} Server failed to start"
    fi

    if [ -s /tmp/ahoy-lsp-err.log ]; then
        echo ""
        echo "Error log:"
        cat /tmp/ahoy-lsp-err.log
    fi
)

# Test 3: Check VS Code can find it
echo ""
echo -e "${BLUE}7. Checking VS Code environment...${NC}"

# Try to run code command
if command -v code &> /dev/null; then
    echo -e "${GREEN}✓${NC} VS Code CLI found"

    # Check VS Code's extensions
    INSTALLED=$(code --list-extensions 2>/dev/null | grep -i ahoy || echo "")
    if [ -n "$INSTALLED" ]; then
        echo -e "${GREEN}✓${NC} Ahoy extension installed: $INSTALLED"
    else
        echo -e "${YELLOW}!${NC} Ahoy extension not found in installed extensions"
    fi
else
    echo -e "${RED}✗${NC} VS Code CLI not available"
fi

# Test 4: Simulate what VS Code does
echo ""
echo -e "${BLUE}8. Simulating VS Code LSP startup...${NC}"

# Create a wrapper script that logs everything
WRAPPER_SCRIPT="/tmp/ahoy-lsp-wrapper.sh"
cat > "$WRAPPER_SCRIPT" << 'WRAPPER_EOF'
#!/bin/bash
echo "[$(date)] Starting ahoy-lsp" >> /tmp/ahoy-lsp-wrapper.log
echo "[$(date)] PWD: $(pwd)" >> /tmp/ahoy-lsp-wrapper.log
echo "[$(date)] PATH: $PATH" >> /tmp/ahoy-lsp-wrapper.log
echo "[$(date)] Args: $@" >> /tmp/ahoy-lsp-wrapper.log
ahoy-lsp "$@" 2>> /tmp/ahoy-lsp-wrapper.log
EXIT_CODE=$?
echo "[$(date)] Exit code: $EXIT_CODE" >> /tmp/ahoy-lsp-wrapper.log
exit $EXIT_CODE
WRAPPER_EOF
chmod +x "$WRAPPER_SCRIPT"

echo "Created wrapper at: $WRAPPER_SCRIPT"
echo "This will log to: /tmp/ahoy-lsp-wrapper.log"

# Summary and recommendations
echo ""
echo "=========================================="
echo "Debug Summary"
echo "=========================================="
echo ""
echo "Next steps to debug in VS Code:"
echo ""
echo "1. ${YELLOW}Restart VS Code completely${NC} (not just reload window)"
echo ""
echo "2. Open a .ahoy file"
echo ""
echo "3. Check these locations for errors:"
echo "   ${BLUE}View → Output → 'Ahoy Language Server'${NC}"
echo "   ${BLUE}Help → Toggle Developer Tools → Console${NC}"
echo ""
echo "4. Look for these messages in Console:"
echo "   - 'Ahoy Language extension activated!'"
echo "   - 'Looking for LSP server: ahoy-lsp'"
echo "   - 'Creating Language Client...'"
echo "   - 'Language Client created, starting...'"
echo ""
echo "5. If you see 'Failed to start', check the error message"
echo ""
echo "6. Alternative: Use the wrapper script in extension.ts:"
echo "   Change serverExecutable to: '$WRAPPER_SCRIPT'"
echo "   Then check: /tmp/ahoy-lsp-wrapper.log"
echo ""
echo "7. Verify file association:"
echo "   - Bottom-right corner of VS Code should show 'Ahoy'"
echo "   - If not, click and select 'Ahoy' language"
echo ""
echo "8. Try manual test:"
echo "   ${BLUE}Ctrl+Shift+P → 'Developer: Restart Extension Host'${NC}"
echo ""

# Cleanup instructions
echo "Debug files created:"
echo "  - $TEST_FILE"
echo "  - $WRAPPER_SCRIPT"
echo "  - /tmp/ahoy-lsp-wrapper.log (if wrapper used)"
echo "  - /tmp/ahoy-lsp-out.log"
echo "  - /tmp/ahoy-lsp-err.log"
echo ""

echo "Done! 🔍"
