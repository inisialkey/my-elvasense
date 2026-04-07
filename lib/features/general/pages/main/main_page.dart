import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (_, _) =>
        context.read<MainCubit>().onBackPressed(context),
    child: Parent(
      extendBody: true,
      appBar: _appBar(context),
      bottomNavigation: BlocBuilder<MainCubit, MainState>(
        builder: (_, state) => FloatingBottomNavBar(
          currentIndex: context.read<MainCubit>().currentIndex,
          onTap: (index) =>
              context.read<MainCubit>().updateIndex(index, null, context: context),
        ),
      ),
      child: child,
    ),
  );

  PreferredSize _appBar(BuildContext context) => PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: BlocBuilder<MainCubit, MainState>(
        builder: (_, state) => Text(switch (state) {
          MainStateLoading() => '-',
          MainStateSuccess(:final data) => data?.title ?? '-',
        }, style: Theme.of(context).textTheme.titleLarge),
      ),
      actions: const [
        ButtonNotification(),
      ],
    ),
  );
}
