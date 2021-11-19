import * as vscode from 'vscode';
import * as utils from '../utils/generate_command_utils';

/// UI for 'generate test wm' cli command 
export async function generateTestWmCommand(...args: any[]) {

  // Step 1: getting source file
  let sourceFileRaw = utils.getFileArgument(args);
  if (sourceFileRaw === null) { return; }
  let sourceFileUri = sourceFileRaw!;

  // Step 2: getting root folder
  if(vscode.workspace.workspaceFolders === undefined) { return; }

  let rootFolderUri = vscode.workspace.workspaceFolders[0].uri;

  // Step 3: generate target test file
  let pathArgument = rootFolderUri.fsPath;
  let nameArgument = sourceFileUri.fsPath;
  let smartModeFlag = '-s';

  let cliOptions = ['wm', smartModeFlag, '--path', pathArgument, '--name', nameArgument];

  let target = await utils.runGenerateCommand('test', 'Generating test', ...cliOptions);
  if (target === null) { return; }

  // Step 4: show target file in editor
  utils.openGeneratedFilesInEditor(target);
}
