import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/about_me_screen_strings.dart';
import 'package:profile/features/profile/screens/about_me_screen/about_me_screen_widget_model.dart';
import 'package:profile/features/profile/widgets/next_button.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          children: [
            TextFormField(
              controller: wm.controller,
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
            NextButton(callback: wm.saveAboutMe),
          ],
        ),
      ),
    );
  }
}
