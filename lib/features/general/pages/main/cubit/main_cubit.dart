import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/utils/utils.dart';

part 'main_cubit.freezed.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainStateLoading());

  int _currentIndex = 0;
  late List<DataHelper>? dataMenus;

  int get currentIndex => _currentIndex;

  static const _routeMap = [
    Routes.dashboard,
    Routes.device,
    Routes.chatAi,
    Routes.services,
  ];

  void updateIndex(int index, DataHelper? mockMenu, {BuildContext? context}) {
    emit(const MainStateLoading());
    _currentIndex = index;
    if (context != null) {
      _buildMenus(context);
      context.goNamed(_routeMap[index].name);
    }
    emit(MainStateSuccess(mockMenu ?? dataMenus?[_currentIndex]));
  }

  void initMenu(BuildContext context, {DataHelper? mockMenu}) {
    _buildMenus(context);
    _syncIndexFromRoute(context);
    emit(MainStateSuccess(mockMenu ?? dataMenus?[_currentIndex]));
  }

  void _buildMenus(BuildContext context) {
    dataMenus = [
      DataHelper(
        title: Strings.of(context)?.dashboard ?? 'Home',
        icon: Icons.home,
        isSelected: true,
      ),
      DataHelper(title: 'Device', icon: Icons.devices),
      DataHelper(title: 'Chat AI', icon: Icons.smart_toy),
      DataHelper(title: 'Services', icon: Icons.grid_view),
    ];
  }

  void _syncIndexFromRoute(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router == null) return;

    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _routeMap.length; i++) {
      if (location == _routeMap[i].path) {
        _currentIndex = i;
        return;
      }
    }
  }

  bool onBackPressed(BuildContext context, {bool isDrawerClosed = false}) {
    if (_currentIndex == 0) {
      return true;
    } else {
      updateIndex(0, null, context: context);
      return false;
    }
  }
}

@freezed
sealed class MainState with _$MainState {
  const factory MainState.loading() = MainStateLoading;

  const factory MainState.success(DataHelper? data) = MainStateSuccess;
}
