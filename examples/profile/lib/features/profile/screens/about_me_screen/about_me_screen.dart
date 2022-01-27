import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/about_me_screen_strings.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen_widget_model.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button.dart';

/// Widget screen with user info screen.
class AboutMeScreen extends ElementaryWidget<AboutMeScreenWidgetModel> {
  /// Create an instance [AboutMeScreen].
  const AboutMeScreen({
    Key? key,
    WidgetModelFactory wmFactory = aboutMeScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IAboutMeScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AboutMeScreenStrings.aboutMe),
        actions: const [
          CancelButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: EntityStateNotifierBuilder(
          listenableEntityState: wm.saveEntityState,
          builder: (_, __) {
            return _AboutMeWidget(
              focusNode: wm.focusNode,
              controller: wm.controller,
              onChangedTextFormField: wm.onChanged,
              buttonState: wm.buttonState,
              onPressedElevatedButton: wm.saveAboutMe,
            );
          },
          loadingBuilder: (_, __) {
            return Column(
              children: [
                const SizedBox(height: 16.0),
                const LinearProgressIndicator(),
                const SizedBox(height: 16.0),
                _AboutMeWidget(
                  controller: wm.controller,
                  readOnly: true,
                  buttonState: wm.buttonState,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AboutMeWidget extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String)? onChangedTextFormField;
  final ListenableState<String> buttonState;
  final VoidCallback? onPressedElevatedButton;
  final bool? readOnly;

  const _AboutMeWidget({
    required this.buttonState,
    this.focusNode,
    this.controller,
    this.onChangedTextFormField,
    this.onPressedElevatedButton,
    this.readOnly,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          readOnly: readOnly ?? false,
          focusNode: focusNode,
          controller: controller,
          onChanged: onChangedTextFormField,
          textCapitalization: TextCapitalization.sentences,
          minLines: 6,
          maxLines: 12,
          decoration: const InputDecoration(
            hintText: AboutMeScreenStrings.fewWordsAboutYourself,
            hintStyle: TextStyle(
              fontSize: 18.0,
              color: textFieldBorderColor,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: textFieldBorderColor),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        StateNotifierBuilder<String>(
          listenableState: buttonState,
          builder: (context, text) {
            return ElevatedButton(
              onPressed: onPressedElevatedButton,
              child: SizedBox(
                width: 100.0,
                child: Center(child: Text(text ?? AboutMeScreenStrings.ok)),
              ),
            );
          },
        ),
      ],
    );
  }
}
