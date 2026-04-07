# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Flutter Version

This project uses Flutter **3.32.8** managed via [FVM](https://fvm.app/). Prefix Flutter commands with `fvm` if FVM is installed, otherwise use `flutter` directly.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Generate Freezed/JSON/mock files (run after modifying models, usecases, or entities)
flutter pub run build_runner build --delete-conflicting-outputs

# Run (staging)
flutter run --flavor stg -t lib/main.dart --dart-define-from-file .env.stg.json

# Run (production)
flutter run --flavor prd -t lib/main.dart --dart-define-from-file .env.prd.json

# Run tests with coverage (requires lcov: brew install lcov)
flutter test -j8 --coverage
lcov --remove coverage/lcov.info 'lib/core/localization/generated/' 'lib/core/resources/*' 'lib/utils/services/firebase/*' '**/*.g.dart' -o coverage/new_lcov.info
genhtml coverage/new_lcov.info -o coverage/html

# Run a single test file
flutter test test/path/to/test_file.dart
```

## Architecture

This project follows **Clean Architecture** (Resocoder pattern) with feature-based modules.

### Folder Structure

```
lib/
├── core/               # Shared infrastructure
│   ├── api/            # DioClient, DioInterceptor, IsolateParser, ListAPI (all endpoints)
│   ├── error/          # Failure and Exception types
│   ├── localization/   # L10n setup + generated strings (en/id)
│   ├── resources/      # Palette, Dimens, Styles, Images constants
│   ├── usecase/        # Abstract UseCase<Type, Params> base class
│   ├── widgets/        # Shared reusable widgets
│   └── app_route.dart  # GoRouter config + Routes enum
├── features/           # Feature modules (auth, users, general)
│   └── <feature>/
│       ├── data/       # datasources, models (Freezed+JSON), repository impls
│       ├── domain/     # entities (Freezed), repository abstracts, usecases
│       └── pages/      # UI pages + cubit/ subdirectory per page
├── utils/
│   ├── ext/            # Dart/Flutter extensions
│   ├── helper/         # Helper classes (DataHelper, GoRouterRefreshStream, etc.)
│   └── services/
│       ├── firebase/   # FirebaseServices init + crash logging
│       └── hive/       # MainBoxMixin (persistent local storage)
├── dependencies_injection.dart   # GetIt (sl) registrations
└── my_elvasense_app.dart         # Root widget with MultiBlocProvider
```

### Key Patterns

**Dependency Injection**: GetIt via `sl` (service locator). All registrations live in `dependencies_injection.dart`. In unit tests, call `serviceLocator(isUnitTest: true)` which resets and skips Hive and DioInterceptor.

**Network layer**: `DioClient` wraps all HTTP calls and returns `Either<Failure, T>` (dartz). JSON is parsed in a background isolate via `IsolateParser`. The base URL comes from `--dart-define-from-file` as `BASE_URL`. All API paths are defined in `lib/core/api/list_api.dart`.

**Local storage**: `MainBoxMixin` (Hive CE) provides `getData`, `addData`, `removeData`. Auth state is keyed on `MainBoxKeys.isLogin` and `MainBoxKeys.accessToken`. The router's redirect logic reads `isLogin` directly from the Hive box.

**Models & Entities**: Use `@freezed` + `@JsonSerializable`. Run `build_runner` after any change. Generated files (`*.freezed.dart`, `*.g.dart`) are committed to the repo and excluded from analysis/coverage.

**Usecases**: Implement `UseCase<ReturnType, Params>` which defines `Future<Either<Failure, T>> call(Params params)`. Params are typically `@freezed` classes.

**State management**: Cubit (flutter_bloc). Each page has its own `cubit/` subdirectory. Global cubits (`AuthCubit`, `LogoutCubit`, `SettingsCubit`) are provided at the app root in `my_elvasense_app.dart`.

**Routing**: `Routes` enum in `app_route.dart` defines all paths. Route guards redirect unauthenticated users to `/auth/login`. The router refreshes on `AuthCubit` and `LogoutCubit` stream changes.

**Flavors**: `stg` and `prd`. Environment variables (e.g., `BASE_URL`, `ENV`) are injected via `--dart-define-from-file`. Access them in code with `const String.fromEnvironment('KEY')`.

### Linting

Uses `package:lint/strict.yaml`. Notable enforced rules: `prefer_single_quotes`, `require_trailing_commas`, `prefer_const_constructors`. Freezed/generated files and localization output are excluded from analysis.
