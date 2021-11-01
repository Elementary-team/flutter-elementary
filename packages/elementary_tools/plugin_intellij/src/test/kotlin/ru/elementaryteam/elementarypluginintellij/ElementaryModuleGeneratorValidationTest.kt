package ru.elementaryteam.elementarypluginintellij

import com.intellij.testFramework.TestDataPath
import com.intellij.testFramework.fixtures.BasePlatformTestCase
import junit.framework.TestCase
import kotlin.io.path.Path
import kotlin.io.path.readLines

@TestDataPath("\$CONTENT_ROOT/src/test/testData")
class ElementaryModuleGeneratorValidationTest : BasePlatformTestCase() {

    @kotlin.io.path.ExperimentalPathApi
    fun testValidation() {
        val validNames =  Path(testDataPath, "validNames.txt").readLines()
        val invalidNames =  Path(testDataPath, "invalidNames.txt").readLines()

        for (validName in validNames) {
            val errorMessage = ElementaryModuleGeneratorDialog.validateModuleName(validName)
            TestCase.assertNull("valid name $validName got an error message: $errorMessage", errorMessage)
        }

        for (invalidName in invalidNames) {
            val errorMessage = ElementaryModuleGeneratorDialog.validateModuleName(invalidName)
            TestCase.assertNotNull("invalid name $invalidName got no error message", errorMessage)
        }
    }

    override fun getTestDataPath() = "src/test/testData/moduleNameValidation"
}
