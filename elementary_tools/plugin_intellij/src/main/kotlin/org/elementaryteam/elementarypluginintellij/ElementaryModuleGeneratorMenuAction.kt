package org.elementaryteam.elementarypluginintellij

import com.intellij.openapi.actionSystem.*

class ElementaryModuleGeneratorMenuAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent) {

        val dataContext = e.dataContext

        val view = LangDataKeys.IDE_VIEW.getData(dataContext) ?: return

        val dir = view.orChooseDirectory ?: return

        val dialog = ElementaryModuleGeneratorDialog(e.project, dir)
        dialog.show()
    }
}
