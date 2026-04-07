import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';
import 'package:myelvasense/utils/utils.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: EdgeInsets.symmetric(horizontal: Dimens.space24),
    child: BlocListener<LogoutCubit, LogoutState>(
      listener: (ctx, state) => switch (state) {
        LogoutStateLoading() => ctx.show(),
        LogoutStateFailure(:final message) => (() {
          ctx.dismiss();
          message.toToastError(context);
        })(),
        LogoutStateSuccess() => (() {
          ctx.dismiss();
          ctx.pop();
          context.goNamed(Routes.root.name);
        })(),
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.space24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Palette.formDark
              : Palette.card,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            Text(
              'Log Out',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Palette.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            SpacerV(value: Dimens.space12),

            /// Description
            Text(
              'Are you sure want to log out?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Palette.card
                    : Palette.cardDark,
                fontWeight: FontWeight.w500,
              ),
            ),

            SpacerV(value: Dimens.space30),

            /// Buttons
            Row(
              children: [
                /// Cancel
                Expanded(
                  child: _ActionButton(
                    title: 'Cancel',
                    backgroundColor: Palette.lightRed,
                    textColor: Palette.red,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),

                SpacerH(value: Dimens.space12),

                /// Yes
                Expanded(
                  child: _ActionButton(
                    title: 'Yes',
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onTap: () => context.read<LogoutCubit>().postLogout(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(50),
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.space16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
