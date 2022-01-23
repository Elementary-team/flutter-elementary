//package ru.elementaryteam.elementarypluginintellij
//
//import com.intellij.execution.process.ProcessAdapter
//import com.intellij.execution.process.ProcessEvent
//import com.intellij.openapi.actionSystem.DataContext
//import com.intellij.openapi.project.Project
//import io.flutter.FlutterMessages
//import io.flutter.actions.FlutterSdkAction
//import io.flutter.pub.PubRoot
//import io.flutter.sdk.FlutterSdk
//import io.flutter.utils.ProgressHelper
//
///**
// * Action that install CLI package
// */
//class ElementaryCliInstallAction : FlutterSdkAction() {
//
//    override fun startCommand(
//        project: Project,
//        sdk: FlutterSdk,
//        root: PubRoot?,
//        context: DataContext
//    ) {
//        val pubFullArguments = arrayOf(
//            "global",
//            "activate",
//            "elementary_cli",
//        )
//
//        val progressHelper = ProgressHelper(project)
//        progressHelper.start("ElementaryCliInstallAction")
//        val processHandler = sdk.flutterPub(root, *pubFullArguments).startInConsole(project)
//        if (processHandler == null) {
//            progressHelper.done()
//        } else {
//            processHandler.addProcessListener(object : ProcessAdapter() {
//                override fun processTerminated(event: ProcessEvent) {
//                    progressHelper.done()
//                    val exitCode = event.exitCode
//                    if (exitCode != 0) {
//                        FlutterMessages.showError(
//                            "Error installing `elementary_cli`",
//                            "`activate command returned: $exitCode", project
//                        )
//                    } else {
//                        FlutterMessages.showInfo(
//                            "Installed elementary_cli",
//                            "Package `elementary_cli` successfully activated.",
//                            project
//                        )
//                    }
//                }
//            })
//        }
//    }
//}
