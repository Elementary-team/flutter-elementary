import * as vscode from 'vscode';
import { runDartCommand } from './dart_process';

const generateCommand = [
    'pub',
    'global',
    'run',
    'elementary_cli:elementary_tools',
    'generate',
];

/**
 * Runs the elementary_cli generate command with provided arguments.
 * @param commandName name of command to run
 * @param args additional arguments for command
 * @returns Promise with target file path or undefined if command failed
 */
export async function cliGenerateCommand(commandName: string, ...args: string[]): Promise<string | undefined> {
    let generateArgs = generateCommand.concat([commandName]).concat(args);

    try {
        let result = await runDartCommand(generateArgs);

        // refreshing files in explorer, so it will show new files faster
        vscode.commands.executeCommand('workbench.files.action.refreshFilesExplorer');

        vscode.window.showInformationMessage('Elementary generated files:' + result);

        return result;
    } catch (e) {
        console.log(e);
        vscode.window.showErrorMessage('Elementary failed to generate:' + e);
    }
};

/**
 * Validates if the provided string is a valid module name.
 * This function works by the same rules as the elementary_cli tool, and
 * used locally to prevent fail by running command.
 * @param subject string to validate
 * @returns true if subject is a valid module name, false otherwise
 */
export function isModuleName(subject: string): boolean {
    const nameValueRegex = RegExp('^[a-z](_?[a-z0-9])*$');
    
    return nameValueRegex.test(subject);
}
