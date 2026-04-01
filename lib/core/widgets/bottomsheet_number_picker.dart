import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';

class BottomSheetNumberPicker extends StatefulWidget {
  const BottomSheetNumberPicker({
    required this.title,
    required this.onSave,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    super.key,
    this.initialValue,
  });

  final String title;
  final String unit;
  final int minValue;
  final int maxValue;
  final int? initialValue;
  final ValueChanged<int> onSave;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String unit,
    required int minValue,
    required int maxValue,
    required ValueChanged<int> onSave,
    int? initialValue,
  }) => showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Dimens.cornerRadius),
      ),
    ),
    builder: (_) => BottomSheetNumberPicker(
      title: title,
      unit: unit,
      minValue: minValue,
      maxValue: maxValue,
      initialValue: initialValue,
      onSave: onSave,
    ),
  );

  @override
  State<BottomSheetNumberPicker> createState() =>
      _BottomSheetNumberPickerState();
}

class _BottomSheetNumberPickerState extends State<BottomSheetNumberPicker> {
  late int _selectedValue;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ?? widget.minValue;
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedValue - widget.minValue,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SpacerV(value: Dimens.space12),

      // Header
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

      // Number Picker
      SizedBox(
        height: Dimens.bottomsheetPicker,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Selected item highlight
            Container(
              height: Dimens.space40,
              margin: EdgeInsets.symmetric(horizontal: Dimens.space24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimens.cornerRadiusForm),
              ),
            ),

            // Wheel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Dimens.space50,
                  child: ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 44,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedValue = widget.minValue + index);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: widget.maxValue - widget.minValue + 1,
                      builder: (context, index) {
                        final value = widget.minValue + index;
                        final isSelected = value == _selectedValue;
                        return Center(
                          child: Text(
                            '$value',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).hintColor,
                                  fontSize: isSelected ? 20 : 16,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Unit label
                Text(
                  widget.unit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      Padding(
        padding: EdgeInsets.all(Dimens.space24),
        child: Button(
          width: double.maxFinite,
          title: 'Save',
          onPressed: () {
            widget.onSave(_selectedValue);
            context.pop(context);
          },
        ),
      ),
    ],
  );
}
