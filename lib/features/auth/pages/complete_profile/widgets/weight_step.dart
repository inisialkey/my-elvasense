import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';

class WeightStep extends StatefulWidget {
  const WeightStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  State<WeightStep> createState() => _WeightStepState();
}

class _WeightStepState extends State<WeightStep> {
  final _conWeight = TextEditingController();
  final _fnWeight = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  void dispose() {
    _conWeight.dispose();
    _fnWeight.dispose();
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
          'What’s your weight?',
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
            key: const Key('weight'),
            focusNode: _fnWeight,
            controller: _conWeight,
            textInputAction: TextInputAction.done,
            hint: 'Weight (kg)',
            keyboardType: TextInputType.number,
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space16),
              child: Text(
                'kg',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onTap: () => _selectWeight(context),
            isValid: _formValidator.putIfAbsent('weight', () => false),
            validatorListener: (String value) {
              _formValidator['weight'] = value.isNotEmpty;
              context.read<ReloadFormCubit>().reload();
            },
            errorMessage: Strings.of(context)!.errorEmptyField,
          ),
        ),

        const Spacer(),

        BlocBuilder<ReloadFormCubit, ReloadFormState>(
          builder: (_, _) => Button(
            width: double.maxFinite,
            title: 'All Set',
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

  Future<void> _selectWeight(BuildContext context) =>
      BottomSheetNumberPicker.show(
        context,
        title: 'Weight',
        unit: 'kg',
        minValue: 20,
        maxValue: 300,
        initialValue: 75,
        onSave: (value) {
          _conWeight.text = '$value';
          _formValidator['weight'] = true;
          context.read<ReloadFormCubit>().reload();
        },
      );
}
