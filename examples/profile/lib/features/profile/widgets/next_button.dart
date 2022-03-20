import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';

/// Next button.
class NextButton extends StatelessWidget {
  /// Callback on pressing onPressed.
  final VoidCallback callback;

  /// Create an instance [NextButton].
  const NextButton({
    required this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: const SizedBox(
        width: 50.0,
        child: Icon(
          Icons.navigate_next,
          color: white,
          size: 35,
        ),
      ),
    );
  }
}
