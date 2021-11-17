import * as vscode from 'vscode';
import * as fs from 'fs';

// should be run with `dart pub` of `flutter pub` executable as target
const elementaryPubCommandArgsStart = ['global', 'run', 'elementary_cli:elementary_tools'];

export async function runGenerateCommand(commandName: string, description: string, ...args: string[]): Promise<string | null> {
    const generateCommandArgsStart = elementaryPubCommandArgsStart.concat(['generate']);

    let dartCodeExt = vscode.extensions.getExtension('Dart-Code.dart-code');
    // should not be a problem as we're depending on it
    let dartCodeApi = dartCodeExt!.exports;
    let dartCodeApiPrivate = dartCodeApi['_privateApi'];
    let pubGlobal = dartCodeApiPrivate['pubGlobal'];

    let fullDescription = 'Elementary Tools: ' + description;
    let commandArgs = generateCommandArgsStart.concat([commandName]).concat(args);

    let runResult = null;
    try {
        runResult = await pubGlobal.runCommandWithProgress('elementary_cli', fullDescription, commandArgs);

        // refreshing files in explorer, so it will show new files faster
        vscode.commands.executeCommand('workbench.files.action.refreshFilesExplorer');

        vscode.window.showInformationMessage('Generated files:' + runResult);
    } catch (e) {
        console.log(e);
        vscode.window.showErrorMessage('Error: ' + e);
    }
    return runResult.toString();
};

// expecting one-line-one-filename format
export function openGeneratedFilesInEditor(filesString: string) {
    filesString.split(/\r?\n/).filter(String).forEach((file, index) => {
        let targetUri = vscode.Uri.parse('file://' + file.trim());
        vscode.workspace.openTextDocument(targetUri)
            .then((moduleDoc) => vscode.window.showTextDocument(moduleDoc, vscode.ViewColumn.Active));
    });
}

// wheter string is 'right_module_name'
export function isModuleName(subject: string): boolean {
    // same regex as in elementary_cli tool
    const nameValueRegex = RegExp('^[a-z](_?[a-z0-9])*$');
    return nameValueRegex.test(subject);
}

// checks if arguments array has directory as first argument
export function getDirArgument(...argsRaw: any[]): vscode.Uri | null {
    if (argsRaw.length !== 1) {
        return null;
    }

    let arg = argsRaw[0][0];

    if (arg instanceof vscode.Uri) {
        return fs.statSync(arg.fsPath, undefined).isDirectory() ? arg : null;
    }

    return null;
}

// checks if arguments array has file as first argument
export function getFileArgument(...argsRaw: any[]): vscode.Uri | null {
    if (argsRaw.length !== 1) {
        return null;
    }

    let arg = argsRaw[0][0];

    if (arg instanceof vscode.Uri) {
        return fs.statSync(arg.fsPath, undefined).isFile() ? arg : null;
    }

    return null;
}
