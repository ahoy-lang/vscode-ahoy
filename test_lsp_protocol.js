#!/usr/bin/env node

// Test script to verify Ahoy LSP protocol implementation
// This simulates what VS Code does when connecting to the LSP

const { spawn } = require('child_process');
const path = require('path');

// ANSI color codes
const GREEN = '\x1b[32m';
const RED = '\x1b[31m';
const YELLOW = '\x1b[33m';
const BLUE = '\x1b[34m';
const RESET = '\x1b[0m';

function log(msg, color = RESET) {
  console.log(`${color}${msg}${RESET}`);
}

function encodeMessage(message) {
  const content = JSON.stringify(message);
  return `Content-Length: ${content.length}\r\n\r\n${content}`;
}

function parseMessages(data) {
  const messages = [];
  let buffer = data;

  while (buffer.length > 0) {
    const headerEnd = buffer.indexOf('\r\n\r\n');
    if (headerEnd === -1) break;

    const header = buffer.substring(0, headerEnd);
    const match = header.match(/Content-Length: (\d+)/);
    if (!match) break;

    const contentLength = parseInt(match[1]);
    const messageStart = headerEnd + 4;
    const messageEnd = messageStart + contentLength;

    if (buffer.length < messageEnd) break;

    const content = buffer.substring(messageStart, messageEnd);
    try {
      messages.push(JSON.parse(content));
    } catch (e) {
      log(`Failed to parse message: ${content}`, RED);
    }

    buffer = buffer.substring(messageEnd);
  }

  return messages;
}

