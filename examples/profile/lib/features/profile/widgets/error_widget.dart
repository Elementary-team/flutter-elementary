import 'package:flutter/material.dart';

/// Widget to display error.
class CustomErrorWidget extends StatelessWidget {
  /// Text error.
  final String error;

  /// Create an instance [CustomErrorWidget].
  const CustomErrorWidget({
    required this.error,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
