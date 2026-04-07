# Floating Bottom Navigation Bar — Design Spec

**Date:** 2026-04-06
**Status:** Approved

## Overview

Refactor the existing side drawer navigation into a floating bottom navigation bar with 4 menu items: Home, Device, Chat AI, and Services. The navbar floats above page content with specific margins and a fixed color scheme independent of the app theme.

---

## 1. Component Structure

### New Files

| File | Purpose |
|------|---------|
| `lib/core/widgets/floating_bottom_nav_bar.dart` | Reusable stateless floating navbar widget |
| `lib/features/device/pages/device_page.dart` | Placeholder page for Device |
| `lib/features/chat_ai/pages/chat_ai_page.dart` | Placeholder page for Chat AI |
| `lib/features/services/pages/services_page.dart` | Placeholder page for Services (with settings icon in app bar) |

### Modified Files

| File | Change |
|------|--------|
| `lib/core/widgets/widgets.dart` | Export `FloatingBottomNavBar` |
| `lib/core/widgets/parent.dart` | Add `extendBody` bool param (default `false`) |
| `lib/core/app_route.dart` | Add 3 new `Routes` entries + `GoRoute`s inside `ShellRoute`; move `settings` outside `ShellRoute` |
| `lib/features/general/pages/main/main_page.dart` | Remove drawer + hamburger icon; pass `FloatingBottomNavBar` to `Parent.bottomNavigation`; enable `extendBody: true` |
| `lib/features/general/pages/main/cubit/main_cubit.dart` | Update `initMenu` to 4 items; `updateIndex` navigates via GoRouter |

---

## 2. Navigation & Routing

### New Routes (added to `Routes` enum)

```dart
device('/device')
chatAi('/chat-ai')
services('/services')
```

### ShellRoute structure

`dashboard`, `device`, `chatAi`, `services` are children of the `ShellRoute` — they all show the floating navbar via `MainPage`.

`settings` moves **outside** the `ShellRoute` so it renders without the navbar.

### Index-to-route mapping

| Index | Menu | Route |
|-------|------|-------|
| 0 | Home | `Routes.dashboard` |
| 1 | Device | `Routes.device` |
| 2 | Chat AI | `Routes.chatAi` |
| 3 | Services | `Routes.services` |

### Navigation behaviour

- Tapping a nav item calls `MainCubit.updateIndex(index)` which calls `context.goNamed(route)`.
- Back press on index 0 (Home): exits the app (returns `true` from `onBackPressed`).
- Back press on any other index: navigates to Home (index 0).
- Auth redirect logic in the router is unchanged.

### Settings access

The Services page app bar contains a settings `IconButton` that calls `context.goNamed(Routes.settings.name)`. The Logout action remains accessible from within the Settings page.

---

## 3. `FloatingBottomNavBar` Widget

### Layout

```
Padding(bottom: 24, left: 16, right: 16)
└── Container(borderRadius: BorderRadius.circular(32), color: #022145, boxShadow)
    └── Row(4 × Expanded)
        └── InkWell(borderRadius: 32, onTap: onTap(index))
            └── Column(mainAxisAlignment: center)
                ├── Icon(size: 24)
                └── Text(fontSize: 11)
```

### Colors (fixed, not theme-dependent)

| State | Color |
|-------|-------|
| Background | `Color(0xff022145)` |
| Active icon + label | `Color(0xff38BDF8)` |
| Inactive icon + label | `Color(0xffA8A8A8)` |

### Icons

| Menu | Inactive | Active |
|------|----------|--------|
| Home | `Icons.home_outlined` | `Icons.home` |
| Device | `Icons.devices_outlined` | `Icons.devices` |
| Chat AI | `Icons.smart_toy_outlined` | `Icons.smart_toy` |
| Services | `Icons.grid_view_outlined` | `Icons.grid_view` |

### Widget API

```dart
FloatingBottomNavBar({
  required int currentIndex,
  required ValueChanged<int> onTap,
})
```

---

## 4. Content Padding

Pages inside the `ShellRoute` must add bottom padding so scroll content is not obscured by the floating navbar. Each placeholder page uses `SafeArea(bottom: true)` and a bottom padding of approximately `80.h` (navbar height ~56 + 24 margin).

---

## 5. `MainPage` Changes

- `drawer` and `scaffoldKey` removed.
- App bar hamburger (`Icons.sort`) leading icon removed.
- App bar title still reads from `MainCubit` state (active menu title).
- `ButtonNotification` action stays in the app bar.
- `Parent` called with `extendBody: true` and `bottomNavigation: FloatingBottomNavBar(...)`.

---

## 6. Out of Scope

- Device, Chat AI, and Services page content — placeholder scaffolds only.
- Any animation on navbar tab switching.
- Dark/light theme variants for the navbar (colors are fixed per spec).
