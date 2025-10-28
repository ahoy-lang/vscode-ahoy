# Ahoy Language Support for VS Code

Complete language support for the Ahoy programming language, including syntax highlighting and Language Server Protocol (LSP) integration.

## Features

### ✅ Syntax Highlighting
Full syntax highlighting for all Ahoy language features:
- Keywords: `if`, `then`, `else`, `anif`, `loop`, `do`, `return`, `function`, `local`, `end`, etc.
- Functions and variables
- Operators: `+`, `-`, `*`, `/`, `==`, `>`, `<`, etc.
- Word operators: `plus`, `minus`, `times`, `div`, `is`, `greater_than`, `and`, `or`, etc.
- Comments: `--` and `? comment style`
- Strings and numbers
- Tables and arrays

### ✅ Language Server (LSP)
Intelligent code assistance powered by the Ahoy Language Server:
- **Real-time Diagnostics**: Syntax error checking and linting as you type
- **Go to Definition**: Jump to function and variable definitions (F12 or Ctrl+Click)
- **Hover Information**: View type information and documentation on hover
- **Autocompletion**: Context-aware code completion (Ctrl+Space)
- **Document Symbols**: Navigate file structure with outline view (Ctrl+Shift+O)
- **Code Actions**: Quick fixes and refactoring suggestions (Ctrl+.)

### 🔧 Language Configuration
- Auto-closing brackets: `{}`, `[]`, `()`, `""`
- Comment toggling with `--`
- Smart bracket matching and indentation

## Installation

### Prerequisites

The Language Server requires the `ahoy-lsp` binary to be installed. See [LSP_SETUP.md](./LSP_SETUP.md) for detailed installation instructions.

Quick install:
```bash
cd ../ahoy/lsp
./build.sh
./install.sh
```

This installs `ahoy-lsp` to `/usr/local/bin/`.

### Installing the Extension

#### Option 1: From VSIX (Recommended)

```bash
code --install-extension ahoy-lang-0.1.0.vsix
```

#### Option 2: From Source

1. Clone and build:
   ```bash
   cd vscode-ahoy
   npm install
   npm run compile
   npm run package
   ```

2. Install:
   ```bash
   code --install-extension ahoy-lang-0.1.0.vsix
   ```

3. Restart VS Code

## Quick Start

1. Open any `.ahoy` file
2. Syntax highlighting activates automatically
3. LSP features activate if `ahoy-lsp` is installed
4. Check status: View → Output → "Ahoy Language Server"

## Testing the LSP

Run the test script to validate your setup:

```bash
./test_lsp.sh
```

This will:
- Verify `ahoy-lsp` is installed
- Build and install the extension
- Create test files with various features
- Open VS Code with the test workspace

### Manual Testing

Create a test file `test.ahoy`:

```ahoy
-- Test LSP features

function add(a, b)
    return a + b
end

function greet(name)
    print("Hello, " .. name)
end

local result = add(5, 10)
greet("World")
```

Try these features:
- **Diagnostics**: Add a syntax error and see red squiggles
- **Go to Definition**: Ctrl+Click on `add` in the last lines
- **Hover**: Hover over `function`, `add`, or `result`
- **Completion**: Type `fun` and press Ctrl+Space
- **Symbols**: Press Ctrl+Shift+O to see outline
- **Problems**: Press Ctrl+Shift+M to see all diagnostics

## Example Ahoy Code

### Functions
```ahoy
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
```

### Variables and Tables
```ahoy
local count = 0
local message = "Hello, Ahoy!"
local numbers = {1, 2, 3, 4, 5}

local person = {
    name = "Alice",
    age = 30,
    city = "Wonderland"
}
```

### Control Flow
```ahoy
if score > 90 then do
    print("Excellent!")
elseif score > 80 then do
    print("Great!")
else
    print("Keep trying!")
end
```

### Loops
```ahoy
-- For loop
for i = 1, 10, 1 do
    print("Iteration: " .. i)
end

-- While loop
while count < 100 do
    count = count + 1
end
```

## Configuration

