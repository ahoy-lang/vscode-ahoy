# Ahoy Language VS Code Extension - Installation Guide

## Quick Install (One Script)

```bash
cd /home/lee/Documents/ahoy-lang/vscode-ahoy
./install.sh
```

That's it! The script will:
1. Install npm dependencies
2. Compile TypeScript
3. Package the extension
4. Install in VS Code

## Manual Installation (Step by Step)

### Prerequisites
- Node.js 16+ and npm
- VS Code 1.60+

### Steps

1. **Navigate to the extension directory**
   ```bash
   cd /home/lee/Documents/ahoy-lang/vscode-ahoy
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Compile TypeScript**
   ```bash
   npm run compile
   ```

4. **Package the extension**
   ```bash
   echo "y" | npm run package
   ```
   This creates `ahoy-lang-0.1.0.vsix`

5. **Install in VS Code**
   ```bash
   code --install-extension ahoy-lang-0.1.0.vsix
   ```

6. **Verify installation**
   ```bash
   code --list-extensions | grep ahoy
   ```
   Should show: `ahoy-lang.ahoy-lang`

## Development Mode (For Testing)

If you're actively developing the extension:

1. **Open the extension project**
   ```bash
   code /home/lee/Documents/ahoy-lang/vscode-ahoy
   ```

2. **Start watch mode**
   ```bash
   npm run watch
   ```

3. **Launch Extension Development Host**
   - Press `F5` in VS Code
   - A new VS Code window opens with the extension loaded
   - Open a `.ahoy` file in the new window

4. **Test your changes**
   - Make changes to the grammar or configuration
   - Press `Ctrl+R` (or `Cmd+R`) in the Extension Development Host to reload

## Verify Installation

After installation, verify it works:

1. Create a test file `test.ahoy`:
   ```ahoy
   ? This is a comment
   PI :: 3.14159
   
   greet :: |name:string| string:
       return "Hello, " plus name
   
   result: greet|"World"|
   ahoy|"Result: %s", result|
   ```

2. Open it in VS Code
3. You should see:
   - Comments in green/gray
   - `PI` in a distinct color (constant)
   - `greet` as a function name
   - Keywords (`return`) highlighted
   - Operators (`plus`) highlighted

## Uninstall

**Via UI:**
- Go to Extensions panel (`Ctrl+Shift+X`)
- Find "Ahoy Language Support"
- Click the gear icon → Uninstall

**Via Command Line:**
```bash
code --uninstall-extension ahoy-lang.ahoy-lang
```

## Troubleshooting

### "npm: command not found"
Install Node.js: https://nodejs.org/

### "vsce: command not found"
```bash
npm install -g @vscode/vsce
```

### Extension not showing up
- Check Extensions panel for errors
- Try reloading VS Code: `Ctrl+Shift+P` → "Developer: Reload Window"

### Syntax highlighting not working
- Verify file has `.ahoy` extension
- Check file language mode (bottom right): should show "Ahoy"
- Try closing and reopening the file

### TypeScript compilation errors
```bash
# Clean and reinstall
rm -rf node_modules package-lock.json
npm install
npm run compile
```

## Building for Distribution

To create a distributable package:

```bash
# 1. Ensure everything compiles
npm run compile

# 2. Package the extension
npm run package

# 3. (Optional) Test the VSIX
code --install-extension ahoy-lang-0.1.0.vsix

# 4. (Future) Publish to marketplace
vsce publish
```

## What Gets Highlighted

### Keywords
- Control: `if`, `then`, `else`, `anif`, `elseif`, `loop`, `do`, `return`
- Other: `ahoy`, `print`, `printf`
- Storage: `func`, `enum`, `struct`, `type`

### Operators
- Word operators: `plus`, `minus`, `times`, `div`, `mod`, `and`, `or`, `not`
- Comparisons: `is`, `greater_than`, `less_than`, `lesser_equal`
- Symbols: `::`, `:`, `+`, `-`, `*`, `/`

### Types
`int`, `float`, `string`, `bool`, `char`, `dict`, `array`, `Vector2`, `Color`

### Constants
`PI :: 3.14`, `MAX_SIZE :: 100`, `true`, `false`

### Functions
```ahoy
functionName :: |param:type| returnType:
```

### Comments
```ahoy
? Single line comment
```

## Next Steps

Once installed:
1. Try opening example files from `/home/lee/Documents/ahoy-lang/ahoy/test/input/`
2. Customize colors in VS Code settings (see DEVELOPMENT.md)
3. Report issues or suggest improvements

## Future Features

Coming soon:
- [ ] Language Server Protocol (LSP) integration
- [ ] Auto-completion
- [ ] Error diagnostics
- [ ] Go to definition
- [ ] Code formatting
- [ ] Snippets

## Support

- Issues: Create an issue in the ahoy-lang repository
- Documentation: See README.md and DEVELOPMENT.md
- Examples: Check `/home/lee/Documents/ahoy-lang/ahoy/test/input/`
