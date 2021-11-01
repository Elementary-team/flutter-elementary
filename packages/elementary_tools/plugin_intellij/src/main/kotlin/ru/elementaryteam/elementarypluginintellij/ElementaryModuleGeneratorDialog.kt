package ru.elementaryteam.elementarypluginintellij

import com.intellij.openapi.fileChooser.FileChooserDescriptor
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.DialogWrapper
import com.intellij.openapi.ui.TextFieldWithBrowseButton
import com.intellij.openapi.ui.ValidationInfo
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.psi.PsiDirectory
import java.awt.GridLayout
import javax.swing.*

/**
 * Dialog that helps you easily create new Elementary module with three fields:
 * - module name via [nameTextField]
 * - module path via [dirPicker]
 * - mark to create a subdirectory via [subdirectoryCheckbox]
 */
class ElementaryModuleGeneratorDialog(
    private val project: Project?,
    private val resourceDir: PsiDirectory
) :
    DialogWrapper(project) {
    private lateinit var dirPicker: TextFieldWithBrowseButton
    private lateinit var nameTextField: JTextField
    private lateinit var subdirectoryCheckbox: JCheckBox

    init {
        title = "New Elementary Module"
        init()
    }

    companion object {
        // should pass: "my_class_name", "my_1st_test"
        // should NOT pass: "MyClassName", "my___class___name", "1name"
        // [a-z] part means that input must start with a letter
        // (_?[a-z0-9]) part means that every next symbol (or pair) must be either "_x" or "x"
        // so there will never be a "a___b" situation as well as "test_" one
        fun validateModuleName(moduleName: String) : String? {
            if (!moduleName.matches(Regex("^[a-z](_?[a-z0-9])*$"))) {
                return "Please specify a valid file name"
            }
            return null
        }
    }

    override fun createCenterPanel(): JComponent {
        val dialogPanel = JPanel(GridLayout(0, 1))
        dialogPanel.grabFocus()

        val nameLabel = JLabel("Module name (e.g. my_cool_module)")
        val pathLabel = JLabel("Module path")

        nameTextField = JTextField("my_cool_module")
        nameTextField.selectAll()

        dirPicker = TextFieldWithBrowseButton()

        val fileChooserDescriptor = FileChooserDescriptor(false, true, false, false, false, false)
        dirPicker.addBrowseFolderListener("Title", "Description", project, fileChooserDescriptor)
        dirPicker.text = resourceDir.virtualFile.path
        dirPicker.setTextFieldPreferredWidth(80)

        subdirectoryCheckbox = JCheckBox("Create subdirectory", false)

        dialogPanel.add(nameLabel)
        dialogPanel.add(nameTextField)
        dialogPanel.add(pathLabel)
        dialogPanel.add(dirPicker)
        dialogPanel.add(subdirectoryCheckbox)
        return dialogPanel
    }

    /* Checks that given filename is correct with the same regex as elementary_cli tool does */
    override fun doValidate(): ValidationInfo? {
        val errorMessage = validateModuleName(nameTextField.text)
        if (errorMessage != null) {
            return ValidationInfo(errorMessage, nameTextField)
        }
        return null
    }

    /* Converts values taken from user to an array of commands for cli tool */
    fun getArgumentResults(): Array<String> {
        val pathOption = dirPicker.text
        val nameOption = nameTextField.text
        val subdirectoryFlag =
            if (subdirectoryCheckbox.isSelected) "--create-subdirectory" else "--no-create-subdirectory"
        return arrayOf("--path", pathOption, "--name", nameOption, subdirectoryFlag)
    }

    fun getGeneratedFilesDirectory(): VirtualFile {
        return resourceDir.virtualFile
    }
}