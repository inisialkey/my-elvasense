# Floating Bottom Navigation Bar Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the side drawer navigation with a floating bottom navigation bar containing 4 tabs: Home, Device, Chat AI, and Services.

**Architecture:** The floating navbar is a custom stateless widget rendered in the `Scaffold.bottomNavigationBar` slot with `extendBody: true` so page content flows behind it. The 3 new pages (Device, Chat AI, Services) are placeholder scaffolds added as children of the existing `ShellRoute`. Settings moves outside the `ShellRoute` and is accessible from the Services page app bar.

**Tech Stack:** Flutter, GoRouter, flutter_bloc (Cubit), flutter_screenutil

---

## File Map

### New Files

| File | Responsibility |
|------|----------------|
| `lib/core/widgets/floating_bottom_nav_bar.dart` | Stateless floating navbar widget |
| `lib/features/device/pages/device_page.dart` | Placeholder Device page |
| `lib/features/device/pages/pages.dart` | Barrel export for device pages |
| `lib/features/device/device.dart` | Barrel export for device feature |
| `lib/features/chat_ai/pages/chat_ai_page.dart` | Placeholder Chat AI page |
| `lib/features/chat_ai/pages/pages.dart` | Barrel export for chat_ai pages |
| `lib/features/chat_ai/chat_ai.dart` | Barrel export for chat_ai feature |
| `lib/features/services/pages/services_page.dart` | Placeholder Services page with settings icon in app bar |
| `lib/features/services/pages/pages.dart` | Barrel export for services pages |
| `lib/features/services/services.dart` | Barrel export for services feature |

### Modified Files

| File | Change |
|------|--------|
| `lib/core/widgets/widgets.dart` | Add export for `floating_bottom_nav_bar.dart` |
| `lib/core/widgets/parent.dart` | Add `extendBody` parameter |
| `lib/core/app_route.dart` | Add 3 `Routes` entries + `GoRoute`s; move `settings` outside `ShellRoute` |
| `lib/features/features.dart` | Add exports for device, chat_ai, services features |
| `lib/features/general/pages/main/main_page.dart` | Remove drawer, add floating bottom nav bar |
| `lib/features/general/pages/main/main.dart` | Remove `menu_drawer.dart` export |
| `lib/features/general/pages/main/cubit/main_cubit.dart` | Update to 4-item menu, route navigation on index change |

### Deleted Files

| File | Reason |
|------|--------|
| `lib/features/general/pages/main/menu_drawer.dart` | Replaced by floating bottom nav bar |

---

### Task 1: Create the `FloatingBottomNavBar` widget

**Files:**
- Create: `lib/core/widgets/floating_bottom_nav_bar.dart`
- Modify: `lib/core/widgets/widgets.dart`

- [ ] **Step 1: Create `floating_bottom_nav_bar.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

const _items = [
  _NavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
  _NavItem(
    label: 'Device',
    icon: Icons.devices_outlined,
    activeIcon: Icons.devices,
  ),
  _NavItem(
    label: 'Chat AI',
    icon: Icons.smart_toy_outlined,
    activeIcon: Icons.smart_toy,
  ),
  _NavItem(
    label: 'Services',
    icon: Icons.grid_view_outlined,
    activeIcon: Icons.grid_view,
  ),
];

const _bgColor = Color(0xff022145);
const _activeColor = Color(0xff38BDF8);
const _inactiveColor = Color(0xffA8A8A8);

class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: 24.h, left: 16.w, right: 16.w),
    decoration: BoxDecoration(
      color: _bgColor,
      borderRadius: BorderRadius.circular(32),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: List.generate(
            _items.length,
            (index) => Expanded(
              child: _NavBarItem(
                item: _items[index],
                isActive: index == currentIndex,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _activeColor : _inactiveColor;
    final icon = isActive ? item.activeIcon : item.icon;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24.w, color: color),
          SizedBox(height: 4.h),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11.sp,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Add export to `widgets.dart`**

Add this line to `lib/core/widgets/widgets.dart`:

```dart
export 'floating_bottom_nav_bar.dart';
```

- [ ] **Step 3: Verify no analysis errors**

Run: `flutter analyze lib/core/widgets/floating_bottom_nav_bar.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/core/widgets/floating_bottom_nav_bar.dart lib/core/widgets/widgets.dart
git commit -m "feat: add FloatingBottomNavBar widget"
```

---

### Task 2: Add `extendBody` parameter to `Parent` widget

**Files:**
- Modify: `lib/core/widgets/parent.dart`

- [ ] **Step 1: Add `extendBody` parameter**

In `lib/core/widgets/parent.dart`, add the `extendBody` field to the `Parent` class constructor parameters (after `extendBodyBehindAppBar`):

```dart
final bool extendBody;
```

Add to the constructor:

```dart
this.extendBody = false,
```

In the `Scaffold` within `_ParentState.build`, add:

```dart
extendBody: widget.extendBody,
```

The full modified `Parent` class:

```dart
import 'package:flutter/material.dart';

