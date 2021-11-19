import * as vscode from 'vscode';
import * as utils from '../utils/generate_command_utils';

/// UI for 'generate module' cli command 
export async function generateModuleCommand(...args: any[]) {

  // Step 1: getting work folder
  let dirRaw = utils.getDirArgument(args);
  if (dirRaw === null) { return; }
  let dir = dirRaw!;

  // Step 2: getting package name
  let nameInputOptions: vscode.InputBoxOptions = {
    title: "New Elementary Module Name",
    prompt: "Please, enter module name:  (my_cool_module) ",
    placeHolder: "my_cool_module",
    value: "my_cool_module",
    validateInput: (value: string) => {
      if (!utils.isModuleName(value)) {
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

  // Step 3: generate target test file
  let subdirOption = shouldCreateSubdir ? '--create-subdirectory' : '--no-create-subdirectory';
  let cliOptions = ['--path', dir!.fsPath, '--name', nameValue, subdirOption];

  let targetFilesRaw = await utils.runGenerateCommand('module', 'Generating elemantary module', ...cliOptions);

  if (targetFilesRaw === null) { return; }

  // Step 4: show target file in editor
  utils.openGeneratedFilesInEditor(targetFilesRaw);
}

