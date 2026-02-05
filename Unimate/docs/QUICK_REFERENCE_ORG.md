# 🎯 Quick Reference - Project Organization

## Where to Put What?

| What | Where | Example |
|------|-------|---------|
| **New Screen** | `lib/screens/[module]/` | `lib/screens/community/feed.dart` |
| **Reusable Widget** | `lib/widgets/` or `lib/widgets/[module]/` | `lib/widgets/post_card.dart` |
| **Data Model** | `lib/models/` | `lib/models/app_models.dart` |
| **API/Business Logic** | `lib/services/` | `lib/services/mock_api_service.dart` |
| **Color/String Constant** | `lib/constants/app_constants.dart` | `AppColors.primaryPurple` |
| **Helper Function** | `lib/utils/app_utils.dart` | `ValidationUtils.isValidEmail()` |
| **Theme Config** | `lib/theme/app_theme.dart` | `AppTheme.lightTheme()` |
| **Asset (Image/Font)** | `assets/[type]/` | `assets/images/logo.png` |
| **Test** | `test/` | `test/widget_test.dart` |
| **Documentation** | `docs/` | `docs/PHASE_2.md` |

---

## Core Constants to Use

### Colors
```dart
AppColors.primaryPurple          // #6200EE
AppColors.primaryPurpleDark      // #3700B3
AppColors.secondaryTeal          // #03DAC6
AppColors.error                  // #B00020
AppColors.success                // #4CAF50
```

### Strings
```dart
AppStrings.appName               // "UniMates"
AppStrings.community             // "Community"
AppStrings.createPost            // "Create Post"
AppStrings.loginTitle            // "Welcome Back"
```

### Sizes
```dart
AppSizes.paddingMedium           // 16.0
AppSizes.borderRadiusLarge       // 12.0
AppSizes.iconMedium              // 24.0
AppSizes.avatarLarge             // 64.0
```

---

## Core Utils to Use

### Validation
```dart
ValidationUtils.isValidEmail(email)
ValidationUtils.isValidPassword(password)
ValidationUtils.isValidPostTitle(title)
ValidationUtils.isValidPostContent(content)
```

### Formatting
```dart
StringUtils.formatDate(date)
StringUtils.truncate(text, 50)
StringUtils.formatNumber(1000)
```

### Logging
```dart
AppLogger.debug('message')
AppLogger.info('message')
AppLogger.warning('message')
AppLogger.error('message', error)
```

---

## Theming

### Light Theme
```dart
theme: AppTheme.lightTheme(),
```

### Dark Theme
```dart
darkTheme: AppTheme.darkTheme(),
```

---

## Common Imports

```dart
// Constants & Theme
import 'package:chatter/constants/app_constants.dart';
import 'package:chatter/theme/app_theme.dart';

// Utils
import 'package:chatter/utils/app_utils.dart';

// Models
import 'package:chatter/models/app_models.dart';

// Services
import 'package:chatter/services/mock_api_service.dart';
```

---

## Project Commands

```bash
# Development
flutter run                    # Run app
flutter analyze               # Check code quality
flutter test                  # Run tests

# Building
flutter build apk             # Build Android
flutter build ios             # Build iOS

# Maintenance
flutter clean                 # Clean build artifacts
dart format lib/              # Format code
flutter pub get               # Get dependencies
```

---

## Documentation Files

- `docs/README.md` - Documentation index
- `docs/ORGANIZATION_GUIDE.md` - This structure explained
- `docs/PROJECT_STRUCTURE.md` - Detailed architecture
- `docs/CLEANUP_SUMMARY.md` - What was cleaned
- `docs/PHASE_2.md` - Current phase features
- `docs/TESTING.md` - Test scenarios
- `docs/QUICKSTART.md` - 5-minute setup

---

## Folder Tree Reference

```
lib/
├── main.dart
├── firebase_options.dart
├── constants/
│   └── app_constants.dart      ← Colors, strings, sizes
├── theme/
│   └── app_theme.dart          ← Themes
├── utils/
│   └── app_utils.dart          ← Helpers
├── models/
│   └── app_models.dart         ← Data structures
├── services/
│   └── mock_api_service.dart   ← Business logic
├── screens/
│   ├── auth.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── community/              ← Module
│       ├── community_feed.dart
│       ├── create_post.dart
│       └── post_detail.dart
└── widgets/
    ├── post_card.dart
    └── community/              ← Module
```

---

**Ready to develop? Pick a task and follow this guide! 🚀**
