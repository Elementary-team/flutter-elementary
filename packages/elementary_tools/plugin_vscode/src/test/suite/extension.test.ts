import * as assert from 'assert';

// You can import and use all API from the 'vscode' module
// as well as import your extension to test it
import * as vscode from 'vscode';
import { textHasLineStartingWith } from '../../utils/activate_cli_tools';
// import * as myExtension from '../../extension';

suite('Extension Test Suite', () => {
	vscode.window.showInformationMessage('Start all tests.');

	test('Activate CLI parsing test', () => {
		assert.strictEqual(true, textHasLineStartingWith('somepackage 1.0.0\nelementary_cli 1.0.1\nanotherpackage 2.0.1\n', 'elementary_cli'));
		assert.strictEqual(true, textHasLineStartingWith('1234\nqwerty\nasdf\n', 'a'));
		assert.strictEqual(false, textHasLineStartingWith('1234\nqwerty\nasdf\n', 'lmao'));
	});
});
