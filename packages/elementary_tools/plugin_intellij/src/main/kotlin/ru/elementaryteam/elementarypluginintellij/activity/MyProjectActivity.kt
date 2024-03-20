package ru.elementaryteam.elementarypluginintellij.activity

import com.intellij.openapi.components.service
import com.intellij.openapi.project.Project
import com.intellij.openapi.startup.ProjectActivity
import ru.elementaryteam.elementarypluginintellij.services.MyProjectService

internal class MyProjectActivity : ProjectActivity {

    override suspend fun execute(project: Project) {
        project.service<MyProjectService>()
    }
}
