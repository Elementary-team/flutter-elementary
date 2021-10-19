package org.elementaryteam.elementarypluginintellij

import com.intellij.openapi.actionSystem.DataContext
import com.intellij.openapi.actionSystem.LangDataKeys
import com.intellij.openapi.project.Project
import io.flutter.actions.FlutterSdkAction
import io.flutter.pub.PubRoot
import io.flutter.sdk.FlutterSdk

//
//class ElementaryModuleGeneratorMenuAction : AnAction() {
//    override fun actionPerformed(e: AnActionEvent) {
//
//        val dataContext = e.dataContext
//
//        val view = LangDataKeys.IDE_VIEW.getData(dataContext) ?: return
//
//        val dir = view.orChooseDirectory ?: return
//
//        val dialog = ElementaryModuleGeneratorDialog(e.project, dir)
//        if (dialog.showAndGet()) {
//            println(dialog.getArgumentsResultString())
//        }
//    }
//}

class ElementaryModuleGeneratorMenuAction : FlutterSdkAction() {

    override fun startCommand(
        project: Project,
        sdk: FlutterSdk,
        root: PubRoot?,
        context: DataContext
    ) {
        val view = LangDataKeys.IDE_VIEW.getData(context) ?: return

        val dir = view.orChooseDirectory ?: return

        val dialog = ElementaryModuleGeneratorDialog(project, dir)
        if (dialog.showAndGet()) {
            println(dialog.getArgumentResults())
            sdk.flutterPub(root, "global", "run", "elementary_cli:elementary_tools", "generate", "wm", *dialog.getArgumentResults())
                .startInConsole(project)
        }
    }

}
