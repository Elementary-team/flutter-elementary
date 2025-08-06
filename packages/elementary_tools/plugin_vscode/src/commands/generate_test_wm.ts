import * as vscode from 'vscode';
import * as gen from '../utils/generate';
import * as editor from '../utils/editor';
import * as fs from '../utils/file_system';

/**
 * Represents the command to generate tests for WM.
 * @param args arguments passed to the command
 * @returns 
 */
export async function generateTestWmCommand(...args: any[]) {
  // Step 1: getting source file
  let sourceFileRaw = fs.getFileArgument(args);
  if (sourceFileRaw === null) { return; }
  let sourceFileUri = sourceFileRaw!;

  // Step 2: getting root folder
  if (vscode.workspace.workspaceFolders === undefined) { return; }

  let rootFolderUri = vscode.workspace.workspaceFolders[0].uri;

  // Step 3: generate target test file
  let pathArgument = rootFolderUri.fsPath;
  let nameArgument = sourceFileUri.fsPath;
  let smartModeFlag = '-s';

  let cliOptions = ['wm', smartModeFlag, '--path', pathArgument, '--name', nameArgument];

  let target = await gen.cliGenerateCommand('test', ...cliOptions);
  if (target === undefined) { return; }

  // Step 4: show target file in editor
  editor.openFilesInEditor(target);
}
