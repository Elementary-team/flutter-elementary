import * as vscode from 'vscode';
import * as fs from 'fs';

// activates cli tools
export async function activateCliTools(): Promise<void> {

    const packageName = 'elementary_cli';
    // Step 1: get pub

    let dartCodeExt = vscode.extensions.getExtension('Dart-Code.dart-code');
    // should not be a problem as we're depending on it
    let dartCodeApi = dartCodeExt!.exports;
    let dartCodeApiPrivate = dartCodeApi['_privateApi'];
    let pubGlobal = dartCodeApiPrivate['pubGlobal'];

    // Step 2: check if package is activated

    let checkDescription = 'Elementary Tools: ' + 'checking if package "' + packageName + '" is activated...';
    let checkArgs = ['global', 'list'];

    try {
        let checkResult = await pubGlobal.runCommandWithProgress(packageName, checkDescription, checkArgs);
        // expecting list of all active packages
        // let's check if it has our package

        if (textHasLineStartingWith(checkResult.toString(), packageName)) { return ; }

        // so if we have no package activated ...
        // Step 3: activate it 

        let activateDescription = 'Elementary Tools: ' + 'activating package "' + packageName + '"...';
        let activateArgs = ['global', 'activate', packageName];
        let activateResult = await pubGlobal.runCommandWithProgress(packageName, activateDescription, activateArgs);

        // if activated successfully - there will be line strating with 'Activated packageName' word
        if (!textHasLineStartingWith(activateResult.toString(), 'Activated ' + packageName)) {
            throw new Error('Cannot activate package ' + packageName + '!');
        }

        // show that we done it!
        vscode.window.showInformationMessage('Package ' + packageName + ' activated!');
    } catch (e) {
        console.log(e);
        vscode.window.showErrorMessage('Error: ' + e);
    }
};

export function textHasLineStartingWith(text: string, str: string) {
    // 'm' for multiline usage
    // '^' means start of line
    // so we expect 'start of the line, then our string'
    return RegExp('^' + str, 'm').test(text);
}

