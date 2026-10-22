# Ahoy VS Code LSP - Quick Start Guide

## 🚀 Installation (2 minutes)

### Step 1: Install the LSP Server
```bash
cd ahoy/lsp
./build.sh
./install.sh
```

### Step 2: Install the VS Code Extension
```bash
cd vscode-ahoy
code --install-extension ahoy-lang-0.1.0.vsix
```

### Step 3: Restart VS Code
Close and reopen VS Code.

## ✅ Verify Installation

Open VS Code and run:
```
View → Output → Select "Ahoy Language Server"
```

You should see: "Ahoy Language Server started successfully"

## 🎯 Quick Test

### Create a test file `test.ahoy`:

```ahoy
function add(a, b)
    return a + b
end

local result = add(5, 10)
print(result)
```

### Try these features:

| Feature | Action | Result |
|---------|--------|--------|
| **Diagnostics** | Add syntax error (remove `end`) | Red squiggles appear |
| **Go to Def** | Ctrl+Click on `add` (line 5) | Jump to function definition |
| **Hover** | Hover over `function` | See documentation |
| **Completion** | Type `fun` + Ctrl+Space | See `function` suggestion |
| **Symbols** | Press Ctrl+Shift+O | See outline of functions |
| **Problems** | Press Ctrl+Shift+M | See all errors/warnings |

## 🐛 Troubleshooting

### LSP Not Starting?

1. **Check binary exists:**
   ```bash
   which ahoy-lsp
   readlink -f "$(which ahoy-lsp)"
   ahoy-lsp --version
   ```

2. **Check VS Code output:**
   ```
   View → Output → "Ahoy Language Server"
   ```

3. **Restart extension host:**
   ```
   Ctrl+Shift+P → "Restart Extension Host"
   ```

### Extension Not Found?

```bash
# Reinstall with force flag
code --install-extension ahoy-lang-0.1.0.vsix --force
```

### Still Not Working?

Run the automated test:
```bash
cd vscode-ahoy
./test_lsp.sh
```

## 📋 Keyboard Shortcuts

| Feature | Windows/Linux | macOS |
|---------|--------------|-------|
| Go to Definition | F12 or Ctrl+Click | F12 or Cmd+Click |
| Hover Info | Hover mouse | Hover mouse |
| Completion | Ctrl+Space | Cmd+Space |
| Document Symbols | Ctrl+Shift+O | Cmd+Shift+O |
| Problems Panel | Ctrl+Shift+M | Cmd+Shift+M |
| Code Actions | Ctrl+. | Cmd+. |
| Command Palette | Ctrl+Shift+P | Cmd+Shift+P |

## 🎨 Features Summary

✅ **Real-time Diagnostics** - Syntax errors as you type  
✅ **Go to Definition** - Jump to function/variable definitions  
✅ **Hover Information** - See types and docs on hover  
✅ **Autocompletion** - Smart code suggestions  
✅ **Document Symbols** - Navigate file structure  
✅ **Code Actions** - Quick fixes for common errors  
✅ **Syntax Highlighting** - Full TextMate grammar  

## 📚 More Info

- **Detailed Setup:** See [LSP_SETUP.md](./LSP_SETUP.md)
- **Development:** See [DEVELOPMENT.md](./DEVELOPMENT.md)
- **Full Docs:** See [README.md](./README.md)

## 🎉 You're Ready!

Open any `.ahoy` file and start coding with full language support!

---

**Need Help?** Check the [LSP_SETUP.md](./LSP_SETUP.md) troubleshooting section.