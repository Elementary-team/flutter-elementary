import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/full_name_screen_strings.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/full_name_screen/full_neme_screen_widget_model.dart';
import 'package:profile/features/profile/widgets/next_button.dart';
import 'package:profile/features/profile/widgets/text_form_field_widget.dart';
import 'package:shimmer/shimmer.dart';

/// Widget screen with base data about user(surname, name,
/// second name(optional), birthday).
class FullNameScreen extends ElementaryWidget<IFullNameWidgetModel> {
  /// Create an instance [FullNameScreen].
  const FullNameScreen({
    Key? key,
    WidgetModelFactory wmFactory = fullNameScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IFullNameWidgetModel wm) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(onPressed: wm.backButtonTap),
        title: const Text(FullNameScreenStrings.fullName),
      ),
      body: EntityStateNotifierBuilder<Profile>(
        listenableEntityState: wm.profileEntityState,
        loadingBuilder: (context, _) {
          return const _Shimmer();
        },
        errorBuilder: (context, _, __) {
          return const _ErrorWidget();
        },
        builder: (context, _) {
          return _FullNameWidget(
            surnameEditingController: wm.surnameEditingController,
            nameEditingController: wm.nameEditingController,
            secondNameEditingController: wm.patronymicEditingController,
            birthdayEditingController: wm.birthdayEditingController,
            updateSurname: wm.updateSurname,
            updateName: wm.updateName,
            updateSecondName: wm.updatePatronymic,
            birthday: wm.currentBirthday.toString(),
            surnameFormKey: wm.surnameFormKey,
            nameFormKey: wm.nameFormKey,
            birthdayFormKey: wm.birthdayFormKey,
            onDateTap: wm.onDateTap,
            nextButtonCallback: wm.saveFullName,
          );
        },
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: hintColor,
      highlightColor: white,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
          height: 30.0,
          width: double.infinity,
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
  final TextEditingController surnameEditingController;
  final TextEditingController nameEditingController;
  final TextEditingController secondNameEditingController;
  final TextEditingController birthdayEditingController;
  final Function(String?) updateSurname;
  final Function(String?) updateName;
  final Function(String?) updateSecondName;
  final String? birthday;
  final GlobalKey surnameFormKey;
  final GlobalKey nameFormKey;
  final GlobalKey birthdayFormKey;
  final Function(BuildContext) onDateTap;
  final VoidCallback nextButtonCallback;

  const _FullNameWidget({
    required this.surnameEditingController,
    required this.nameEditingController,
    required this.secondNameEditingController,
    required this.birthdayEditingController,
    required this.updateSurname,
    required this.updateName,
    required this.updateSecondName,
    required this.birthday,
    required this.surnameFormKey,
    required this.nameFormKey,
    required this.birthdayFormKey,
    required this.onDateTap,
    required this.nextButtonCallback,
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
              controller: surnameEditingController,
              onChanged: updateSurname,
              hintText: FullNameScreenStrings.surname,
              validator: _surnameValidator,
              formKey: surnameFormKey,
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              controller: nameEditingController,
              onChanged: updateName,
              hintText: FullNameScreenStrings.name,
              validator: _nameValidator,
              formKey: nameFormKey,
            ),
            const SizedBox(height: 16.0),
            TextFormFieldWidget(
              controller: secondNameEditingController,
              onChanged: updateSecondName,
              hintText: FullNameScreenStrings.patronymic,
            ),
            const SizedBox(height: 16.0),
            _DateWidget(
              controller: birthdayEditingController,
              birthdayDate: birthday,
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
  final String? birthdayDate;
  final String? Function(String?) validator;
  final GlobalKey birthdayFormKey;
  final Function(BuildContext) onDateTap;

  const _DateWidget({
    required this.controller,
    required this.birthdayDate,
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
