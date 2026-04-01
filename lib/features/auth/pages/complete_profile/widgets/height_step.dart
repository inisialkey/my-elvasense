import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';

class HeightStep extends StatefulWidget {
  const HeightStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  State<HeightStep> createState() => _HeightStepState();
}

class _HeightStepState extends State<HeightStep> {
  final _conHeight = TextEditingController();
  final _fnHeight = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  void dispose() {
    _conHeight.dispose();
    _fnHeight.dispose();
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
          'What’s your height?',
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
          'Optional. Used to improve activity and health insights',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SpacerV(value: Dimens.space24),

        BlocBuilder<ReloadFormCubit, ReloadFormState>(
          builder: (_, _) => TextF(
            key: const Key('height'),
            focusNode: _fnHeight,
            controller: _conHeight,
            textInputAction: TextInputAction.done,
            hint: 'Height (cm)',
            keyboardType: TextInputType.number,
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space16),
              child: Text(
                'cm',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: () => _selectHeight(context),
            isValid: _formValidator.putIfAbsent('height', () => false),
            validatorListener: (String value) {
              _formValidator['height'] = value.isNotEmpty;
              context.read<ReloadFormCubit>().reload();
            },
            errorMessage: Strings.of(context)!.errorEmptyField,
          ),
        ),

        const Spacer(),

        BlocBuilder<ReloadFormCubit, ReloadFormState>(
          builder: (_, _) => Button(
            width: double.maxFinite,
            title: 'Next',
            onPressed: widget.onNext,
            color: Theme.of(context).brightness == Brightness.dark
                ? Palette.buttonDark
                : Palette.button,
          ),
        ),

        SpacerV(value: 32.w),
      ],
    ),
  );

  Future<void> _selectHeight(BuildContext context) =>
      BottomSheetNumberPicker.show(
        context,
        title: 'Height',
        unit: 'cm',
        minValue: 100,
        maxValue: 250,
        initialValue: 170,
        onSave: (value) {
          _conHeight.text = '$value';
          _formValidator['height'] = true;
          context.read<ReloadFormCubit>().reload();
        },
      );
}
