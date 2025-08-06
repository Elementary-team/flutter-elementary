import * as vscode from 'vscode';
import * as gen from '../utils/generate';
import * as editor from '../utils/editor';
import * as fs from '../utils/file_system';

/**
 * Represents the command to generate a new Elementary module.
 * @param args arguments passed to the command
 * @returns 
 */
export async function generateModuleCommand(...args: any[]) {
  // Step 1: getting work folder
  let dirRaw = fs.getDirArgument(args);
  if (dirRaw === null) { return; }
  let dir = dirRaw!;

  // Step 2: getting package name
  let nameInputOptions: vscode.InputBoxOptions = {
    title: "New Elementary Module Name",
    prompt: "Please, enter module name:",
    placeHolder: "module_name",
    value: "new_module_name",
    validateInput: (value: string) => {
      if (!gen.isModuleName(value)) {
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

  let targetFilesRaw = await gen.cliGenerateCommand('module', ...cliOptions);

  if (targetFilesRaw === undefined) {
    return;
  }

  // Step 4: show target file in editor
  editor.openFilesInEditor(targetFilesRaw);
}

