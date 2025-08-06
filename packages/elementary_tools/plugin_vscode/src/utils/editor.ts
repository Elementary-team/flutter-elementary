import * as vscode from 'vscode';

/**
 * Opens files in the editor.
 * @param filesString string containing one file path per line
 */
export function openFilesInEditor(filesString: string) {
    filesString.split(/\r?\n/).filter(String).forEach((file, _) => {
        let targetUri = vscode.Uri.parse('file://' + file.trim());
        vscode.workspace.openTextDocument(targetUri)
            .then((moduleDoc) => vscode.window.showTextDocument(moduleDoc, vscode.ViewColumn.Active));
    });
}
