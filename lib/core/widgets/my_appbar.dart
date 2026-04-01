import 'package:flutter/material.dart';
import 'package:myelvasense/core/core.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.actions,
    this.onBack,
  });

  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: title != null ? Text(title!) : null,
    centerTitle: centerTitle,
    actions: actions,
    automaticallyImplyLeading: onBack != null,
    leading: onBack != null
        ? IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: onBack)
        : null,
    iconTheme: IconThemeData(
      color: Theme.of(context).brightness == Brightness.dark
          ? Palette.iconDark
          : Palette.icon,
    ),
  );
}
