import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/strings/interests_screen_strings.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen_widget_model.dart';
import 'package:profile/features/profile/widgets/next_button.dart';

/// Widget screen with users interests.
class InterestsScreen extends ElementaryWidget<IInterestsScreenWidgetModel> {
  /// Create an instance [InterestsScreen].
  const InterestsScreen({
    Key? key,
    WidgetModelFactory wmFactory = interestsScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IInterestsScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(InterestsScreenStrings.interests),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          NextButton(callback: wm.saveInterestsInProfile),
        ],
      ),
    );
  }
}
