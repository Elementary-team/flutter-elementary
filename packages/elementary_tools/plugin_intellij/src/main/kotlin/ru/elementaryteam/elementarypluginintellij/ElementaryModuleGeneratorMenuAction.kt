package ru.elementaryteam.elementarypluginintellij

import com.intellij.execution.process.ProcessAdapter
import com.intellij.execution.process.ProcessEvent
import com.intellij.openapi.actionSystem.DataContext
import com.intellij.openapi.actionSystem.LangDataKeys
import com.intellij.openapi.project.Project
import com.intellij.openapi.vfs.VirtualFile
import io.flutter.FlutterMessages
import io.flutter.actions.FlutterSdkAction
import io.flutter.pub.PubRoot
import io.flutter.sdk.FlutterSdk
import io.flutter.utils.ProgressHelper
import kotlinx.coroutines.*
import ru.elementaryteam.elementarypluginintellij.ElementaryCliChecker as ElementaryCliChecker

/**
 * Action that lets to generate new elementary module
 */
class ElementaryModuleGeneratorMenuAction : FlutterSdkAction() {

    override fun startCommand(
        project: Project,
        sdk: FlutterSdk,
        root: PubRoot?,
        context: DataContext
    ) {
        val view = LangDataKeys.IDE_VIEW.getData(context) ?: return
        val dir = view.orChooseDirectory ?: return

        if (ElementaryCliChecker.checkIsCliInstalled(project, sdk, root, context)) {
            return
        }

        val dialog = ElementaryModuleGeneratorDialog(project, dir)
        if (dialog.showAndGet()) {
            val pubGenericArguments = arrayOf(
                "global",
                "run",
                "elementary_cli:elementary_tools",
                "generate",
                "module"
            )
            val userDefinedArguments = dialog.getArgumentResults()
            val pubFullArguments = arrayOf(*pubGenericArguments, *userDefinedArguments)

            val progressHelper = ProgressHelper(project)
            progressHelper.start("ElementaryModuleGeneratorMenuAction")
            val processHandler = sdk.flutterPub(root, *pubFullArguments).startInConsole(project)
            if (processHandler == null) {
                progressHelper.done()
            } else {
                processHandler.addProcessListener(object : ProcessAdapter() {
                    override fun processTerminated(event: ProcessEvent) {
                        progressHelper.done()
                        val exitCode = event.exitCode
                        if (exitCode != 0) {
                            FlutterMessages.showError(
                                "Error while generating files",
                                "`elementary_tool generate` returned: $exitCode", project
                            )
                        } else {
                            indexFiles(dialog.getGeneratedFilesDirectory())
                        }
                    }
                })
            }
        }
    }

    fun indexFiles(directory: VirtualFile) {
        directory.refresh(true, true)
    }

}