async function testLSP() {
  log('\n==========================================', BLUE);
  log('Ahoy LSP Protocol Test', BLUE);
  log('==========================================\n', BLUE);

  return new Promise((resolve) => {
    const lsp = spawn('ahoy-lsp', [], {
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let outputBuffer = '';
    let stderrOutput = '';
    let requestId = 0;
    let testsPassed = 0;
    let testsFailed = 0;

    lsp.stdout.on('data', (data) => {
      outputBuffer += data.toString();
      const messages = parseMessages(outputBuffer);

      messages.forEach((msg) => {
        if (msg.id !== undefined) {
          log(`\n✓ Received response for request ${msg.id}`, GREEN);

          if (msg.id === 1) {
            log('  Initialize response received', GREEN);
            if (msg.result && msg.result.capabilities) {
              log('  Server capabilities:', BLUE);
              log(`    - textDocumentSync: ${msg.result.capabilities.textDocumentSync ? 'yes' : 'no'}`, BLUE);
              log(`    - completionProvider: ${msg.result.capabilities.completionProvider ? 'yes' : 'no'}`, BLUE);
              log(`    - hoverProvider: ${msg.result.capabilities.hoverProvider ? 'yes' : 'no'}`, BLUE);
              log(`    - definitionProvider: ${msg.result.capabilities.definitionProvider ? 'yes' : 'no'}`, BLUE);
              log(`    - documentSymbolProvider: ${msg.result.capabilities.documentSymbolProvider ? 'yes' : 'no'}`, BLUE);
              log(`    - codeActionProvider: ${msg.result.capabilities.codeActionProvider ? 'yes' : 'no'}`, BLUE);
              testsPassed++;

              // Send initialized notification
              log('\n→ Sending initialized notification', YELLOW);
              const initialized = encodeMessage({
                jsonrpc: '2.0',
                method: 'initialized',
                params: {}
              });
              lsp.stdin.write(initialized);

              // Open a document
              setTimeout(() => {
                log('\n→ Sending textDocument/didOpen', YELLOW);
                const didOpen = encodeMessage({
                  jsonrpc: '2.0',
                  method: 'textDocument/didOpen',
                  params: {
                    textDocument: {
                      uri: 'file:///tmp/test.ahoy',
                      languageId: 'ahoy',
                      version: 1,
                      text: 'function add(a, b)\n    return a + b\nend\n\nlocal result = add(5, 10)'
                    }
                  }
                });
                lsp.stdin.write(didOpen);

                // Request hover
                setTimeout(() => {
                  log('\n→ Sending textDocument/hover request', YELLOW);
                  requestId++;
                  const hover = encodeMessage({
                    jsonrpc: '2.0',
                    id: requestId,
                    method: 'textDocument/hover',
                    params: {
                      textDocument: { uri: 'file:///tmp/test.ahoy' },
                      position: { line: 0, character: 9 }
                    }
                  });
                  lsp.stdin.write(hover);

                  // Request completion
                  setTimeout(() => {
                    log('\n→ Sending textDocument/completion request', YELLOW);
                    requestId++;
                    const completion = encodeMessage({
                      jsonrpc: '2.0',
                      id: requestId,
                      method: 'textDocument/completion',
                      params: {
                        textDocument: { uri: 'file:///tmp/test.ahoy' },
                        position: { line: 4, character: 10 }
                      }
                    });
                    lsp.stdin.write(completion);

                    // Request definition
                    setTimeout(() => {
                      log('\n→ Sending textDocument/definition request', YELLOW);
                      requestId++;
                      const definition = encodeMessage({
                        jsonrpc: '2.0',
                        id: requestId,
                        method: 'textDocument/definition',
                        params: {
                          textDocument: { uri: 'file:///tmp/test.ahoy' },
                          position: { line: 4, character: 15 }
                        }
                      });
                      lsp.stdin.write(definition);

                      // Shutdown after tests
                      setTimeout(() => {
                        log('\n→ Sending shutdown request', YELLOW);
                        requestId++;
                        const shutdown = encodeMessage({
                          jsonrpc: '2.0',
                          id: requestId,
                          method: 'shutdown',
                          params: null
                        });
                        lsp.stdin.write(shutdown);

                        setTimeout(() => {
                          log('\n→ Sending exit notification', YELLOW);
                          const exit = encodeMessage({
                            jsonrpc: '2.0',
                            method: 'exit',
                            params: null
                          });
                          lsp.stdin.write(exit);
                        }, 100);
                      }, 500);
                    }, 500);
                  }, 500);
                }, 500);
              }, 100);
            } else {
              log('  ERROR: No capabilities in response', RED);
              testsFailed++;
            }
          } else if (msg.id === 2) {
            log('  Hover response:', BLUE);
            if (msg.result) {
              log(`    ${JSON.stringify(msg.result)}`, BLUE);
              testsPassed++;
            } else {
              log('    (no hover info)', YELLOW);
            }
          } else if (msg.id === 3) {
            log('  Completion response:', BLUE);
            if (msg.result && msg.result.items) {
              log(`    ${msg.result.items.length} items`, BLUE);
              msg.result.items.slice(0, 3).forEach(item => {
                log(`      - ${item.label}`, BLUE);
              });
              testsPassed++;
            } else {
              log('    (no completions)', YELLOW);
            }
          } else if (msg.id === 4) {
            log('  Definition response:', BLUE);
            if (msg.result) {
              log(`    ${JSON.stringify(msg.result)}`, BLUE);
              testsPassed++;
            } else {
              log('    (no definition)', YELLOW);
            }
          } else if (msg.id === 5) {
            log('  Shutdown acknowledged', GREEN);
            testsPassed++;
          }
        } else if (msg.method) {
          // Notification from server
          log(`\n← Received notification: ${msg.method}`, BLUE);
          if (msg.method === 'textDocument/publishDiagnostics') {
            if (msg.params && msg.params.diagnostics) {
              log(`  ${msg.params.diagnostics.length} diagnostics`, BLUE);
              msg.params.diagnostics.forEach(diag => {
                log(`    [Line ${diag.range.start.line}] ${diag.message}`, BLUE);
              });
              if (msg.params.diagnostics.length === 0) {
                testsPassed++;
              }
            }
          }
        }
      });

      // Clear processed messages from buffer
      const lastMessageEnd = outputBuffer.lastIndexOf('}\r\n');
      if (lastMessageEnd !== -1) {
        outputBuffer = '';
      }
    });

    lsp.stderr.on('data', (data) => {
      stderrOutput += data.toString();
    });

    lsp.on('close', (code) => {
      log('\n==========================================', BLUE);
      log('Test Results', BLUE);
      log('==========================================', BLUE);
      log(`Tests passed: ${testsPassed}`, testsPassed > 0 ? GREEN : YELLOW);
      log(`Tests failed: ${testsFailed}`, testsFailed > 0 ? RED : GREEN);
      log(`Exit code: ${code}`, code === 0 ? GREEN : RED);

      if (stderrOutput && !stderrOutput.includes('LSP connection error')) {
        log('\nServer stderr:', YELLOW);
        log(stderrOutput, YELLOW);
      }

      if (code === 0 && testsPassed >= 3) {
        log('\n✓ LSP server is working correctly!', GREEN);
        log('  The server can:', GREEN);
        log('  - Accept initialize requests', GREEN);
        log('  - Handle document open notifications', GREEN);
        log('  - Respond to feature requests', GREEN);
        log('  - Shutdown cleanly', GREEN);
        log('\nThe problem is likely in VS Code extension configuration.', YELLOW);
      } else if (testsPassed > 0) {
        log('\n⚠ LSP server partially working', YELLOW);
        log('  Some features responded correctly', YELLOW);
      } else {
        log('\n✗ LSP server not responding correctly', RED);
      }

      log('', RESET);
      resolve(code === 0 && testsPassed >= 3);
    });

    lsp.on('error', (err) => {
      log(`\n✗ Failed to spawn LSP: ${err.message}`, RED);
      testsFailed++;
      resolve(false);
    });

    // Send initialize request
    log('→ Sending initialize request', YELLOW);
    requestId++;
    const initRequest = encodeMessage({
      jsonrpc: '2.0',
      id: requestId,
      method: 'initialize',
      params: {
        processId: process.pid,
        clientInfo: {
          name: 'test-client',
          version: '1.0.0'
        },
        capabilities: {
          textDocument: {
            hover: {
              contentFormat: ['markdown', 'plaintext']
            },
            completion: {
              completionItem: {
                snippetSupport: false
              }
            },
            definition: {
              linkSupport: false
            }
          }
        },
        rootUri: 'file:///tmp',
        workspaceFolders: null
      }
    });

    lsp.stdin.write(initRequest);
  });
}

// Run the test
testLSP().then((success) => {
  process.exit(success ? 0 : 1);
}).catch((err) => {
  log(`\n✗ Test error: ${err}`, RED);
  process.exit(1);
});
