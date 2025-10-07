# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter Rapid Framework (flutter_rapid_framework) - A Chinese-language Flutter starter template designed to reduce repetitive work, unify development standards, and improve developer efficiency with a focus on business logic.

**Core Philosophy**: High cohesion, low coupling; configuration over convention; plugin-based architecture; business-focused abstractions.

## Essential Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d <device_id>
```

### Code Quality
```bash
# Format all code
dart format .

# Run static analysis
flutter analyze

# Check formatting issues
dart format --set-exit-if-changed .
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/login_view_model_test.dart

# Generate coverage report
flutter test --coverage
```

### Code Generation

```bash
# Run code generation for auto_route, hive, json_serializable
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation
dart run build_runner watch

# Clean and rebuild
dart run build_runner clean && dart run build_runner build --delete-conflicting-outputs
```

## Architecture

### Initialization Flow
All framework initialization happens in `lib/bootstrap.dart` in this order:
1. Screen orientation lock (portrait only)
2. AppLogger initialization
3. AppConfig initialization (environment-based)
4. Hive + StorageManager initialization
5. NetworkManager initialization with Dio + interceptors
6. App launch with ProviderScope and ScreenUtilInit

### State Management
Uses **Riverpod** (flutter_riverpod ^2.4.9):
- Provider pattern: `final someProvider = StateNotifierProvider<SomeViewModel, SomeState>(...)`
- ViewModels extend `StateNotifier<State>` and are located in `features/*/view_model/`
- State classes are immutable with `copyWith()` methods

### Routing

Based on **AutoRoute** (^9.3.0+1):
- Route definitions in `lib/core/router/app_router.dart` using `@AutoRouterConfig()`
- Pages use `@RoutePage()` annotation for automatic route generation
- Type-safe navigation with generated route classes (SplashRoute, LoginRoute, HomeRoute)
- Navigation via `context.router`:
  - `context.router.push(const HomeRoute())` for navigation
  - `context.router.replace(const LoginRoute())` for replacement
  - `context.router.pop()` for back navigation
- Auth guard: `AuthGuard` class checks `StorageManager.isLoggedIn()` and redirects unauthorized users
- **Important**: After adding/modifying routes, run `dart run build_runner build --delete-conflicting-outputs`

### Network Layer

`NetworkManager` (lib/core/network/network_manager.dart) wraps Dio:
- Static methods: `NetworkManager.get/post/put/delete()`
- Base URL from `AppConfig` (dev vs prod)
- Interceptors: `AuthInterceptor` (adds token), `ErrorInterceptor` (handles errors), `PrettyDioLogger` (debug only)
- All network calls should use this manager, NOT raw Dio instances

### Storage Layer

`StorageManager` (lib/core/storage/storage_manager.dart) provides dual storage:
- **SharedPreferences**: For simple key-value (tokens, primitives) - `saveToken()`, `getToken()`, `isLoggedIn()`
- **Hive**: For complex objects - `saveUserInfo()`, `getUserInfo()`, `saveSettings()`
- Never access SharedPreferences or Hive directly - always use StorageManager

### Logging
`AppLogger` (lib/core/log/app_logger.dart):
- Methods: `AppLogger.debug/info/warning/error()`
- Only logs in debug mode (controlled by AppConfig)
- Use for network requests, authentication flows, errors

## Project Structure

```
lib/
├── bootstrap.dart              # Framework initialization entry
├── main.dart                   # App entry (calls bootstrap)
├── app.dart                    # Root widget with MaterialApp.router
├── core/                       # Core infrastructure
│   ├── config/                 # AppConfig (environment, base URLs)
│   ├── network/                # NetworkManager + interceptors
│   ├── storage/                # StorageManager (Hive + SharedPrefs)
│   ├── router/                 # AppRouter + AppNavigator
│   └── log/                    # AppLogger
├── common/                     # Shared utilities
│   ├── widgets/                # Reusable UI (AppButton, etc.)
│   ├── utils/                  # Utilities (date, string, toast)
│   └── themes/                 # AppTheme (dark/light)
├── features/                   # Feature modules (by page)
│   ├── splash/
│   ├── login/
│   │   ├── view/              # LoginPage
│   │   └── view_model/        # LoginViewModel + LoginState
│   └── home/
└── l10n/                      # Internationalization
```

## Code Standards (from CONTRIBUTING.md)

### Naming Conventions
- **Files/directories**: lowercase_with_underscores (singular form for dirs)
- **Classes**: UpperCamelCase with suffixes (Page, View, Dialog, ViewModel, Service, Manager)
- **Variables/methods**: lowerCamelCase, private start with `_`
- **Constants**: UPPER_SNAKE_CASE
- **Providers**: end with "Provider" (e.g., `loginViewModelProvider`)

### Documentation
Document public APIs with triple-slash comments including:
- Class/method description
- Parameter descriptions with `[paramName]`
- Return value and exceptions
- Usage example in code blocks when helpful

### Testing Requirements
- Core business logic: ≥80% coverage
- Common widgets: ≥70% coverage
- Utilities: ≥90% coverage

### Git Workflow
- Branch strategy: Git Flow (main, develop, feature/*, bugfix/*, hotfix/*)
- Commit format: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`)
- Always create PRs to `develop` branch (not main)

## Key Implementation Patterns

### Adding a New Feature Page

1. Create module under `lib/features/<feature_name>/`
2. Structure: `view/` (pages), `view_model/` (state management), optionally `data/`, `domain/`
3. Add `@RoutePage()` annotation to page class:
   ```dart
   @RoutePage()
   class UserProfilePage extends ConsumerStatefulWidget {
     const UserProfilePage({super.key});
     // ...
   }
   ```
4. Define state class with `copyWith()` method
5. Create ViewModel extending `StateNotifier<YourState>`
6. Create Provider: `final yourProvider = StateNotifierProvider<YourViewModel, YourState>(...)`
7. Add route to `lib/core/router/app_router.dart`:
   ```dart
   AutoRoute(page: UserProfileRoute.page)
   ```
8. Run code generation: `dart run build_runner build --delete-conflicting-outputs`
9. Navigate using: `context.router.push(const UserProfileRoute())`

### Making Network Requests
```dart
// In ViewModel
final response = await NetworkManager.post('/api/endpoint', data: {...});
if (response.statusCode == 200) {
  final data = response.data;
  // Process data
}
```

### Managing User Authentication

- Login: Call API → `StorageManager.saveToken(token)` → `StorageManager.saveUserInfo(info)` → `context.router.replace(const HomeRoute())`
- Logout: Clear storage → redirect:
  ```dart
  await StorageManager.clearToken();
  await StorageManager.clearUserInfo();
  context.router.replace(const LoginRoute());
  ```
- Check auth: `await StorageManager.isLoggedIn()`
- Auth guard automatically redirects unauthenticated users to login page

### Current Test Login Credentials
- Username: `admin`
- Password: `123456`

## Dependencies

**State**: flutter_riverpod
**Routing**: auto_route (with auto_route_generator)
**Network**: dio, pretty_dio_logger
**Storage**: shared_preferences, hive, hive_flutter
**UI**: flutter_screenutil (375x812 design)
**Utils**: logger, fluttertoast
**i18n**: flutter_localizations, intl
**Code gen**: auto_route_generator, build_runner, hive_generator, json_serializable
