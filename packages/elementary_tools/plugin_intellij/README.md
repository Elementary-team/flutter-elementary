# elementary_plugin_intellij
<!-- TODO rewrite readme -->
<iframe frameborder="none" width="245px" height="48px" src="https://plugins.jetbrains.com/embeddable/install/17848"></iframe>
<!-- TODO add more badges -->

## Template ToDo list
- [x] Create a new [IntelliJ Platform Plugin Template][template] project.
- [x] Get known with the [template documentation][template].
- [x] Verify the [pluginGroup](gradle.properties), [plugin ID](src/main/resources/META-INF/plugin.xml) and [sources package](src/main/kotlin).
- [x] Review the [Legal Agreements](https://plugins.jetbrains.com/docs/marketplace/legal-agreements.html).
- [x] [Publish a plugin manually](https://plugins.jetbrains.com/docs/intellij/publishing-plugin.html?from=IJPluginTemplate) for the first time.
- [x] Set the Plugin ID in the above README badges.
- [x] Set the [Deployment Token](https://plugins.jetbrains.com/docs/marketplace/plugin-upload.html).
- [ ] Click the <kbd>Watch</kbd> button on the top of the [IntelliJ Platform Plugin Template][template] to be notified about releases containing new features and fixes.

<!-- Plugin description -->
This Fancy IntelliJ Platform Plugin is going to be your implementation of the brilliant ideas that you have.

This specific section is a source for the [plugin.xml](src/main/resources/META-INF/plugin.xml) file which will be extracted by the [Gradle](build.gradle.kts) during the build process.

To keep everything working, do not remove `<!-- ... -->` sections. 
<!-- Plugin description end -->

## Installation

- Using IDE built-in plugin system:
  
  <kbd>Settings/Preferences</kbd> > <kbd>Plugins</kbd> > <kbd>Marketplace</kbd> > <kbd>Search for "elementary_plugin_intellij"</kbd> >
  <kbd>Install Plugin</kbd>
  
- Manually:

  Download the [latest release](https://github.com/AlexeyBukin/elementary_plugin_intellij/releases/latest) and install it manually using
  <kbd>Settings/Preferences</kbd> > <kbd>Plugins</kbd> > <kbd>⚙️</kbd> > <kbd>Install plugin from disk...</kbd>


---
Plugin based on the [IntelliJ Platform Plugin Template][template].

[template]: https://github.com/JetBrains/intellij-platform-plugin-template
