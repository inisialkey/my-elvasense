import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';
import 'package:myelvasense/utils/utils.dart';

class YourNameStep extends StatefulWidget {
  const YourNameStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  State<YourNameStep> createState() => _YourNameStepState();
}

class _YourNameStepState extends State<YourNameStep> {
  final _conUsername = TextEditingController();
  final _conName = TextEditingController();
  final _fnUsername = FocusNode();
  final _fnName = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  void dispose() {
    _conUsername.dispose();
    _conName.dispose();
    _fnUsername.dispose();
    _fnName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(Dimens.space24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacerV(value: Dimens.space24),
        Text(
          "Let's get to know you",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Palette.iconDark
                : Palette.icon,
            fontSize: 28.sp,
          ),
        ),
        SpacerV(value: Dimens.space8),
        Text(
          "We'd love to know how to greet you on the app",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SpacerV(value: Dimens.space24),

        // Username Field
        BlocBuilder<ReloadFormCubit, ReloadFormState>(
          builder: (_, _) => TextF(
            key: const Key('username'),
            focusNode: _fnUsername,
            controller: _conUsername,
            textInputAction: TextInputAction.next,
            hint: 'Username',
            keyboardType: TextInputType.text,
            isValid: _formValidator.putIfAbsent('username', () => false),
            validatorListener: (String value) {
              _formValidator['username'] = value.isNotEmpty;
              context.read<ReloadFormCubit>().reload();
            },
            errorMessage: Strings.of(context)!.errorEmptyField,
          ),
        ),

        SpacerV(value: Dimens.space12),

        // Full Name Field
        BlocBuilder<ReloadFormCubit, ReloadFormState>(
          builder: (_, _) => TextF(
            key: const Key('full_name'),
            focusNode: _fnName,
            controller: _conName,
            textInputAction: TextInputAction.done,
            hint: 'Your Name',
            keyboardType: TextInputType.name,
            isValid: _formValidator.putIfAbsent('name', () => false),
            validatorListener: (String value) {
              _formValidator['name'] = value.isNotEmpty;
              context.read<ReloadFormCubit>().reload();
            },
            errorMessage: Strings.of(context)!.errorEmptyField,
          ),
        ),

        const Spacer(),

        // Next Button
        BlocBuilder<ReloadFormCubit, ReloadFormState>(
          builder: (_, _) => Button(
            width: double.maxFinite,
            title: 'Next',
            onPressed: _formValidator.validate() ? widget.onNext : null,
          ),
        ),

        SpacerV(value: 32.w),
      ],
    ),
  );
}
