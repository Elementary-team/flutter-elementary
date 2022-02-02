import 'package:flutter/material.dart';
import 'package:profile/assets/strings/main_strings.dart';
import 'package:profile/features/app/di/app_scope.dart';
import 'package:profile/features/navigation/domain/entity/app_coordinate.dart';
import 'package:profile/features/navigation/service/coordinator.dart';
import 'package:provider/provider.dart';

/// Initialization screens.
class InitScreen extends StatefulWidget {
  /// Create an instance [InitScreen].
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  late Coordinator _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = context.read<IAppScope>().coordinator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text(MainStrings.editProfileButton),
          onPressed: () {
            _coordinator.navigate(
              context,
              AppCoordinates.personalDataScreen,
            );
          },
        ),
      ),
    );
  }
}
