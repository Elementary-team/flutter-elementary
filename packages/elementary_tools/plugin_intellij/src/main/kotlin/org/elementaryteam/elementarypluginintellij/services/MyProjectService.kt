package org.elementaryteam.elementarypluginintellij.services

import com.intellij.openapi.project.Project
import org.elementaryteam.elementarypluginintellij.MyBundle

class MyProjectService(project: Project) {

    init {
        println(MyBundle.message("projectService", project.name))
    }
}