class Parent extends StatefulWidget {
  final Widget? child;
  final PreferredSizeWidget? appBar;
  final bool avoidBottomInset;
  final Widget? floatingButton;
  final Widget? bottomNavigation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final Key? scaffoldKey;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  const Parent({
    super.key,
    this.child,
    this.appBar,
    this.avoidBottomInset = true,
    this.floatingButton,
    this.backgroundColor,
    this.bottomNavigation,
    this.drawer,
    this.scaffoldKey,
    this.endDrawer,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
  });

  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    child: Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.avoidBottomInset,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      extendBody: widget.extendBody,
      appBar: widget.appBar,
      body: widget.child,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      floatingActionButton: widget.floatingButton,
      bottomNavigationBar: widget.bottomNavigation,
    ),
  );
}
```

- [ ] **Step 2: Verify no analysis errors**

Run: `flutter analyze lib/core/widgets/parent.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/core/widgets/parent.dart
git commit -m "feat: add extendBody parameter to Parent widget"
```

---

### Task 3: Create placeholder pages (Device, Chat AI, Services)

**Files:**
- Create: `lib/features/device/pages/device_page.dart`
- Create: `lib/features/device/pages/pages.dart`
- Create: `lib/features/device/device.dart`
- Create: `lib/features/chat_ai/pages/chat_ai_page.dart`
- Create: `lib/features/chat_ai/pages/pages.dart`
- Create: `lib/features/chat_ai/chat_ai.dart`
- Create: `lib/features/services/pages/services_page.dart`
- Create: `lib/features/services/pages/pages.dart`
- Create: `lib/features/services/services.dart`
- Modify: `lib/features/features.dart`

- [ ] **Step 1: Create Device page**

`lib/features/device/pages/device_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:myelvasense/core/core.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) => const Parent(
    child: Center(child: Text('Device')),
  );
}
```

`lib/features/device/pages/pages.dart`:

```dart
export 'device_page.dart';
```

`lib/features/device/device.dart`:

```dart
export 'pages/pages.dart';
```

- [ ] **Step 2: Create Chat AI page**

`lib/features/chat_ai/pages/chat_ai_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:myelvasense/core/core.dart';

class ChatAiPage extends StatelessWidget {
  const ChatAiPage({super.key});

  @override
  Widget build(BuildContext context) => const Parent(
    child: Center(child: Text('Chat AI')),
  );
}
```

`lib/features/chat_ai/pages/pages.dart`:

```dart
export 'chat_ai_page.dart';
```

`lib/features/chat_ai/chat_ai.dart`:

```dart
export 'pages/pages.dart';
```

- [ ] **Step 3: Create Services page with settings icon in app bar**

`lib/features/services/pages/services_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myelvasense/core/core.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) => Parent(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Services',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: Dimens.space24),
            onPressed: () => context.goNamed(Routes.settings.name),
          ),
        ],
      ),
    ),
    child: const Center(child: Text('Services')),
  );
}
```

`lib/features/services/pages/pages.dart`:

```dart
export 'services_page.dart';
```

`lib/features/services/services.dart`:

```dart
export 'pages/pages.dart';
```

- [ ] **Step 4: Add exports to `features.dart`**

Add these lines to `lib/features/features.dart`:

```dart
export 'chat_ai/chat_ai.dart';
export 'device/device.dart';
export 'services/services.dart';
```

- [ ] **Step 5: Verify no analysis errors**

Run: `flutter analyze lib/features/device lib/features/chat_ai lib/features/services lib/features/features.dart`
Expected: No issues found

- [ ] **Step 6: Commit**

```bash
git add lib/features/device lib/features/chat_ai lib/features/services lib/features/features.dart
git commit -m "feat: add placeholder pages for Device, Chat AI, and Services"
```

---

### Task 4: Update routes in `app_route.dart`

**Files:**
- Modify: `lib/core/app_route.dart`

- [ ] **Step 1: Add new route entries to `Routes` enum**

In `lib/core/app_route.dart`, add 3 new entries to the `Routes` enum (before the `/// Home Page` comment):

