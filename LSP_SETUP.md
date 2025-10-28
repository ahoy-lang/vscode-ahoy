# Ahoy Language Server Setup for VS Code

This guide explains how to use the Ahoy Language Server (LSP) with the VS Code extension.

## Prerequisites

The `ahoy-lsp` binary must be installed and available in your PATH. You can verify this by running:

```bash
which ahoy-lsp
```

If it's not installed, build and install it from the `ahoy/lsp` directory:

```bash
cd ../ahoy/lsp
./build.sh
./install.sh
```

This will install `ahoy-lsp` to `/usr/local/bin/ahoy-lsp`.

## Features

The Ahoy Language Server provides:

- **Diagnostics**: Real-time syntax error checking and linting
- **Go to Definition**: Jump to symbol definitions (Ctrl+Click or F12)
- **Hover Information**: View type and documentation on hover
- **Autocompletion**: Context-aware code completion (Ctrl+Space)
- **Document Symbols**: Outline view of functions and variables (Ctrl+Shift+O)
- **Code Actions**: Quick fixes and refactoring suggestions
- **Syntax Highlighting**: Full TextMate grammar support

## Installation

### Option 1: Install from VSIX (Recommended)

1. Make sure `ahoy-lsp` is in your PATH (see Prerequisites above)

2. Install the extension from the VSIX file:
   ```bash
   code --install-extension ahoy-lang-0.1.0.vsix
   ```

3. Restart VS Code

### Option 2: Development Mode

If you're actively developing the extension:

1. Open the `vscode-ahoy` folder in VS Code
2. Press F5 to launch the Extension Development Host
3. In the new VS Code window, open a `.ahoy` file

## Testing the LSP

### 1. Create a Test File

Create a file named `test.ahoy` with some intentional errors:

```ahoy
-- Test file for LSP features
function greet(name)
    print("Hello, " .. name
    -- Missing closing parenthesis above
end

function calculate(x, y
    -- Missing closing parenthesis
    return x + y
end

-- Undefined variable
result = undefined_variable + 5

greet("World")
```

### 2. Check Diagnostics

Open the file in VS Code. You should see:
- Red squiggly underlines on syntax errors
- Hover over errors to see diagnostic messages
- View all problems in the Problems panel (Ctrl+Shift+M)

### 3. Test Go to Definition

1. Create a file with a function definition:
   ```ahoy
   function add(a, b)
       return a + b
   end
   
   local result = add(5, 10)
   ```

2. Ctrl+Click (or F12) on `add` in the last line
3. The cursor should jump to the function definition

### 4. Test Hover

Hover over any keyword, function name, or variable to see:
- Type information
- Documentation (if available)
- Definition preview

### 5. Test Autocompletion

1. Start typing a keyword like `fun` and press Ctrl+Space
2. You should see completions for `function`, `for`, etc.
3. Select a completion to insert it

### 6. Test Document Symbols

1. Open a file with multiple functions
2. Press Ctrl+Shift+O (or Cmd+Shift+O on macOS)
3. You should see an outline of all functions and variables
4. Type to filter and jump to a symbol

### 7. Test Code Actions

Place your cursor on a line with an error and press Ctrl+. (or Cmd+. on macOS) to see available quick fixes.

## Troubleshooting

### LSP Not Starting

If the language server doesn't start:

1. **Check the Output panel**: View → Output, then select "Ahoy Language Server" from the dropdown
   - Look for error messages or startup logs

2. **Verify ahoy-lsp is in PATH**:
   ```bash
   which ahoy-lsp
   # Should output: /usr/local/bin/ahoy-lsp
   ```

3. **Test the binary manually**:
   ```bash
   ahoy-lsp
   # Should wait for input (press Ctrl+C to exit)
   # If it errors immediately, the binary may be corrupted
   ```

4. **Check VS Code can find the binary**:
   - Open VS Code terminal (Ctrl+`)
   - Run `which ahoy-lsp`
   - If not found, VS Code's PATH might be different from your shell

### Extension Not Activating

1. Check the extension is installed:
   - Extensions panel (Ctrl+Shift+X)
   - Search for "Ahoy Language Support"
   - Should show as installed

2. Check file association:
   - Open a `.ahoy` file
   - Bottom-right corner should show "Ahoy" as the language
   - If not, click it and select "Ahoy"

3. View extension logs:
   - Help → Toggle Developer Tools
   - Go to Console tab
   - Look for "Ahoy" related messages

### Slow or Unresponsive LSP

If the LSP is slow or hangs:

1. Check the output panel for error messages
2. Restart the language server:
   - Command Palette (Ctrl+Shift+P)
   - Type "Restart Extension Host"
3. For very large files, the parser might take time - this is expected

### Features Not Working

If specific features (like go-to-definition) don't work:

1. **Parser limitations**: The current parser tracks line numbers but column positions may be approximate for some AST nodes
2. **Scope issues**: Cross-file symbol resolution is not yet implemented
3. **Check diagnostics**: If there are parse errors, some features may be disabled

## Configuration

Currently, the extension uses default settings. Future versions will support configuration options like:

- Custom path to `ahoy-lsp` binary
- LSP logging level
- Linting strictness
- Formatting options

## Development

### Rebuilding the Extension

After making changes to `src/extension.ts`:

```bash
npm run compile
npm run package
code --install-extension ahoy-lang-0.1.0.vsix --force
```

Restart VS Code to load the new version.

### Updating the LSP Server

After making changes to the Go LSP server:

```bash
cd ../ahoy/lsp
go build -o ahoy-lsp .
sudo cp ahoy-lsp /usr/local/bin/
```

Restart the VS Code extension host to pick up the new binary.

### Debugging the Extension

1. Open `vscode-ahoy` in VS Code
2. Set breakpoints in `src/extension.ts`
3. Press F5 to launch Extension Development Host
4. Breakpoints will hit in the original VS Code window

### Debugging the LSP Server

To see LSP server logs:

1. Modify `src/extension.ts` to add logging options:
   ```typescript
   const serverOptions: ServerOptions = {
       command: serverExecutable,
       args: ["--log=/tmp/ahoy-lsp.log"], // Add if server supports it
       options: {
           env: { ...process.env, AHOY_LSP_DEBUG: "1" }
       }
   };
   ```

2. Or wrap the server in a logging script:
   ```bash
   #!/bin/bash
   echo "Starting ahoy-lsp at $(date)" >> /tmp/ahoy-lsp-wrapper.log
   /usr/local/bin/ahoy-lsp 2>> /tmp/ahoy-lsp-wrapper.log
   ```

## Known Limitations

1. **Column positions**: Some AST nodes only track line numbers, so certain features use estimated or zero column positions
2. **Cross-file resolution**: Imports and module references are not yet supported
3. **Semantic tokens**: Currently disabled due to protocol version mismatches
4. **Performance**: Large files (>1000 lines) may see slower response times

## Roadmap

Future improvements planned:

- [ ] Add column tracking to parser for precise locations
- [ ] Implement workspace-wide symbol search
- [ ] Add find-all-references feature
- [ ] Implement rename refactoring
- [ ] Add semantic token highlighting
- [ ] Support for imports and modules
- [ ] Configurable linting rules
- [ ] Code formatting
- [ ] Snippet completions
- [ ] Signature help for function calls

## Support

For issues or questions:
- Check the GitHub issues
- Review the main LSP implementation in `../ahoy/lsp/`
- See the parser implementation in `../ahoy/parser.go`

## License

MIT License - see LICENSE file