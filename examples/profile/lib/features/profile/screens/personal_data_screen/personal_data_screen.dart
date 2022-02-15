import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:profile/assets/colors/colors.dart';
import 'package:profile/assets/strings/personal_data_screen_strings.dart';
import 'package:profile/features/profile/domain/profile.dart';
import 'package:profile/features/profile/screens/personal_data_screen/personal_data_screen_widget_model.dart';
import 'package:profile/features/profile/screens/personal_data_screen/widgets/text_form_field_widget.dart';
import 'package:profile/features/profile/widgets/cancel_button/cancel_button.dart';
import 'package:profile/features/profile/widgets/error_widget.dart';
import 'package:profile/features/profile/widgets/next_button.dart';
import 'package:shimmer/shimmer.dart';

const _shimmerHeight = 60.0;
const _shimmerWidth = double.infinity;

/// Widget screen with base data about user(surname, name,
/// secondName(optional), birthday).
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
        title: const Text(PersonalDataScreenStrings.personalDataTitle),
        actions: const [
          CancelButton(),
        ],
      ),
      body: EntityStateNotifierBuilder<Profile>(
        listenableEntityState: wm.profileEntityState,
        loadingBuilder: (context, _) {
          return const _LoadingWidget();
        },
        errorBuilder: (context, _, __) {
          return const CustomErrorWidget(
            error: PersonalDataScreenStrings.errorLoading,
          );
        },
        builder: (context, profile) {
          return _FullNameWidget(
            surnameEditingController: wm.surnameEditingController,
            nameEditingController: wm.nameEditingController,
            secondNameEditingController: wm.secondNameEditingController,
            birthdayEditingController: wm.birthdayEditingController,
            formKey: wm.formKey,
            onDateTap: wm.onDateTap,
            nextButtonCallback: wm.updatePersonalData,
            surnameValidator: wm.surnameValidator,
            nameValidator: wm.nameValidator,
            birthdayValidator: wm.birthdayValidator,
          );
        },
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      baseColor: secondaryColor.withOpacity(0.5),
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

class _FullNameWidget extends StatelessWidget {
  final TextEditingController surnameEditingController;
  final TextEditingController nameEditingController;
  final TextEditingController secondNameEditingController;
  final TextEditingController birthdayEditingController;
  final GlobalKey formKey;
  final Function(BuildContext) onDateTap;
  final VoidCallback nextButtonCallback;
  final String? Function(String?) surnameValidator;
  final String? Function(String?) nameValidator;
  final String? Function(String?) birthdayValidator;

  const _FullNameWidget({
    required this.surnameEditingController,
    required this.nameEditingController,
    required this.secondNameEditingController,
    required this.birthdayEditingController,
    required this.formKey,
    required this.onDateTap,
    required this.nextButtonCallback,
    required this.surnameValidator,
    required this.nameValidator,
    required this.birthdayValidator,
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormFieldWidget(
                controller: surnameEditingController,
                hintText: PersonalDataScreenStrings.surnameHint,
                validator: surnameValidator,
              ),
              const SizedBox(height: 16.0),
              TextFormFieldWidget(
                controller: nameEditingController,
                hintText: PersonalDataScreenStrings.nameTitle,
                validator: nameValidator,
              ),
              const SizedBox(height: 16.0),
              TextFormFieldWidget(
                controller: secondNameEditingController,
                hintText: PersonalDataScreenStrings.secondNameHint,
              ),
              const SizedBox(height: 16.0),
              _DateWidget(
                controller: birthdayEditingController,
                validator: birthdayValidator,
                onDateTap: onDateTap,
              ),
              const SizedBox(height: 16.0),
              NextButton(
                callback: nextButtonCallback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Function(BuildContext) onDateTap;

  const _DateWidget({
    required this.controller,
    required this.validator,
    required this.onDateTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      onTap: () {
        onDateTap(context);
      },
      validator: validator,
      decoration: const InputDecoration(
        hintText: PersonalDataScreenStrings.birthdayHint,
        hintStyle: TextStyle(
          fontSize: 18.0,
          color: textFieldBorderColor,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: textFieldBorderColor),
        ),
      ),
    );
  }
}