```dart
enum Routes {
  root('/'),
  splashScreen('/splashscreen'),
  onboarding('/onboarding'),
  completeProfile('/complete-profile'),

  /// Home Page
  dashboard('/dashboard'),
  device('/device'),
  chatAi('/chat-ai'),
  services('/services'),
  settings('/settings'),

  // Auth Page
  login('/auth/login'),
  register('/auth/register');

  const Routes(this.path);

  final String path;
}
```

- [ ] **Step 2: Add `GoRoute`s for new pages inside `ShellRoute` and move `settings` outside**

In the `GoRouter` config within `AppRoute.router`, add the 3 new routes as children of the `ShellRoute`, and move the `settings` route outside the `ShellRoute`. The updated routes list:

```dart
static final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: Routes.splashScreen.path,
      name: Routes.splashScreen.name,
      builder: (_, _) => const SplashScreenPage(),
    ),
    GoRoute(
      path: Routes.onboarding.path,
      name: Routes.onboarding.name,
      builder: (_, _) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.completeProfile.path,
      name: Routes.completeProfile.name,
      builder: (_, _) => BlocProvider(
        create: (_) => sl<ReloadFormCubit>(),
        child: const CompleteProfilePage(),
      ),
    ),
    GoRoute(
      path: Routes.root.path,
      name: Routes.root.name,
      redirect: (_, _) => Routes.dashboard.path,
    ),
    GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
      builder: (_, _) => BlocProvider(
        create: (_) => sl<ReloadFormCubit>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: Routes.register.path,
      name: Routes.register.name,
      builder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<RegisterCubit>()),
          BlocProvider(create: (_) => sl<ReloadFormCubit>()),
        ],
        child: const RegisterPage(),
      ),
    ),
    // Settings is outside ShellRoute — no floating navbar
    GoRoute(
      path: Routes.settings.path,
      name: Routes.settings.name,
      builder: (_, _) => const SettingsPage(),
    ),
    ShellRoute(
      builder: (_, _, child) => BlocProvider(
        create: (context) => sl<MainCubit>(),
        child: MainPage(child: child),
      ),
      routes: [
        GoRoute(
          path: Routes.dashboard.path,
          name: Routes.dashboard.name,
          builder: (_, _) => BlocProvider(
            create: (_) => sl<UsersCubit>()..fetchUsers(const UsersParams()),
            child: const DashboardPage(),
          ),
        ),
        GoRoute(
          path: Routes.device.path,
          name: Routes.device.name,
          builder: (_, _) => const DevicePage(),
        ),
        GoRoute(
          path: Routes.chatAi.path,
          name: Routes.chatAi.name,
          builder: (_, _) => const ChatAiPage(),
        ),
        GoRoute(
          path: Routes.services.path,
          name: Routes.services.name,
          builder: (_, _) => const ServicesPage(),
        ),
      ],
    ),
  ],
  // ... rest of GoRouter config unchanged
```

- [ ] **Step 3: Update `isAllowedPages` in redirect to include `settings`**

In the `redirect` callback, settings is now outside the shell route but should still be accessible when logged in. The `isAllowedPages` check should remain unchanged — settings is only reachable from Services when authenticated, and the existing redirect logic already handles this correctly (non-logged-in users on `/settings` would be redirected to login because `isAllowedPages` would be `false`).

