# UniMates Flutter App - AI Agent Instructions

## Project Overview
UniMates is a **Flutter student community platform** (Phase 2 complete) combining social engagement with peer-to-peer marketplace. Currently implements Phase 2 (Community module with posts, comments, likes). Architecture uses Firebase Auth + Mock API (JSON) with planned transitions to Firestore.

**Status:** Phase 1 (Auth) ✅ | Phase 2 (Community) ✅ | Phase 3+ (Marketplace, Messaging, Lost&Found) 🚧

---

## Architecture & Critical Data Flow

### Layered Architecture
```
Screens + Widgets (Presentation)
  ↓
Services (Business Logic)
  ↓
Models (Data)
  ↓
Foundation: theme/, constants/, utils/
```

**Key Pattern:** All data flows through `MockApiService` (singleton). UI uses `FutureBuilder<T>` exclusively for async data—NO `setState()` for data updates.

### Data Models in `lib/models/app_models.dart`
- `UniMatesUser` - User profile (id, name, username, email, university, rating)
- `Post` - Community posts with author, likesCount, commentsCount
- `Comment` - Post comments with author reference
- `LostFoundItem`, `Marketplace` models exist but are Phase 3 placeholders

**JSON → Model Flow:**
```dart
// Models have fromJson() + toJson() for serialization
Post.fromJson(json) → handles both nested + flattened author data
```

### Service Layer (`lib/services/mock_api_service.dart`)
- Singleton pattern: `MockApiService.instance`
- Methods: `getPosts()`, `getPost(id)`, `getComments(id)`, `createPost()`, `togglePostLike()`, `addComment()`
- **Important:** Loads from `assets/data/mock_posts.json` → sorts by createdAt (newest first) → supports pagination
- Simulates network delays (300-500ms) for realistic UX testing

---

## Critical Workflows & Build Commands

### Development Build & Run
```bash
# Navigate to workspace root: e:\Study\Coding_Projects\Flutter_Projects\Unimate

# Essential setup
flutter doctor          # Verify Flutter 3.8.1+, Android SDK 34+
flutter pub get         # Install dependencies (firebase_core, firebase_auth, google_sign_in)

# Run app
flutter run             # Hot reload with 'r', hot restart with 'R'
flutter run -v          # Verbose logging (see all build steps)
flutter run --profile   # With profiler for performance debugging

# Build artifacts
flutter build apk --release   # Production APK
flutter build apk --debug     # Debug APK (faster)
```

### Test Strategy
- 15 test scenarios documented in `docs/TESTING.md` (manual, UI-focused)
- No automated test suite currently—focus on `flutter run` validation
- Test new features by: create mock data in `assets/data/` + verify in FutureBuilder UI

### Hot Reload Caveats
- Hot reload **preserves app state** (user login stays)
- Hot reload **does NOT reflect** changes to `assets/` or `pubspec.yaml`
- Use `flutter run` full rebuild if assets/pubspec change

---

## Project-Specific Conventions & Patterns

### Naming & File Organization
- **Directories:** `snake_case` (e.g., `community/`, `lost_found/`)
- **Files:** `snake_case.dart` (e.g., `community_feed.dart`, `mock_api_service.dart`)
- **Classes:** `PascalCase` (e.g., `CommunityFeed`, `PostCard`)
- **Constants:** `camelCase` in `lib/constants/app_constants.dart`

### UI State Management Pattern
**DO NOT use `setState()`** for data updates. Use this pattern:
```dart
class CommunityFeedScreen extends StatefulWidget {
  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: MockApiService.instance.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return ListView.builder(itemCount: snapshot.data?.length ?? 0);
      },
    );
  }
}
```

### Asset & Constants Pattern
- Images: `assets/images/` (chatbubble.png registered in pubspec.yaml)
- Mock JSON: `assets/data/mock_posts.json`, `mock_comments.json`, etc.
- Colors/Strings: Centralize in `lib/constants/app_constants.dart` (not hardcoded in UI)
- Theme: Light/dark in `lib/theme/app_theme.dart` using Material Design 3

### Navigation Hierarchy
```
main.dart (Firebase auth check)
  └─ AuthScreen (Phase 1) OR HomeScreen (authenticated)
     └─ BottomNavigationBar (5 tabs)
        ├─ Community Tab → CommunityFeedScreen → PostDetailScreen
        ├─ Marketplace Tab → [Phase 3 placeholder]
        ├─ Messaging Tab → [Phase 4 placeholder]
        ├─ Lost&Found Tab → [Phase 5 placeholder]
        └─ Profile Tab → ProfileScreen
```

---

## Key Files to Understand First