The extension currently uses default settings. Future versions will support:
- Custom path to `ahoy-lsp` binary
- LSP logging level
- Linting strictness
- Formatting preferences

## Troubleshooting

### LSP Not Starting

1. **Check Output Panel**: View → Output → "Ahoy Language Server"
2. **Verify Installation**: Run `which ahoy-lsp` in terminal
3. **Restart Extension Host**: Ctrl+Shift+P → "Restart Extension Host"
4. **Check Developer Console**: Help → Toggle Developer Tools

### Extension Not Activating

1. Verify `.ahoy` file extension is recognized
2. Check language mode in bottom-right corner (should show "Ahoy")
3. Reinstall extension: `code --install-extension ahoy-lang-0.1.0.vsix --force`

### Features Not Working

- **Go to Definition**: Requires valid syntax and symbol table
- **Hover**: Works on keywords, functions, and variables
- **Completion**: Available for keywords and operators
- **Cross-file**: Not yet supported (single-file analysis only)

See [LSP_SETUP.md](./LSP_SETUP.md) for detailed troubleshooting.

## Development

### Building from Source

```bash
# Install dependencies
npm install

# Compile TypeScript
npm run compile

# Watch mode for development
npm run watch

# Package extension
npm run package
```

### Testing in Development Mode

1. Open `vscode-ahoy` folder in VS Code
2. Press F5 to launch Extension Development Host
3. In the new window, open a `.ahoy` file
4. Test LSP features and check console for logs

### Updating the LSP Server

After changes to `../ahoy/lsp`:

```bash
cd ../ahoy/lsp
go build -o ahoy-lsp .
sudo cp ahoy-lsp /usr/local/bin/
```

Restart VS Code extension host to pick up the new binary.

## Known Limitations

- Column positions may be approximate for some AST nodes
- Cross-file symbol resolution not yet implemented
- Semantic tokens currently disabled
- Large files (>1000 lines) may have slower response times

## Roadmap

### Current (v0.1.0)
- [x] Syntax highlighting
- [x] Language configuration
- [x] LSP integration
- [x] Diagnostics
- [x] Go to definition
- [x] Hover information
- [x] Code completion
- [x] Document symbols
- [x] Code actions

### Planned (v0.2.0)
- [ ] Precise column tracking in parser
- [ ] Find all references
- [ ] Rename refactoring
- [ ] Semantic token highlighting
- [ ] Workspace symbols
- [ ] Cross-file analysis

### Future
- [ ] Code formatting
- [ ] Snippet library
- [ ] Signature help
- [ ] Debugging support
- [ ] REPL integration
- [ ] Configurable linting rules

## Documentation

- [LSP Setup Guide](./LSP_SETUP.md) - Detailed installation and configuration
- [Development Guide](./DEVELOPMENT.md) - Contributing and development setup
- [Testing Guide](./test_lsp.sh) - Automated testing script

## Contributing

Contributions are welcome! Please:
1. Check existing issues or create a new one
2. Fork the repository
3. Make your changes with tests
4. Submit a pull request

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/ahoy-lang/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/ahoy-lang/discussions)
- **Documentation**: [Ahoy Language Docs](https://github.com/yourusername/ahoy-lang/docs)

## License

MIT License - See [LICENSE](./LICENSE) file for details

## Acknowledgments

- Built with [vscode-languageclient](https://www.npmjs.com/package/vscode-languageclient)
- LSP implementation using [go.lsp.dev](https://pkg.go.dev/go.lsp.dev)
- Inspired by the Language Server Protocol specification

## Release Notes

### 0.1.0 - Initial LSP Release

**New Features:**
- Complete LSP integration with ahoy-lsp server
- Real-time syntax error diagnostics
- Go to definition for functions and variables
- Hover information with type details
- Context-aware autocompletion
- Document symbol outline
- Code actions and quick fixes
- Enhanced syntax highlighting

**Improvements:**
- Updated language configuration
- Better bracket matching
- Improved comment handling

**Known Issues:**
- Column positions may be approximate
- Cross-file features not yet available
- Semantic tokens temporarily disabled

---

Happy coding with Ahoy! 🚀⚓