import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/interests_screen_strings.dart';
import 'package:profile/assets/themes/text_style.dart';
import 'package:profile/features/profile/screens/interests_screen/interests_screen_widget_model.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button.dart';
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
        actions: const [
          CancelButton(),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, index) => _ItemInterest(
          interest: wm.listAllInterests[index],
          state: wm.listUserInterestsState,
          onChanged: wm.onChanged,
        ),
        itemCount: wm.listAllInterests.length,
      ),
      floatingActionButton: NextButton(callback: wm.saveInterestsInProfile),
    );
  }
}

class _ItemInterest extends StatelessWidget {
  final String interest;
  final ListenableState<List<String>> state;
  final Function({required String interest, bool? isChecked}) onChanged;

  const _ItemInterest({
    required this.interest,
    required this.state,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: StateNotifierBuilder<List<String>>(
                listenableState: state,
                builder: (_, userList) => Checkbox(
                  value: userList?.contains(interest) ?? false,
                  onChanged: (isChecked) {
                    onChanged(interest: interest, isChecked: isChecked);
                  },
                ),
              ),
            ),
            Text(
              interest,
              style: textRegular16,
            ),
          ],
        ),
        const Divider(color: dividerColor),
      ],
    );
  }
}
