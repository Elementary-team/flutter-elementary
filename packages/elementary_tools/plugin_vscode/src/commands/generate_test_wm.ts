import * as vscode from 'vscode';
import * as fs from 'fs';
import * as utils from '../utils/generate_command_utils';

export async function generateTestWmCommand(...args: any[]) {

  // Step 1: getting work folder
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

  // Step 3: getting subdirectory option
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

  await utils.runGenerateCommand('module', 'Genarating elemantary module', ...cliOptions);
}

function getFileArgument(...argsRaw: any[]): vscode.Uri | null {

	if (argsRaw.length !== 1) {
		return null;
	}

	let arg = argsRaw[0][0];

	if (arg instanceof vscode.Uri) {
		return fs.statSync(arg.fsPath, undefined).isDirectory() ? arg : null;
	}

	return null;
}