import * as vscode from 'vscode';
import { generateModuleCommand } from './commands/generate_module';
import { generateTestWmCommand } from './commands/generate_test_wm';
import { prepareCli } from './utils/cli_tools';

// This method is called when extension is activated
// Extension is activated the very first time the command is executed
export async function activate(context: vscode.ExtensionContext): Promise<void> {
    let isCliActive = await prepareCli();

    if (isCliActive) {
        let addCommand = (name: string, lambda: (...args: any[]) => Promise<void>) => {
            let registration = vscode.commands.registerCommand(name, lambda);
            context.subscriptions.push(registration);
        };

        addCommand('elementary.generate.module', generateModuleCommand);
        addCommand('elementary.generate.test.wm', generateTestWmCommand);
    }
}

// this method is called when extension is deactivated
export function deactivate() { }
