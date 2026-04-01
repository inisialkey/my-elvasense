import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';

class BottomSheetPicker extends StatefulWidget {
  const BottomSheetPicker({
    required this.title,
    required this.onSave,
    super.key,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.mode = CupertinoDatePickerMode.date,
  });

  final String title;
  final ValueChanged<DateTime> onSave;
  final DateTime? initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final CupertinoDatePickerMode mode;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required ValueChanged<DateTime> onSave,
    DateTime? initialDateTime,
    DateTime? minimumDate,
    DateTime? maximumDate,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  }) => showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Dimens.cornerRadius),
      ),
    ),
    builder: (_) => BottomSheetPicker(
      title: title,
      onSave: onSave,
      initialDateTime: initialDateTime,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      mode: mode,
    ),
  );

  @override
  State<BottomSheetPicker> createState() => _BottomSheetPickerState();
}

class _BottomSheetPickerState extends State<BottomSheetPicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDateTime ?? DateTime(2000);
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SpacerV(value: Dimens.space12),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.space24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Palette.textDark
                    : Palette.text,
              ),
            ),
            IconButton(
              onPressed: () => context.pop(context),
              icon: const Icon(Icons.close),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Palette.iconDark
                  : Palette.icon,
            ),
          ],
        ),
      ),

      SizedBox(
        height: Dimens.bottomsheetPicker,
        child: CupertinoDatePicker(
          mode: widget.mode,
          initialDateTime: _selectedDate,
          minimumDate: widget.minimumDate,
          maximumDate: widget.maximumDate,
          onDateTimeChanged: (date) => setState(() => _selectedDate = date),
        ),
      ),

      Padding(
        padding: EdgeInsets.all(Dimens.space24),
        child: Button(
          width: double.maxFinite,
          title: 'Save',
          onPressed: () {
            widget.onSave(_selectedDate);
            context.pop(context);
          },
        ),
      ),
    ],
  );
}
