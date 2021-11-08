import * as vscode from 'vscode';
import * as cp from 'child_process';

// should be run with `dart pub` of `flutter pub` executable as target
const elementaryPubCommandArgsStart = ['global', 'run', 'elementary_cli:elementary_tools'];

export async function runGenerateCommand(commandName: string, description: string, ...args: string[]) {
    const generateCommandArgsStart = elementaryPubCommandArgsStart.concat(['generate']);

    let dartCodeExt = vscode.extensions.getExtension('Dart-Code.dart-code');
    // should not be a problem as we're depending on it
	let dartCodeApi = dartCodeExt!.exports;
	let dartCodeApiPrivate = dartCodeApi['_privateApi'];
	let pubGlobal = dartCodeApiPrivate['pubGlobal'];

    let fullDescription = 'Elementary Tools: ' + description;
    let commandArgs = generateCommandArgsStart.concat([commandName]).concat(args);
    let output = await pubGlobal.runCommandWithProgress('elementary_cli', fullDescription, commandArgs);

    console.log(output);
    return output;
};