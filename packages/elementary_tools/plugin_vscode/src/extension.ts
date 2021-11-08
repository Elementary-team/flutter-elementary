// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
// import * as dc from 'dart-code';
import * as cp from 'child_process';
import { runGenerateCommand } from './generate_command_utils';
// import * as code from 'dart-code';

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {

	let disposable = vscode.commands.registerCommand('elementary.generate.module', async (...args: any[]) => {

		// Step 1: getting workfolder
		let dirRaw = getDirArgument(args);
		if (dirRaw === null) { return; }
		let dir = dirRaw!;

		// Step 2: getting package name
		let nameInputOptions: vscode.InputBoxOptions = {
			title: "New Elementary Module Name",
			prompt: "Please, enter module name:  (my_cool_module) ",
			placeHolder: "my_cool_module",
			value: "my_cool_module",
			validateInput: (value: string) => {
				// same regex as in elementary_cli tool
				const nameValueRegex = RegExp('^[a-z](_?[a-z0-9])*$');
				if (!nameValueRegex.test(value)) {
					return "Please, provide a valid name";
				}
			},
		};

		let nameValue = await vscode.window.showInputBox(nameInputOptions);
		if (!nameValue) { return; }

		// Step 3: getting subdir option
		let quickPickOptions: vscode.QuickPickOptions = {
			title: "Create new subdirectory for module?",
			canPickMany: false,
			matchOnDescription: true,
			placeHolder: 'yes',
		};

		let sholdCreateSubdirString = await vscode.window.showQuickPick(['yes', 'no'], quickPickOptions);
		if (!sholdCreateSubdirString) { return; }

		let shouldCreateSubdir = sholdCreateSubdirString === 'yes';

		let subdirOption = shouldCreateSubdir ? '--create-subdirectory' : '--no-create-subdirectory';
		let cliOptions = ['--path', dir!.fsPath, '--name', nameValue, subdirOption];

		let output = await runGenerateCommand('module', 'Genarating elemantary module', ...cliOptions);

		vscode.window.showInformationMessage('Generated files:' + output);
	});

	context.subscriptions.push(disposable);
}

function getDirArgument(...argsRaw: any[]): vscode.Uri | null {
	if (argsRaw.length !== 1) {
		return null;
	}

	let arg = argsRaw[0][0];

	if (arg instanceof vscode.Uri) {
		return fs.statSync(arg.fsPath, undefined).isDirectory() ? arg : null;
	}

	return null;
}

// this method is called when your extension is deactivated
export function deactivate() { }
