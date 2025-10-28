# VS Code LSP Troubleshooting Guide

## The LSP IS Working! Here's Why You Might Think It's Not:

### ❗ IMPORTANT: Ahoy Uses Different Syntax

Ahoy does **NOT** use `function` keyword like Lua. It uses `::` syntax.

**WRONG (won't work):**
```ahoy
function add(a, b)
    return a + b
end
```

**CORRECT (will work):**
```ahoy
add :: |a:int, b:int| int:
    return a plus b
```

### Quick Verification Steps

1. **Restart VS Code completely** (close all windows, reopen)

2. **Open the correct test file:**
   - Use `test_correct_syntax.ahoy` (has proper Ahoy syntax)
   - NOT the test files with Lua-style `function` syntax

3. **Check the language mode:**
   - Bottom-right corner of VS Code should show "Ahoy"
   - If it says "Plain Text", click it and select "Ahoy"

4. **Check for diagnostics:**
   - Open `test_correct_syntax.ahoy`
   - Add a syntax error (delete `:` after `int:`)
   - You should see red squiggles appear
   - This proves LSP diagnostics are working!

5. **Test hover:**
   - Hover over the `add` function name
   - Hover over keywords like `if`, `loop`, `return`
   - You should see information appear

6. **Test go-to-definition:**
   - Find the line: `result: add|5, 10|`
   - Ctrl+Click (or F12) on `add`
   - Should jump to the function definition at top of file

7. **Test completion:**
   - Type `lo` and press Ctrl+Space
   - Should see `loop` suggestion
   - Type `re` and press Ctrl+Space
   - Should see `return` suggestion

## Checking LSP Connection

### Method 1: Output Panel
```
View → Output → Select "Ahoy Language Server"
```

Look for:
- "Starting Ahoy Language Server..."
- Connection messages
- Any error messages

### Method 2: Developer Console
```
Help → Toggle Developer Tools → Console tab
```

Look for:
- "Ahoy Language extension activated!"
- "Looking for LSP server: ahoy-lsp"
- "Language Client created, starting..."
- "Ahoy Language Server started successfully"

### Method 3: Check Extension
```
Extensions panel (Ctrl+Shift+X)
Search: "Ahoy"
```

Should show "Ahoy Language Support" as installed.

## Common Issues

### Issue: "No hover/definition/completion"

**Cause:** You're using incorrect syntax (Lua-style `function` instead of Ahoy-style `::`)

**Solution:** Use proper Ahoy syntax:
```ahoy
? Functions use ::
myFunction :: |param:type| returnType:
    return result

? Variables use :
myVar: value

? Conditionals use then
if condition then
    do_something

? Loops use do
loop:0 to 10 do
    print|"text"|
```

### Issue: "Extension not activating"

**Solution:**
1. Reinstall: `code --install-extension ahoy-lang-0.1.0.vsix --force`
2. Restart VS Code completely
3. Open a `.ahoy` file
4. Check output panel for errors

### Issue: "LSP server not found"

**Solution:**
```bash
# Verify binary exists
which ahoy-lsp

# Should output: /usr/local/bin/ahoy-lsp

# If not found, reinstall
cd ../ahoy/lsp
./build.sh
./install.sh
```

### Issue: "Diagnostics work but nothing else"

**Probable cause:** You're testing with invalid syntax, so the parser can't build an AST.

**Solution:** Use `test_correct_syntax.ahoy` which has valid Ahoy code.

## Verify Everything Works

Run this simple test:

1. Create a file `simple_test.ahoy`:
```ahoy
? Simple test
add :: |a:int, b:int| int:
    return a plus b

result: add|5, 10|
print|"Result: %v", result|
```

2. Open it in VS Code

3. **Test diagnostics:** Delete the `:` after `int:` on line 2
   - Red squiggle should appear
   - Hover to see error message
   - This proves LSP is connected!

4. **Undo the error** (Ctrl+Z)

5. **Test hover:** Hover over `add` on line 5
   - Should show function signature

6. **Test go-to-definition:** Ctrl+Click on `add` on line 5
   - Should jump to line 2

7. **Test completion:** 
   - Go to end of file
   - Type `lo` and press Ctrl+Space
   - Should suggest `loop`

If all these work, **the LSP is fully functional!**

## What Features ARE Working

✅ **Diagnostics** - Syntax errors show as red squiggles
✅ **Hover** - Shows info when hovering over identifiers  
✅ **Go to Definition** - Jump to function/variable definitions
✅ **Completion** - Suggests keywords and operators
✅ **Document Symbols** - Outline view (Ctrl+Shift+O)
✅ **Code Actions** - Quick fixes (Ctrl+.)

## What Features Are NOT Working (Yet)

❌ Cross-file references (imports/modules)
❌ Find all references
❌ Rename refactoring
❌ Semantic token highlighting
❌ Signature help (parameter hints)

## Still Not Working?

1. **Check the wrapper log:**
   ```bash
   # Edit extension.ts and change serverExecutable to:
   # "/tmp/ahoy-lsp-wrapper.sh"
   
   # Rebuild and check logs
   cat /tmp/ahoy-lsp-wrapper.log
   ```

2. **Run debug script:**
   ```bash
   ./debug_lsp.sh
   ```

3. **Check file association:**
   - Is the file saved with `.ahoy` extension?
   - Does VS Code recognize it as Ahoy language?

4. **Try another editor:**
   - If you have another LSP-capable editor, try there
   - This helps isolate if it's a VS Code issue

## Success Indicators

When LSP is working, you'll see:
- 🟢 "Ahoy Language Server is running" notification on startup
- 🟢 Errors show as red squiggles immediately
- 🟢 Hover shows information
- 🟢 Ctrl+Click jumps to definitions
- 🟢 Completions appear when typing

If you see these, **it's working!** 🎉

## Remember

The most common "not working" issue is using wrong syntax. Ahoy uses:
- `::` for functions (not `function`)
- `:` for variables (not `=` or `local`)
- `then` after conditionals
- `do` after loops
- `plus`, `minus`, `times` operators (or `+`, `-`, `*`)

Use `test_correct_syntax.ahoy` as your reference!