# Internet Connectivity Check Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add internet connectivity monitoring with a global stream listener showing persistent banners and a per-request Dio interceptor guard.

**Architecture:** A `ConnectivityService` wraps `connectivity_plus` and exposes a stream + sync getter. A `ConnectivityCubit` subscribes to the stream and drives banner UI via `BlocListener`. The `DioInterceptor` checks connectivity before each request and rejects immediately if offline, with `DioClient` mapping to `ConnectionFailure`.

**Tech Stack:** Flutter, connectivity_plus, flutter_bloc (Cubit), Freezed, Dio, GetIt

---

## File Map

### New Files

| File | Responsibility |
|------|----------------|
| `lib/utils/services/connectivity/connectivity_service.dart` | Wraps `connectivity_plus`, exposes `Stream<bool>` and `bool isConnected` |
| `lib/utils/services/connectivity/connectivity.dart` | Barrel export |
| `lib/features/general/pages/main/cubit/connectivity_cubit.dart` | Cubit emitting `connected`/`disconnected` from service stream |

### Modified Files

| File | Change |
|------|--------|
| `pubspec.yaml` | Add `connectivity_plus` dependency |
| `lib/utils/services/services.dart` | Export connectivity barrel |
| `lib/core/error/failure.dart` | Add `ConnectionFailure` class |
| `lib/core/api/dio_interceptor.dart` | Add connectivity check in `onRequest` |
| `lib/core/api/dio_client.dart` | Map `connectionError` to `ConnectionFailure` in catch blocks |
| `lib/features/general/pages/main/cubit/cubit.dart` | Export `connectivity_cubit.dart` |
| `lib/dependencies_injection.dart` | Register `ConnectivityService` + `ConnectivityCubit` |
| `lib/my_elvasense_app.dart` | Add `ConnectivityCubit` to providers + `BlocListener` for banners |

---

### Task 1: Add `connectivity_plus` dependency

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add `connectivity_plus` to `pubspec.yaml`**

In `pubspec.yaml`, add under the `dependencies:` section (after the `firebase_crashlytics` line):

```yaml
  # Connectivity
  connectivity_plus: ^6.1.4
```

- [ ] **Step 2: Install dependencies**

Run: `flutter pub get`
Expected: Resolving dependencies completes successfully

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add connectivity_plus dependency"
```

---

### Task 2: Add `ConnectionFailure` to error types

**Files:**
- Modify: `lib/core/error/failure.dart`

- [ ] **Step 1: Add `ConnectionFailure` class**

Add this class at the end of `lib/core/error/failure.dart`:

```dart
class ConnectionFailure extends Failure {
  final String message;

  const ConnectionFailure([this.message = 'No internet connection']);

  @override
  bool operator ==(Object other) =>
      other is ConnectionFailure && other.message == message;

  @override
  int get hashCode => message.hashCode;
}
```

- [ ] **Step 2: Verify no analysis errors**

Run: `flutter analyze lib/core/error/failure.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/core/error/failure.dart
git commit -m "feat: add ConnectionFailure error type"
```

---

### Task 3: Create `ConnectivityService`

**Files:**
- Create: `lib/utils/services/connectivity/connectivity_service.dart`
- Create: `lib/utils/services/connectivity/connectivity.dart`
- Modify: `lib/utils/services/services.dart`

- [ ] **Step 1: Create `connectivity_service.dart`**

```dart
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final _controller = StreamController<bool>.broadcast();

  bool _isConnected = true;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  void _onChanged(List<ConnectivityResult> results) {
    _isConnected = results.any((r) => r != ConnectivityResult.none);
    _controller.add(_isConnected);
  }

  Stream<bool> get stream => _controller.stream;

  bool get isConnected => _isConnected;

  Future<void> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _onChanged(results);
  }

  void dispose() {
    _subscription.cancel();
    _controller.close();
  }
}
```

- [ ] **Step 2: Create barrel export `connectivity.dart`**

```dart
export 'connectivity_service.dart';
```

- [ ] **Step 3: Add export to `services.dart`**

Add this line to `lib/utils/services/services.dart`:

```dart
export 'connectivity/connectivity.dart';
```

The file should read:

```dart
export 'connectivity/connectivity.dart';
export 'firebase/firebase.dart';
export 'hive/hive.dart';
```

- [ ] **Step 4: Verify no analysis errors**

Run: `flutter analyze lib/utils/services/connectivity/`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/utils/services/connectivity/ lib/utils/services/services.dart
git commit -m "feat: add ConnectivityService wrapping connectivity_plus"
```

---

### Task 4: Create `ConnectivityCubit`

