import * as vscode from "vscode";
import { PublicDartExtensionApi, PublicSdk } from "dart-code/src/extension/api/interfaces";

export const dartSdkApi: DartSdk = getDartPublicSdk();
export type DartSdk = PublicSdk;

function getDartPublicSdk(): DartSdk {
  const dartCode = vscode.extensions.getExtension("Dart-Code.dart-code");

  if (!dartCode) {
    // This should not happen since we depend on the Dart plugin.
    throw new Error(
      "Elementary: The Dart extension is not installed."
    );
  }

  const dartExtensionApi = dartCode.exports as PublicDartExtensionApi;
  if (dartExtensionApi.version < 2) {
    throw new Error(`Elementary: Incompatible Dart Code plugin version. Make sure you use actual version of the Dart extension.`);
  }

  return dartExtensionApi.sdk;
}
