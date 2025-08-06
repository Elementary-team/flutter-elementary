import { cwd } from "process";
import { dartSdkApi } from './dart_extension_api';

/**
 * Runs a Dart command with args in the current working directory.
 * @param args 
 * @returns A promise that resolves with the command output or rejects with an error.
 */
export function runDartCommand(args: string[]): Thenable<string> {
    return new Promise(async (resolve, reject) => {
        const proc = await dartSdkApi.startDart(cwd(), args);
        if (!proc) {
            reject("Failed to start Dart process.");
            return;
        }

        const stdout: string[] = [];
        const stderr: string[] = [];
        proc.stdout.on("data", (data: Buffer | string) =>
            stdout.push(data.toString())
        );
        proc.stderr.on("data", (data: Buffer | string) =>
            stderr.push(data.toString())
        );
        proc.on("close", (code) => {
            if (!code) {
                resolve(stdout.join(""));
            } else {
                reject(
                    `Dart exited with code ${code}.\n\n${stdout.join(
                        ""
                    )}\n\n${stderr.join("")}`
                );
            }
        });
    });
}