1. [lib/main.dart](lib/main.dart) - Entry point: Firebase init + auth routing via StreamBuilder
2. [lib/models/app_models.dart](lib/models/app_models.dart) - Core data structures with fromJson/toJson
3. [lib/services/mock_api_service.dart](lib/services/mock_api_service.dart) - Singleton business logic layer
4. [lib/screens/home_screen.dart](lib/screens/home_screen.dart) - Navigation hub with BottomNavigationBar
5. [lib/screens/community/community_feed.dart](lib/screens/community/community_feed.dart) - FutureBuilder example
6. [assets/data/mock_posts.json](assets/data/mock_posts.json) - Mock data structure template
7. [pubspec.yaml](pubspec.yaml) - Dependencies: firebase_core, firebase_auth, google_sign_in, intl

---

## Integration Points & Dependencies

### Firebase Integration (Partially Implemented)
- **Auth:** `firebase_auth` handles email/password + Google Sign-In (working)
- **Firestore:** Imported in `firebase_options.dart` but mock API uses JSON instead
- **Migration Path:** Replace `MockApiService` calls with Firestore equivalents when backend ready

### External Dependencies
```yaml
firebase_core: ^4.2.0      # Firebase initialization
firebase_auth: ^6.1.1      # Authentication
google_sign_in: ^6.2.1     # Google OAuth
intl: ^0.19.0             # Internationalization for date formatting
```

### Cross-Component Communication
- **Auth State:** `StreamBuilder<User?>` in main.dart watches `FirebaseAuth.instance.authStateChanges()`
- **Service Access:** All screens use `MockApiService.instance` (singleton)
- **Data Passing:** Navigation via `Navigator.push()` + constructor params (not Provider/Riverpod)

---

## Common Pitfalls & Patterns to Follow

### ❌ Anti-Patterns (Avoid These)
- `setState()` for data updates → use FutureBuilder instead
- Hardcoded strings/colors → centralize in constants
- Navigation with MaterialPageRoute anonymous → use named routes
- Loading mock data in widgets → fetch in services only
- Ignoring asset registration → update pubspec.yaml before using new assets

### ✅ Best Practices in This Codebase
- Model classes with fromJson/toJson for serialization consistency
- Singleton service layer for business logic isolation
- FutureBuilder exclusively for async UI state (clean, consistent)
- Constants file as single source of truth for styling
- Descriptive error messages in debugPrint() for troubleshooting

---

## Adding New Features (Phase 3+ Guidance)

### To Add a New Module (e.g., Marketplace)
1. Create data model in `lib/models/app_models.dart` (add MarketplaceItem class)
2. Add service methods in `lib/services/mock_api_service.dart` (getListings(), createListing())
3. Create screens folder: `lib/screens/marketplace/` with listing_feed.dart, item_detail.dart
4. Add navigation tab in `lib/screens/home_screen.dart` BottomNavigationBar
5. Create mock JSON in `assets/data/mock_listings.json` + register in pubspec.yaml

### To Add a Reusable Widget
1. Create in `lib/widgets/` (e.g., `lib/widgets/user_avatar.dart`)
2. Accept data via constructor (don't fetch data inside widget)
3. Export from central file if shared across modules: `lib/widgets/index.dart`

### Testing a Feature
1. Add test scenario to `docs/TESTING.md` (manual test steps)
2. Build mock JSON in `assets/data/` matching model structure
3. Run `flutter run` + test through UI (FutureBuilder validates data flow)

---

## Documentation Structure
- [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) - Folder hierarchy & design principles
- [docs/PHASE_2_ARCHITECTURE.md](docs/PHASE_2_ARCHITECTURE.md) - Current community module flow
- [docs/UNIMATES_PROJECT_PLAN.md](docs/UNIMATES_PROJECT_PLAN.md) - Full 6-phase roadmap & vision
- [BUILD_AND_RUN.md](BUILD_AND_RUN.md) - Build commands & troubleshooting
- [docs/TESTING.md](docs/TESTING.md) - 15 manual test scenarios

---

## Quick Reference: Core Dependencies in Code

| Concept | Location | Pattern |
|---------|----------|---------|
| Models | `lib/models/app_models.dart` | fromJson/toJson |
| Services | `lib/services/mock_api_service.dart` | MockApiService.instance |
| Screens | `lib/screens/*/` | StatefulWidget + FutureBuilder |
| Widgets | `lib/widgets/` | Stateless/Stateful, data via constructor |
| Theme | `lib/theme/app_theme.dart` | Material Design 3 |
| Constants | `lib/constants/app_constants.dart` | Colors, strings, sizes |
| Utils | `lib/utils/app_utils.dart` | Validation, formatting helpers |

---

## Next Phase Context (Phase 3: Marketplace)

When implementing marketplace features:
- Model: `MarketplaceItem` (seller, price, condition, category, images)
- Service: Methods for listing CRUD, search/filter
- Screens: `marketplace_feed.dart`, `item_detail.dart`, `create_listing.dart`
- Auth: Verified sellers only (extend user model with `isSeller` boolean)
- Messaging: In-app chat for negotiations (Phase 4 dependency)

See [docs/UNIMATES_PROJECT_PLAN.md](docs/UNIMATES_PROJECT_PLAN.md) for complete Phase 3-6 specifications.
