import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/personal_data_screen_strings.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen_widget_model.dart';
import 'package:profile/features/profile/screens/personal_data_screen/widgets/text_form_field_widget.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button.dart';
import 'package:profile/features/profile/widgets/next_button.dart';
import 'package:shimmer/shimmer.dart';

const _shimmerHeight = 60.0;
const _shimmerWidth = double.infinity;

/// Widget screen with base data about user(surname, name,
/// patronymic(optional), birthday).
class PersonalDataScreen extends ElementaryWidget<IPersonalDataWidgetModel> {
  /// Create an instance [PersonalDataScreen].
  const PersonalDataScreen({
    Key? key,
    WidgetModelFactory wmFactory = fullNameScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IPersonalDataWidgetModel wm) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(onPressed: wm.backButtonTap),
        title: const Text(FullNameScreenStrings.personalData),
        actions: const [
          CancelButton(),
        ],
      ),
      body: EntityStateNotifierBuilder<Profile>(
        listenableEntityState: wm.profileEntityState,
        loadingBuilder: (context, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 16.0),
                const _Shimmer(
                  height: _shimmerHeight,
                  width: _shimmerWidth,
                ),
                const SizedBox(height: 16.0),
                const _Shimmer(
                  height: _shimmerHeight,
                  width: _shimmerWidth,
                ),
                const SizedBox(height: 16.0),
                const _Shimmer(
                  height: _shimmerHeight,
                  width: _shimmerWidth,
                ),
                const SizedBox(height: 16.0),
                const _Shimmer(
                  height: _shimmerHeight,
                  width: _shimmerWidth,
                ),
                const SizedBox(height: 16.0),
                NextButton(callback: () {}),
              ],
            ),
          );
        },
        errorBuilder: (context, _, __) {
          return const _ErrorWidget();
        },
        builder: (context, profile) {
          return _FullNameWidget(
            birthdayEditingController: wm.birthdayEditingController,
            updateSurname: wm.updateSurname,
            updateName: wm.updateName,
            updateSecondName: wm.updatePatronymic,
            surnameFormKey: wm.surnameFormKey,
            nameFormKey: wm.nameFormKey,
            birthdayFormKey: wm.birthdayFormKey,
            onDateTap: wm.onDateTap,
            nextButtonCallback: wm.savePersonalData,
            initialValueSurname: profile?.surname,
            initialValueName: profile?.name,
            initialValuePatronymic: profile?.patronymic,
          );
        },
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  final double height;
  final double width;

  const _Shimmer({
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: secondaryColor,
      highlightColor: white,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
          height: height,
          width: width,
          color: white,
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(FullNameScreenStrings.error),
    );
  }
}

class _FullNameWidget extends StatelessWidget {
  final TextEditingController birthdayEditingController;
  final Function(String?) updateSurname;
  final Function(String?) updateName;
  final Function(String?) updateSecondName;
  final GlobalKey surnameFormKey;
  final GlobalKey nameFormKey;
  final GlobalKey birthdayFormKey;
  final Function(BuildContext) onDateTap;
  final VoidCallback nextButtonCallback;
  final String? initialValueSurname;
  final String? initialValueName;
  final String? initialValuePatronymic;

  const _FullNameWidget({
    required this.birthdayEditingController,
    required this.updateSurname,
    required this.updateName,
    required this.updateSecondName,
    required this.surnameFormKey,
    required this.nameFormKey,
    required this.birthdayFormKey,
    required this.onDateTap,
    required this.nextButtonCallback,
    required this.initialValueSurname,
    required this.initialValueName,
    required this.initialValuePatronymic,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormFieldWidget(
              onChanged: updateSurname,
              hintText: FullNameScreenStrings.surname,
              validator: _surnameValidator,
              formKey: surnameFormKey,
              initialValue: initialValueSurname,
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              onChanged: updateName,
              hintText: FullNameScreenStrings.name,
              validator: _nameValidator,
              formKey: nameFormKey,
              initialValue: initialValueName,
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              onChanged: updateSecondName,
              hintText: FullNameScreenStrings.patronymic,
              initialValue: initialValuePatronymic,
            ),
            const SizedBox(height: 16.0),
            _DateWidget(
              controller: birthdayEditingController,
              validator: _birthdayValidator,
              birthdayFormKey: birthdayFormKey,
              onDateTap: onDateTap,
            ),
            const SizedBox(height: 16.0),
            NextButton(
              callback: nextButtonCallback,
            ),
          ],
        ),
      ),
    );
  }

  String? _surnameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field must be filled';
    } else {
      return null;
    }
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field must be filled';
    } else if (value.length < 2) {
      return 'The name cannot contain less than two characters';
    } else {
      return null;
    }
  }

  String? _birthdayValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field must be filled';
    } else {
      return null;
    }
  }
}

class _DateWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final GlobalKey birthdayFormKey;
  final Function(BuildContext) onDateTap;

  const _DateWidget({
    required this.controller,
    required this.validator,
    required this.birthdayFormKey,
    required this.onDateTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: birthdayFormKey,
      child: TextFormField(
        readOnly: true,
        controller: controller,
        onTap: () {
          onDateTap(context);
        },
        validator: validator,
        decoration: const InputDecoration(
          hintText: FullNameScreenStrings.birthday,
          hintStyle: TextStyle(
            fontSize: 18.0,
            color: textFieldBorderColor,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor),
          ),
        ),
      ),
    );
  }
}