**Files:**
- Create: `lib/features/general/pages/main/cubit/connectivity_cubit.dart`
- Modify: `lib/features/general/pages/main/cubit/cubit.dart`

- [ ] **Step 1: Create `connectivity_cubit.dart`**

```dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myelvasense/utils/utils.dart';

part 'connectivity_cubit.freezed.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _service;
  late final StreamSubscription<bool> _subscription;

  ConnectivityCubit(this._service) : super(const ConnectivityState.connected()) {
    _subscription = _service.stream.listen((isConnected) {
      emit(
        isConnected
            ? const ConnectivityState.connected()
            : const ConnectivityState.disconnected(),
      );
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

@freezed
sealed class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState.connected() = ConnectivityStateConnected;

  const factory ConnectivityState.disconnected() = ConnectivityStateDisconnected;
}
```

- [ ] **Step 2: Add export to cubit barrel**

Add this line to `lib/features/general/pages/main/cubit/cubit.dart`:

```dart
export 'connectivity_cubit.dart';
```

The file should read:

```dart
export 'connectivity_cubit.dart';
export 'logout_cubit.dart';
export 'main_cubit.dart';
export 'user_cubit.dart';
```

- [ ] **Step 3: Regenerate freezed files**

Run: `flutter pub run build_runner build --delete-conflicting-outputs`
Expected: Build completes successfully

- [ ] **Step 4: Verify no analysis errors**

Run: `flutter analyze lib/features/general/pages/main/cubit/connectivity_cubit.dart`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/features/general/pages/main/cubit/connectivity_cubit.dart lib/features/general/pages/main/cubit/connectivity_cubit.freezed.dart lib/features/general/pages/main/cubit/cubit.dart
git commit -m "feat: add ConnectivityCubit with freezed states"
```

---

### Task 5: Add per-request connectivity guard to Dio

**Files:**
- Modify: `lib/core/api/dio_interceptor.dart`
- Modify: `lib/core/api/dio_client.dart`

- [ ] **Step 1: Add connectivity check in `DioInterceptor.onRequest`**

In `lib/core/api/dio_interceptor.dart`, add the import at the top:

```dart
import 'package:myelvasense/dependencies_injection.dart';
```

Then at the very beginning of the `onRequest` method, before the header logging, add the connectivity check:

```dart
@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  // Check connectivity before proceeding
  if (sl.isRegistered<ConnectivityService>() &&
      !sl<ConnectivityService>().isConnected) {
    return handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        message: 'No internet connection',
      ),
    );
  }

  String headerMessage = '';
  // ... rest of existing onRequest code unchanged