No code change needed for this step — just verify the logic is correct.

- [ ] **Step 4: Verify no analysis errors**

Run: `flutter analyze lib/core/app_route.dart`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/core/app_route.dart
git commit -m "feat: add device, chat-ai, services routes; move settings outside ShellRoute"
```

---

### Task 5: Update `MainCubit` for 4-item navigation

**Files:**
- Modify: `lib/features/general/pages/main/cubit/main_cubit.dart`

- [ ] **Step 1: Update `MainCubit` with 4-item menu and route-based navigation**

Replace the contents of `lib/features/general/pages/main/cubit/main_cubit.dart`:

```dart
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
      initMenu(context, mockMenu: mockMenu);
      context.goNamed(_routeMap[index].name);
    }
    emit(MainStateSuccess(mockMenu ?? dataMenus?[_currentIndex]));
  }

  void initMenu(BuildContext context, {DataHelper? mockMenu}) {
    dataMenus = [
      DataHelper(
        title: Strings.of(context)?.dashboard ?? 'Home',
        icon: Icons.home,
        isSelected: true,
      ),
      DataHelper(
        title: 'Device',
        icon: Icons.devices,
      ),
      DataHelper(
        title: 'Chat AI',
        icon: Icons.smart_toy,
      ),
      DataHelper(
        title: 'Services',
        icon: Icons.grid_view,
      ),
    ];
    // Sync index from current route
    _syncIndexFromRoute(context);
    emit(MainStateSuccess(mockMenu ?? dataMenus?[_currentIndex]));
  }

  void _syncIndexFromRoute(BuildContext context) {
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
```

- [ ] **Step 2: Regenerate freezed files**

Run: `flutter pub run build_runner build --delete-conflicting-outputs`
Expected: Build completes successfully

- [ ] **Step 3: Verify no analysis errors**

Run: `flutter analyze lib/features/general/pages/main/cubit/main_cubit.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/features/general/pages/main/cubit/main_cubit.dart lib/features/general/pages/main/cubit/main_cubit.freezed.dart
git commit -m "feat: update MainCubit for 4-item bottom nav with route mapping"
```

---

### Task 6: Refactor `MainPage` — remove drawer, add floating bottom nav

**Files:**
- Modify: `lib/features/general/pages/main/main_page.dart`
- Modify: `lib/features/general/pages/main/main.dart`
- Delete: `lib/features/general/pages/main/menu_drawer.dart`

- [ ] **Step 1: Replace `main_page.dart` with bottom nav implementation**

Replace the contents of `lib/features/general/pages/main/main_page.dart`:

```dart
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
```

- [ ] **Step 2: Remove `menu_drawer.dart` export from barrel file**

In `lib/features/general/pages/main/main.dart`, remove the `menu_drawer.dart` export. The file should read:

```dart
export 'cubit/cubit.dart';
export 'main_page.dart';
```

- [ ] **Step 3: Delete `menu_drawer.dart`**

```bash
rm lib/features/general/pages/main/menu_drawer.dart
```

- [ ] **Step 4: Verify no analysis errors**

Run: `flutter analyze lib/features/general/pages/main/`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/features/general/pages/main/main_page.dart lib/features/general/pages/main/main.dart
git rm lib/features/general/pages/main/menu_drawer.dart
git commit -m "refactor: replace drawer navigation with floating bottom nav bar"
```

---

### Task 7: Final verification

**Files:** None (verification only)

- [ ] **Step 1: Run full analysis**

Run: `flutter analyze`
Expected: No issues found

- [ ] **Step 2: Run tests**

Run: `flutter test`
Expected: All existing tests pass. If any tests reference `MenuDrawer`, `_scaffoldKey`, or the drawer-related behavior in `MainCubit.onBackPressed`, they will need updating — fix inline by adjusting to match the new `onBackPressed(BuildContext context)` signature (no `scaffoldKey` parameter).

- [ ] **Step 3: Commit any test fixes**

```bash
git add -A
git commit -m "fix: update tests for bottom nav refactor"
```
