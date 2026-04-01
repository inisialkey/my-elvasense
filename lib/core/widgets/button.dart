import 'package:flutter/material.dart';
import 'package:myelvasense/core/core.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? width;
  final Color? color;
  final Color? titleColor;
  final double? fontSize;
  final Color? splashColor;

  const Button({
    required this.title,
    required this.onPressed,
    super.key,
    this.width,
    this.color,
    this.titleColor,
    this.fontSize,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Palette.buttonDark
                : Palette.primary),
        foregroundColor: Theme.of(
          context,
        ).extension<MyElvasenseColors>()!.buttonText,
        disabledBackgroundColor: Theme.of(
          context,
        ).extension<MyElvasenseColors>()!.buttonText?.withValues(alpha: 0.5),
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.space24,
          vertical: Dimens.space12,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.cornerRadius)),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              titleColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? Palette.text
                  : Colors.white),
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