```

- [ ] **Step 2: Add `ConnectionFailure` mapping in `DioClient.getRequest`**

In `lib/core/api/dio_client.dart`, modify the `on DioException catch` block in `getRequest` to check for `connectionError` first:

```dart
    } on DioException catch (e, stackTrace) {
      if (e.type == DioExceptionType.connectionError) {
        return Left(ConnectionFailure(e.message ?? 'No internet connection'));
      }
      try {
        if (!_isUnitTest) {
          nonFatalError(error: e, stackTrace: stackTrace);
        }
        return Left(
          ServerFailure(
            e.response?.data['diagnostic']['message'] as String? ?? e.message,
          ),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
```

- [ ] **Step 3: Add `ConnectionFailure` mapping in `DioClient.postRequest`**

In `lib/core/api/dio_client.dart`, modify the `on DioException catch` block in `postRequest` identically:

```dart
    } on DioException catch (e, stackTrace) {
      if (e.type == DioExceptionType.connectionError) {
        return Left(ConnectionFailure(e.message ?? 'No internet connection'));
      }
      try {
        if (!_isUnitTest) {
          nonFatalError(error: e, stackTrace: stackTrace);
        }
        return Left(
          ServerFailure(
            e.response?.data['diagnostic']['message'] as String? ?? e.message,
          ),
        );
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
```

- [ ] **Step 4: Verify no analysis errors**

Run: `flutter analyze lib/core/api/`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/core/api/dio_interceptor.dart lib/core/api/dio_client.dart
git commit -m "feat: add per-request connectivity guard in Dio interceptor and client"
```

---

### Task 6: Register services in dependency injection

**Files:**
- Modify: `lib/dependencies_injection.dart`

- [ ] **Step 1: Register `ConnectivityService` and `ConnectivityCubit`**

In `lib/dependencies_injection.dart`, add the `ConnectivityService` registration inside `serviceLocator`, after the `DioClient` registration:

```dart
sl.registerSingleton<DioClient>(DioClient(isUnitTest: isUnitTest));

if (!isUnitTest) {
  sl.registerSingleton<ConnectivityService>(ConnectivityService());
}
```

Then in the `_cubit()` function, add the `ConnectivityCubit` registration:

```dart
void _cubit() {
  /// Auth
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => GeneralTokenCubit(sl()));
  sl.registerFactory(() => LogoutCubit(sl()));

  /// General
  sl.registerFactory(() => ReloadFormCubit());

  /// Connectivity
  if (sl.isRegistered<ConnectivityService>()) {
    sl.registerFactory(() => ConnectivityCubit(sl()));
  }

  /// Users
  sl.registerFactory(() => UserCubit(sl()));
  sl.registerFactory(() => UsersCubit(sl()));
  sl.registerFactory(() => SettingsCubit());
  sl.registerFactory(() => MainCubit());
}
```

- [ ] **Step 2: Verify no analysis errors**

Run: `flutter analyze lib/dependencies_injection.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/dependencies_injection.dart
git commit -m "feat: register ConnectivityService and ConnectivityCubit in DI"
```

---

### Task 7: Add connectivity banner to app root

**Files:**
- Modify: `lib/my_elvasense_app.dart`

- [ ] **Step 1: Add `ConnectivityCubit` to `MultiBlocProvider` and add `BlocListener` for banners**

In `lib/my_elvasense_app.dart`, update the `MultiBlocProvider.providers` list to include `ConnectivityCubit`:

```dart
providers: [
  BlocProvider(create: (_) => sl<SettingsCubit>()..getActiveTheme()),
  BlocProvider(create: (_) => sl<AuthCubit>()),
  BlocProvider(create: (_) => sl<LogoutCubit>()),
  BlocProvider(create: (_) => sl<ConnectivityCubit>()),
],
```

Then wrap the `BlocBuilder<SettingsCubit, DataHelper>` content with a `BlocListener<ConnectivityCubit, ConnectivityState>`. The full `builder` callback inside `ScreenUtilInit` becomes:

```dart
builder: (context, _) {
  /// Pass context to appRoute
  AppRoute.setStream(context);

  return BlocBuilder<SettingsCubit, DataHelper>(
    builder: (_, data) => MaterialApp.router(
      routerConfig: AppRoute.router,
      localizationsDelegates: const [
        Strings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);

        return MediaQuery(
          data: data.copyWith(
            textScaler: TextScaler.noScaling,
            alwaysUse24HourFormat: true,
          ),
          child: BlocListener<ConnectivityCubit, ConnectivityState>(
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentMaterialBanner();

              switch (state) {
                case ConnectivityStateDisconnected():
                  messenger.showMaterialBanner(
                    MaterialBanner(
                      backgroundColor: Theme.of(context)
                          .extension<MyElvasenseColors>()!
                          .red!,
                      content: const Text(
                        'No internet connection',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.wifi_off,
                        color: Colors.white,
                      ),
                      actions: const [SizedBox.shrink()],
                    ),
                  );
                case ConnectivityStateConnected():
                  messenger.showMaterialBanner(
                    MaterialBanner(
                      backgroundColor: Theme.of(context)
                          .extension<MyElvasenseColors>()!
                          .green!,
                      content: const Text(
                        'Connection restored',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.wifi,
                        color: Colors.white,
                      ),
                      actions: const [SizedBox.shrink()],
                    ),
                  );
                  Future.delayed(
                    const Duration(seconds: 2),
                    () => messenger.hideCurrentMaterialBanner(),
                  );
              }
            },
            child: child!,
          ),
        );
      },
      title: Constants.get.appName,
      theme: themeLight(context),
      darkTheme: themeDark(context),
      locale: Locale(data.type ?? 'en'),
      supportedLocales: L10n.all,
      themeMode: data.activeTheme.mode,
    ),
  );
},
```

- [ ] **Step 2: Verify no analysis errors**

Run: `flutter analyze lib/my_elvasense_app.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/my_elvasense_app.dart
git commit -m "feat: add connectivity banner listener to app root"
```

---

### Task 8: Final verification

**Files:** None (verification only)

- [ ] **Step 1: Run full analysis**

Run: `flutter analyze`
Expected: No new issues (only pre-existing warnings)

- [ ] **Step 2: Run tests**

Run: `flutter test`
Expected: No new test failures (pre-existing template test failure is expected)

- [ ] **Step 3: Manual smoke test**

Run the app in staging:
```bash
flutter run --flavor stg -t lib/main.dart --dart-define-from-file .env.stg.json
```

Test:
1. Toggle airplane mode ON — red "No internet connection" banner should appear
2. Toggle airplane mode OFF — red banner dismissed, green "Connection restored" banner appears for 2 seconds
3. With airplane mode ON, trigger an API call — should return `ConnectionFailure` (no hanging request)
