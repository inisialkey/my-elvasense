# Internet Connectivity Check — Design Spec

**Date:** 2026-04-07
**Status:** Approved

## Overview

Add internet connectivity monitoring using `connectivity_plus`. Two layers: a global stream listener that proactively shows a persistent banner when offline, and a per-request guard in the Dio interceptor that rejects API calls immediately when offline. When connectivity is restored, a brief success banner appears for 2 seconds.

---

## 1. Component Structure

### New Files

| File | Purpose |
|------|---------|
| `lib/utils/services/connectivity/connectivity_service.dart` | Wraps `connectivity_plus`, exposes `Stream<bool>` and sync `isConnected` getter |
| `lib/utils/services/connectivity/connectivity.dart` | Barrel export |
| `lib/features/general/pages/main/cubit/connectivity_cubit.dart` | Cubit that emits `connected` / `disconnected` states from the service stream |

### Modified Files

| File | Change |
|------|--------|
| `lib/utils/utils.dart` | Export connectivity service barrel |
| `lib/core/error/failure.dart` | Add `ConnectionFailure` subclass |
| `lib/core/api/dio_interceptor.dart` | Add connectivity check in `onRequest` |
| `lib/dependencies_injection.dart` | Register `ConnectivityService` + `ConnectivityCubit` |
| `lib/my_elvasense_app.dart` | Add `ConnectivityCubit` to `MultiBlocProvider` + `BlocListener` for banner |
| `pubspec.yaml` | Add `connectivity_plus` dependency |

---

## 2. ConnectivityService

- Wraps `Connectivity().onConnectivityChanged` from `connectivity_plus`
- Transforms `List<ConnectivityResult>` into `bool` — `true` if any result is not `ConnectivityResult.none`, `false` otherwise
- Exposes:
  - `Stream<bool> get stream` — emits connectivity changes
  - `bool get isConnected` — sync getter, cached from last stream event
- Has `dispose()` to cancel the stream subscription
- Registered as a singleton in GetIt

---

## 3. ConnectivityCubit

- Takes `ConnectivityService` via constructor injection
- Subscribes to `ConnectivityService.stream` in constructor
- Uses Freezed for state:

```dart
@freezed
sealed class ConnectivityState:
  connected()
  disconnected()
```

- Cancels subscription in `close()`
- Registered as a factory in GetIt

---

## 4. ConnectionFailure

- Extends `Failure` (same pattern as `ServerFailure`)
- Default message: `'No internet connection'`
- Added to `lib/core/error/failure.dart`

---

## 5. Per-Request Guard (DioInterceptor)

In `DioInterceptor.onRequest`:
1. Read `ConnectivityService` from GetIt (`sl<ConnectivityService>()`)
2. Check `isConnected`
3. If `false`, reject the request with:

```dart
handler.reject(
  DioException(
    requestOptions: options,
    type: DioExceptionType.connectionError,
    message: 'No internet connection',
  ),
);
```

4. If `true`, proceed with `super.onRequest(options, handler)`

In `DioClient`, the existing catch block maps `DioException` to `ServerFailure`. Add a check: if `e.type == DioExceptionType.connectionError`, return `Left(ConnectionFailure())` instead.

---

## 6. Banner UI & Behavior

A `BlocListener<ConnectivityCubit, ConnectivityState>` wraps the app content in `my_elvasense_app.dart`, using the root `ScaffoldMessenger`.

### When disconnected:
- Show persistent red `MaterialBanner`
- Icon: `Icons.wifi_off`, color: white
- Text: "No internet connection", color: white
- Background color: `MyElvasenseColors.red`
- No dismiss action — stays until connectivity restores

### When reconnected:
- Dismiss the red banner via `ScaffoldMessenger.of(context).hideCurrentMaterialBanner()`
- Show green `MaterialBanner`:
  - Icon: `Icons.wifi`, color: white
  - Text: "Connection restored", color: white
  - Background color: `MyElvasenseColors.green`
- Auto-dismiss after 2 seconds via `Future.delayed`

---

## 7. Out of Scope

- Localization of connectivity messages (can be added later)
- Retry-on-reconnect logic for failed requests
- Specific handling per connectivity type (wifi vs cellular)
