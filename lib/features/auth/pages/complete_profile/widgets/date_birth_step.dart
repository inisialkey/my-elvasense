import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';

class DateBirthStep extends StatefulWidget {
  const DateBirthStep({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  State<DateBirthStep> createState() => _DateBirthStepState();
}

class _DateBirthStepState extends State<DateBirthStep> {
  final _conDateBirth = TextEditingController();
  final _fnDateBirth = FocusNode();

  final _formValidator = <String, bool>{};

  @override
  void dispose() {
    _conDateBirth.dispose();
    _fnDateBirth.dispose();
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
          'When were you born?',
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
          'Optional. This helps us personalize your experience',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SpacerV(value: Dimens.space24),

        BlocBuilder<ReloadFormCubit, ReloadFormState>(
          builder: (_, _) => TextF(
            key: const Key('date_birth'),
            focusNode: _fnDateBirth,
            controller: _conDateBirth,
            textInputAction: TextInputAction.done,
            hint: '01/10/2030',
            keyboardType: TextInputType.datetime,
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            onTap: () => _selectDate(context),
            isValid: _formValidator.putIfAbsent('date_birth', () => false),
            validatorListener: (String value) {
              _formValidator['date_birth'] = value.isNotEmpty;
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

  Future<void> _selectDate(BuildContext context) => BottomSheetPicker.show(
    context,
    title: 'Date of Birth',
    initialDateTime: DateTime(2000),
    minimumDate: DateTime(1900),
    maximumDate: DateTime.now(),
    onSave: (date) {
      _conDateBirth.text =
          '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
      _formValidator['date_birth'] = true;
      context.read<ReloadFormCubit>().reload();
    },
  );
}
