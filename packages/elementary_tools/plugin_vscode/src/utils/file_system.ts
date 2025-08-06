import * as vscode from 'vscode';
import * as fs from 'fs';

/**
 * Checks if the first argument in the provided array is a directory.
 * @param argsRaw arguments array
 * @returns vscode.Uri if first argument is a directory, null otherwise
 */
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

/**
 * Checks if the first argument in the provided array is a file.
 * @param argsRaw arguments array
 * @returns vscode.Uri if first argument is a file, null otherwise
 */
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
