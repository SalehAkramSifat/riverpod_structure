# 🚀 Flutter Riverpod Starter Template

A clean, readable, and beginner-friendly Flutter architecture boilerplate powered by **Flutter Riverpod 3.x**, **GoRouter**, and **Dio**.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📑 Table of Contents
- [Architecture Overview](#-architecture-overview)
- [Folder Structure](#-folder-structure)
- [Core Modules & Features](#-core-modules--features)
  - [1. Authentication & Secure Storage (`AuthService`)](#1-authentication--secure-storage-authservice)
  - [2. Network Client (`NetworkCaller`)](#2-network-client-networkcaller)
  - [3. Real-time Connectivity Monitor (`NetworkController`)](#3-real-time-connectivity-monitor-networkcontroller)
  - [4. Theming System (`AppTheme` & `AppThemeNotifier`)](#4-theming-system-apptheme--appthemenotifier)
  - [5. Universal Response Model (`ResponseData`)](#5-universal-response-model-responsedata)
  - [6. Standardized Logging (`AppLogger`)](#6-standardized-logging-applogger)
  - [7. Reusable Common Widgets](#7-reusable-common-widgets)
- [Navigation & Routing (`GoRouter`)](#-navigation--routing-gorouter)
- [Assets Management](#-assets-management)
- [Getting Started](#-getting-started)

---

## 🏛️ Architecture Overview

The codebase is structured to enforce separation of concerns while keeping files short, readable, and developer-friendly:

- **Core Layer (`lib/core/`)**: Houses foundational services, design systems, common widgets, utilities, and global configurations shared across all features.
- **Features Layer (`lib/features/`)**: Feature-driven modules separated into `data`, `domain`, and `presentation` layers following Clean Architecture.
- **Routes Layer (`lib/routes/`)**: Centralized declarative routing powered by GoRouter and Riverpod.

---

## 📂 Folder Structure

```text
lib/
├── app.dart                                # Root MaterialApp.router & global overlay builder
├── main.dart                               # Entry point, services bootstrap & orientation lock
├── routes/
│   └── app_router.dart                     # GoRouter configuration & rootNavigatorKey
│
├── core/
│   ├── common/                             # Standardized theme-aware UI components
│   │   ├── custom_appbar.dart              # Multi-mode AppBar (minimal, centerText, trailing)
│   │   ├── custom_button.dart              # Button with filled, outlined, text & loading state
│   │   ├── custom_empty_message.dart       # Empty state handler (search, favorite, error, general)
│   │   ├── custom_text.dart                # ScreenUtil-scaled GoogleFonts text wrapper
│   │   ├── custom_textformfield.dart       # Form field with prefix/suffix & validation
│   │   ├── no_internet_screen.dart         # Adaptive offline screen with Lottie animation
│   │   ├── pdf_viewer_screen.dart          # Syncfusion PDF viewer screen
│   │   └── full_screen_photo_viewer.dart   # Interactive photo viewer
│   │
│   ├── exceptions/
│   │   └── app_exception.dart              # Unified error handling model with toLeft() helper
│   │
│   ├── extensions/
│   │   └── build_context_extensions.dart   # context.width, context.isDarkMode, context.showSnackBar
│   │
│   ├── logging/
│   │   └── logger.dart                     # AppLogger with Pretty JSON & release guards
│   │
│   ├── models/
│   │   └── response.dart                   # Standard ResponseData model with .fold() support
│   │
│   ├── services/
│   │   ├── auth_service.dart               # Hardware-encrypted secure storage & in-memory cache
│   │   ├── network_service.dart            # Dio REST client (GET, POST, PUT, PATCH, DELETE, Multipart)
│   │   └── network_controller.dart         # Real-time connectivity & DNS internet access monitor
│   │
│   ├── theme/
│   │   ├── app_theme.dart                  # Light and Dark ThemeData definitions
│   │   └── app_theme_provider.dart         # ThemeMode state notifier with secure persistence
│   │
│   └── utils/
│       ├── app_colors.dart                 # Centralized color tokens
│       ├── app_strings.dart                # App-wide string constants
│       ├── app_urls.dart                   # API endpoints & base URLs
│       ├── app_images.dart                 # Asset image paths
│       ├── app_icons.dart                  # Asset icon paths
│       ├── app_animations.dart             # Lottie asset paths
│       ├── date_format.dart                # Comprehensive date & time formatter
│       ├── time_ago_helper.dart            # Relative time helper ("5m ago", "Just now")
│       └── app_provider_observer.dart      # Riverpod state change debugger
│
└── features/                               # Feature-first modules (Data, Domain, Presentation)
```

---

## ⚡ Core Modules & Features

### 1. Authentication & Secure Storage (`AuthService`)
Location: [`lib/core/services/auth_service.dart`](file:///c:/Project/riverpod_structure/lib/core/services/auth_service.dart)

- **Hardware-backed Encryption**: Uses `flutter_secure_storage` (`Keychain` on iOS, `EncryptedSharedPreferences` on Android).
- **Zero-Lag Synchronous Access**: Loads credentials into fast in-memory variables on startup (`AuthService.token`, `AuthService.userId`, `AuthService.role`, `AuthService.userData`).
- **Safe Logout**: `AuthService.logoutUser()` only deletes sensitive authentication tokens and credentials while preserving user UI settings (such as dark mode and language).
- **Key-Value Storage Helpers**:
  ```dart
  // Write & Read custom secure settings
  await AuthService.write('user_language', 'bn');
  final lang = await AuthService.read('user_language');
  ```

---

### 2. Dio REST Client (`NetworkCaller`)
Location: [`lib/core/services/network_service.dart`](file:///c:/Project/riverpod_structure/lib/core/services/network_service.dart)

Clean, readable, and robust REST API client powered by **Dio**:
- **Supported Methods**: `getRequest`, `postRequest`, `putRequest`, `patchRequest`, `deleteRequest`, and `multipartRequest`.
- **Automatic Bearer Token Injection**: Automatically injects `Authorization: Bearer <token>` from `AuthService.token` unless explicitly overridden.
- **Automatic 401 Session Expiry**: Calls `NetworkCaller.onUnauthorized` callback on receiving HTTP 401, redirecting the user to login.
- **Smart HTML / Server Crash Filter**: Parses server errors (500, 502, 503) and strips out ugly HTML tags to provide clean, human-readable error messages.
- **Offline Fast Failguard**: Detects when device has no connectivity and immediately returns code `0` error without blocking on a 30-second socket timeout.

```dart
final response = await ref.read(networkServiceProvider).getRequest('/api/v1/profile');

if (response.isSuccess) {
  final profileData = response.responseData;
} else {
  context.showSnackBar(response.errorMessage);
}
```

---

### 3. Real-time Connectivity Monitor (`NetworkController`)
Location: [`lib/core/services/network_controller.dart`](file:///c:/Project/riverpod_structure/lib/core/services/network_controller.dart)

- **Real DNS Verification**: Pings `google.com` to eliminate "Connected to Wi-Fi without internet access" false positives.
- **Zero-Setup Global Overlay**: Connected directly to `app.dart` builder. If connection drops, `NoInternetScreen` automatically overlays the screen. When connection returns, the overlay disappears and the user remains exactly where they were without losing form inputs or scroll positions.
- **Manual Retry Callback**: "Try Again" button executes `ref.read(networkControllerProvider.notifier).checkConnection()` with an active loading spinner.

---

### 4. Theming System (`AppTheme` & `AppThemeNotifier`)
Location: [`lib/core/theme/`](file:///c:/Project/riverpod_structure/lib/core/theme/)

- Complete Light and Dark `ThemeData` pre-configured with typography, input decoration, card themes, and color schemes.
- Reactive `appThemeProvider` using Riverpod `Notifier<ThemeMode>`.
- Automatically persists user theme choice in `AuthService` secure storage.
  ```dart
  ref.read(appThemeProvider.notifier).toggleTheme();
  ref.read(appThemeProvider.notifier).setDarkTheme();
  ref.read(appThemeProvider.notifier).setLightTheme();
  ```

---

### 5. Universal Response Model (`ResponseData`)
Location: [`lib/core/models/response.dart`](file:///c:/Project/riverpod_structure/lib/core/models/response.dart)

Standardized model returned by all API calls. Supports both simple property checking and functional programming:

```dart
// Style 1: Direct property inspection
if (response.isSuccess) {
  print(response.responseData);
} else {
  print(response.errorMessage);
}

// Style 2: Functional .fold() pattern
response.fold(
  onSuccess: (data) => handleData(data),
  onError: (error) => showError(error.message),
);
```

---

### 6. Standardized Logging (`AppLogger`)
Location: [`lib/core/logging/logger.dart`](file:///c:/Project/riverpod_structure/lib/core/logging/logger.dart)

- Pretty-prints JSON responses, network requests, information, and error stack traces.
- Automatically silenced in production/release mode via `kReleaseMode` guard.
  ```dart
  AppLogger.info('User logged in successfully');
  AppLogger.json(responseBody, tag: 'API Response');
  AppLogger.error('Failed to parse response', error: e, stackTrace: stack);
  ```

---

### 7. Reusable Common Widgets
Location: [`lib/core/common/`](file:///c:/Project/riverpod_structure/lib/core/common/)

- **`CustomAppBar`**: Adaptive navigation bar supporting `minimal`, `centerText`, `textOnly`, `textWithBack`, and `textWithTrailing` modes.
- **`CustomButton`**: Fully customizable button supporting `ButtonType.filled`, `ButtonType.outlined`, `ButtonType.text`, and async loading states.
- **`CustomText`**: Responsive typography wrapper using Google Fonts and `flutter_screenutil`.
- **`CustomTextFormField`**: Production-grade input field with prefix/suffix icons, obscure toggle, validation, and theme awareness.
- **`CustomEmptyState`**: Standardized empty screen handler with factory constructors:
  ```dart
  CustomEmptyState.search(searchQuery: query, onClear: () => ...);
  CustomEmptyState.notification(onRefresh: () => ...);
  CustomEmptyState.favorite(onExplore: () => ...);
  CustomEmptyState.error(errorMessage: error, onRetry: () => ...);
  ```

---

## 🚦 Navigation & Routing (`GoRouter`)
Location: [`lib/routes/app_router.dart`](file:///c:/Project/riverpod_structure/lib/routes/app_router.dart)

- Uses GoRouter integrated with Riverpod `goRouterProvider`.
- Exposes `rootNavigatorKey` for dialogs and context-free redirection (e.g., auto-logout on 401).
- Type-safe route paths configured under `AppRoute`.

---

## 🎨 Assets Management

```text
assets/
├── animations/           # Lottie animations (e.g. no_internet.json)
├── icons/                # SVG & Vector icons
└── images/               # Raster images (PNG, WebP, JPG)
```
Referenced cleanly via centralized constants:
- `AppImages.appLogo`
- `AppIcons.search`
- `AppAnimations.noInternet`

---

## 🛠️ Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/SalehAkramSifat/riverpod_structure.git
cd riverpod_structure
```

### 2. Prerequisites
- Flutter SDK `^3.12.x` or higher
- Dart SDK `^3.12.x`

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Verify Code Integrity
```bash
dart analyze lib/core lib/routes lib/main.dart lib/app.dart
```

### 5. Run the Project
```bash
flutter run
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

