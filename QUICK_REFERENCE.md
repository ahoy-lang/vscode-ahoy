# VS Code Extension Quick Reference

## Installation (3 Steps)

```bash
# 1. Install dependencies & compile
cd vscode-ahoy && npm install && npm run compile

# 2. Package extension
npm run package

# 3. Install in VS Code
code --install-extension ahoy-lang-0.1.0.vsix
```

## Files Overview

| File | Purpose |
|------|---------|
| `package.json` | Extension manifest & metadata |
| `syntaxes/ahoy.tmLanguage.json` | Syntax highlighting rules (TextMate grammar) |
| `language-configuration.json` | Brackets, comments, auto-closing |
| `src/extension.ts` | Extension entry point (LSP placeholder) |
| `out/extension.js` | Compiled code (stub included) |

## Syntax Scopes

| Element | Example | Scope |
|---------|---------|-------|
| Comment | `? comment` | `comment.line.question.ahoy` |
| Constant | `PI :: 3.14` | `constant.other.ahoy` |
| Function | `add :: \|a:int\|` | `entity.name.function.ahoy` |
| Keyword | `if`, `loop`, `return` | `keyword.control.ahoy` |
| Type | `int`, `string`, `float` | `storage.type.primitive.ahoy` |
| Operator | `plus`, `minus`, `times` | `keyword.operator.word.ahoy` |
| String | `"Hello"` | `string.quoted.double.ahoy` |
| Number | `42`, `3.14` | `constant.numeric.*` |
| Variable | `count: 0` | `variable.other.ahoy` |

## Testing

```bash
# Method 1: Install VSIX
code --install-extension ahoy-lang-0.1.0.vsix
code test-syntax.ahoy

# Method 2: Development Mode
code vscode-ahoy/
# Press F5 to launch Extension Development Host
# Open any .ahoy file in the new window
```

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Toggle comment | `Ctrl+/` or `Cmd+/` |
| Go to matching bracket | `Ctrl+Shift+\` |
| Fold code | `Ctrl+Shift+[` |
| Unfold code | `Ctrl+Shift+]` |

## Language Features

### Supported ✅
- Syntax highlighting
- Comment toggling
- Auto-closing brackets
- Bracket matching
- File association (`.ahoy`)

### Coming Soon 🔲
- LSP integration
- Code completion
- Error diagnostics
- Go to definition
- Hover information

## Customization

Add to VS Code `settings.json`:

```json
{
  "editor.tokenColorCustomizations": {
    "[Your Theme Name]": {
      "textMateRules": [
        {
          "scope": "comment.line.question.ahoy",
          "settings": { "foreground": "#6A9955" }
        },
        {
          "scope": "keyword.operator.word.ahoy",
          "settings": { "foreground": "#569CD6", "fontStyle": "italic" }
        }
      ]
    }
  }
}
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Extension not found | Check Extensions panel, reload VS Code |
| Syntax not highlighting | Verify `.ahoy` extension, check language mode |
| Build errors | `rm -rf node_modules && npm install` |
| Package fails | Install `vsce`: `npm install -g @vscode/vsce` |

## Build Commands

```bash
npm run compile    # Compile TypeScript
npm run watch      # Auto-compile on changes
npm run package    # Create VSIX package
```

## File Locations

```
Extension: ~/.vscode/extensions/ahoy-lang.ahoy-lang-0.1.0/
Source: /home/lee/Documents/ahoy-lang/vscode-ahoy/
Test files: /home/lee/Documents/ahoy-lang/ahoy/test/input/
```

## Quick Test

```ahoy
? Quick test
PI :: 3.14
add :: |a:int, b:int| int:
    return a plus b
result: add|10, 20|
ahoy|"Result: %d", result|
```

Expected highlighting:
- `? Quick test` - muted (comment)
- `PI` - bright (constant)
- `add` - distinct (function)
- `a:int`, `b:int` - typed parameters
- `return`, `plus` - keywords/operators
- `10`, `20` - numbers
- `"Result: %d"` - string

## Support

- **Docs**: README.md, DEVELOPMENT.md, INSTALL.md
- **Examples**: test-syntax.ahoy, ../ahoy/test/input/*.ahoy
- **Issues**: Report via GitHub

## Next Steps

1. ✅ Install extension
2. ✅ Test with example files
3. 🔲 Build LSP server
4. 🔲 Enable LSP in extension.ts
5. 🔲 Add code completion
6. 🔲 Publish to marketplace
