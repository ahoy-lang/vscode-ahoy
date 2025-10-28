# Ahoy Language VS Code Extension

Provides syntax highlighting and language support for Ahoy programming language files (`.ahoy`).

## Quick Start

### Installation

```bash
cd vscode-ahoy
npm install
npm run compile
npm run package
```

Then in VS Code:
1. Press `Ctrl+Shift+P` (Cmd+Shift+P on Mac)
2. Type "Extensions: Install from VSIX"
3. Select the generated `ahoy-lang-0.1.0.vsix` file

### Testing

1. Open VS Code
2. Open any `.ahoy` file from the test directory
3. Syntax highlighting should activate automatically

## Features

### Syntax Highlighting

The extension provides comprehensive syntax highlighting for:

- **Comments**: `? This is a comment`
- **Constants**: `PI :: 3.14159`
- **Variables**: `count: 0`
- **Functions**: `add :: |a:int, b:int| int:`
- **Keywords**: `if`, `then`, `else`, `loop`, `return`
- **Operators**: `plus`, `minus`, `times`, `is`, `greater_than`
- **Types**: `int`, `float`, `string`, `bool`
- **Strings**: `"Hello, World!"`
- **Numbers**: `42`, `3.14`

### Language Configuration

- Auto-closing brackets: `{}`, `[]`, `<>`, `||`
- Comment toggling with `Ctrl+/` or `Cmd+/`
- Smart bracket matching and highlighting

## File Structure

```
vscode-ahoy/
├── package.json              # Extension manifest
├── tsconfig.json            # TypeScript configuration
├── language-configuration.json  # Language rules
├── syntaxes/
│   └── ahoy.tmLanguage.json # TextMate grammar
├── src/
│   └── extension.ts         # Extension entry point (LSP placeholder)
└── out/                     # Compiled JavaScript (generated)
```

## Development

### Prerequisites

- Node.js 16+
- npm or yarn
- VS Code 1.60+

### Setup

```bash
npm install
```

### Compile

```bash
npm run compile
```

### Watch Mode (auto-compile on changes)

```bash
npm run watch
```

### Package Extension

```bash
npm run package
```

This creates `ahoy-lang-0.1.0.vsix` that can be installed in VS Code.

### Testing Changes

1. Make changes to `syntaxes/ahoy.tmLanguage.json`
2. Run `npm run compile`
3. Press `F5` in VS Code to launch Extension Development Host
4. Open an `.ahoy` file to test highlighting

## TextMate Grammar

The syntax highlighting uses TextMate grammar defined in `syntaxes/ahoy.tmLanguage.json`.

Key scopes:
- `comment.line.question.ahoy` - Comments
- `keyword.control.ahoy` - Control flow keywords
- `entity.name.function.ahoy` - Function names
- `constant.other.ahoy` - Constants
- `storage.type.ahoy` - Type names
- `keyword.operator.word.ahoy` - Word operators (plus, minus, etc.)

## LSP Support (Coming Soon)

The extension includes a placeholder for Language Server Protocol support. To enable:

1. Build the Ahoy LSP server (not yet implemented)
2. Uncomment the LSP code in `src/extension.ts`
3. Update the `serverExecutable` path
4. Recompile and package

## Customizing Colors

Colors are determined by your VS Code theme. The extension assigns semantic scopes that themes can style.

To override colors in your `settings.json`:

```json
"editor.tokenColorCustomizations": {
  "textMateRules": [
    {
      "scope": "comment.line.question.ahoy",
      "settings": {
        "foreground": "#6A9955"
      }
    },
    {
      "scope": "keyword.control.ahoy",
      "settings": {
        "foreground": "#C586C0"
      }
    }
  ]
}
```

## Publishing to Marketplace

1. Create a Publisher account at https://marketplace.visualstudio.com/
2. Get a Personal Access Token
3. Run:
   ```bash
   vsce login <publisher-name>
   vsce publish
   ```

## Troubleshooting

### Syntax highlighting not working

- Make sure the file has `.ahoy` extension
- Try closing and reopening the file
- Check Output panel (View → Output → Ahoy Language)

### Extension not activating

- Check if the extension is enabled in Extensions panel
- Look for errors in Developer Tools (Help → Toggle Developer Tools)

## Examples

See the test files in `../ahoy/test/input/` for syntax examples:
- `simple_showcase.ahoy`
- `array_methods_test.ahoy`
- `conditionals_test.ahoy`
- `loops_test.ahoy`

## Contributing

Contributions welcome! Areas to improve:
- Better regex patterns for edge cases
- More specific scopes for better theming
- LSP server implementation
- Code snippets
- Additional language features

## Resources

- [VS Code Extension API](https://code.visualstudio.com/api)
- [TextMate Grammars](https://macromates.com/manual/en/language_grammars)
- [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)

## License

MIT
