import * as vscode from 'vscode';
import { cwd } from "process";
import { lt } from "semver";
import { runDartCommand } from './dart_process';
import { dartSdkApi } from './dart_extension_api';

const packageName = 'elementary_cli';
const packageTargetVersion = '2.0.0';

export async function prepareCli(): Promise<boolean> {
    try {
        // check installed version
        let installedVersion = await getInstalledVersion();

        if (installedVersion === undefined) {
            const action = "Install Now";
            const res = await vscode.window.showWarningMessage(
                `Elementary: ${packageName} needs to be global active to use Elementary extension.`,
                action
            );

            if (res === action) {
                await installCli();
                return true;
            } else {
                return false;
            }
        } else if (lt(installedVersion, packageTargetVersion)) {
            const action = "Update Now";
            const res = await vscode.window.showWarningMessage(
                `Elementary: Your installed version of ${packageName} (${installedVersion}) is outdated. Please update to ${packageTargetVersion} or later.`,
                action
            );

            if (res === action) {
                await installCli();
                return true;
            } else {
                return false;
            }
        }

        return true;
    } catch (error) {
        console.error("Failed prepare Elementary CLI:", error);
        vscode.window.showErrorMessage(
            `Elementary: Failed to prepare ${packageName}. Please try running 'pub global activate ${packageName}' manually.`
        );

        return false;
    }
};

async function getInstalledVersion(): Promise<string | undefined> {
    try {
        const result = await runDartCommand(["pub", "global", "list"]);
        const versionMatch = new RegExp(
            `^${packageName} (\\d+\\.\\d+\\.\\d+[\\w.\\-+]*)(?: |$)`,
            "m"
        );
        const match = versionMatch.exec(result);
        const installedVersion = match ? match[1] : undefined;

        return installedVersion;
    } catch (error) {
        return undefined;
    }
}

async function installCli(): Promise<void> {
    try {
        await dartSdkApi.runPub(cwd(), [
            "global",
            "activate",
            packageName,
        ]);
        vscode.window.showInformationMessage(`${packageName} installed successfully.`);
    } catch (error) {
        console.error(`Error installing ${packageName}:`, error);
        vscode.window.showErrorMessage(`Failed to install ${packageName}. Please try running 'pub global activate ${packageName}' manually.`);
    }
}
