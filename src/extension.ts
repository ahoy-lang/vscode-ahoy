import * as path from "path";
import { workspace, ExtensionContext, window, commands } from "vscode";
import {
	LanguageClient,
	ServerOptions,
	LanguageClientOptions,
	TransportKind,
	State,
} from "vscode-languageclient/node";

let client: LanguageClient | undefined;
let outputChannel: any;

export function activate(context: ExtensionContext) {
	console.log("Ahoy Language extension is now active!");

	// Create output channel for logging
	outputChannel = window.createOutputChannel("Ahoy Language Extension");
	outputChannel.appendLine("Ahoy Language extension activated");

	// Register restart command
	const restartCommand = commands.registerCommand(
		"ahoy.restartLanguageServer",
		async () => {
			outputChannel.appendLine("Restart command triggered");
			await stopLanguageServer();
			await startLanguageServer(context);
			window.showInformationMessage("Ahoy Language Server restarted");
		},
	);

	context.subscriptions.push(restartCommand);

	// Start the language server
	startLanguageServer(context);
}

async function startLanguageServer(context: ExtensionContext) {
	outputChannel.appendLine("Starting Ahoy Language Server...");

	// Try multiple locations for ahoy-lsp
	const possiblePaths = [
		"ahoy-lsp", // In PATH
		path.join(process.env.HOME || "", ".local/bin/ahoy-lsp"),
		"/usr/local/bin/ahoy-lsp",
	];

	let serverExecutable = "ahoy-lsp";

	// Log the paths we're checking
	outputChannel.appendLine(
		`Looking for ahoy-lsp in: ${possiblePaths.join(", ")}`,
	);

	const serverOptions: ServerOptions = {
		command: serverExecutable,
		args: [],
		transport: TransportKind.stdio,
		options: {
			env: {
				...process.env,
				AHOY_LSP_DEBUG: "1",
			},
		},
	};

	const clientOptions: LanguageClientOptions = {
		documentSelector: [
			{ scheme: "file", language: "ahoy" },
			{ scheme: "untitled", language: "ahoy" },
		],
		synchronize: {
			fileEvents: workspace.createFileSystemWatcher("**/*.ahoy"),
		},
		outputChannelName: "Ahoy Language Server",
		revealOutputChannelOn: 1, // Show on errors
		initializationOptions: {},
		progressOnInitialization: true,
		middleware: {
			// Add middleware to log requests/responses for debugging
			handleDiagnostics: (uri, diagnostics, next) => {
				outputChannel.appendLine(
					`Received ${diagnostics.length} diagnostics for ${uri.toString()}`,
				);
				next(uri, diagnostics);
			},
		},
	};

	outputChannel.appendLine("Creating Language Client...");

	try {
		client = new LanguageClient(
			"ahoy-lsp",
			"Ahoy Language Server",
			serverOptions,
			clientOptions,
		);

		// Add handlers for client state changes
		client.onDidChangeState((event) => {
			const stateNames: Record<number, string> = {
				1: "Stopped",
				2: "Starting",
				3: "Running",
			};
			const oldState =
				stateNames[event.oldState] || `Unknown(${event.oldState})`;
			const newState =
				stateNames[event.newState] || `Unknown(${event.newState})`;

			outputChannel.appendLine(`LSP State: ${oldState} → ${newState}`);

			if (event.newState === State.Running) {
				window.showInformationMessage("Ahoy Language Server is running");
			} else if (event.newState === State.Stopped) {
				outputChannel.appendLine("LSP Server stopped");
			}
		});

		// Start the client. This will also launch the server
		outputChannel.appendLine("Starting client...");
		await client
			.start()
			.then(() => {
				outputChannel.appendLine("✓ Client started successfully");
			})
			.catch((error) => {
				const errorMsg = error instanceof Error ? error.message : String(error);
				const errorStack = error instanceof Error ? error.stack : "";

				outputChannel.appendLine(`✗ Failed to start client: ${errorMsg}`);
				if (errorStack) {
					outputChannel.appendLine(`Stack trace: ${errorStack}`);
				}

				console.error("Failed to start Ahoy Language Server:", error);
				window
					.showErrorMessage(
						`Failed to start Ahoy Language Server: ${errorMsg}. Check the output panel for details.`,
						"Show Output",
					)
					.then((action) => {
						if (action === "Show Output") {
							outputChannel.show();
						}
					});
			});

		context.subscriptions.push(client);
		outputChannel.appendLine("Language Client added to subscriptions");
	} catch (error) {
		const errorMsg = error instanceof Error ? error.message : String(error);
		outputChannel.appendLine(`✗ Error creating Language Client: ${errorMsg}`);
		console.error("Error creating Ahoy Language Client:", error);
		window
			.showErrorMessage(
				`Error creating Ahoy Language Client: ${errorMsg}`,
				"Show Output",
			)
			.then((action) => {
				if (action === "Show Output") {
					outputChannel.show();
				}
			});
	}
}

async function stopLanguageServer() {
	if (!client) {
		outputChannel.appendLine("No client to stop");
		return;
	}

	outputChannel.appendLine("Stopping Ahoy Language Server...");

	try {
		await client.stop();
		outputChannel.appendLine("✓ Language Server stopped successfully");
	} catch (error) {
		const errorMsg = error instanceof Error ? error.message : String(error);
		outputChannel.appendLine(`Error stopping server: ${errorMsg}`);
	}

	client = undefined;
}

export async function deactivate(): Promise<void> {
	outputChannel.appendLine("Deactivating Ahoy Language extension");
	await stopLanguageServer();
}
