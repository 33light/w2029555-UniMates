# Phase 2: Quick Reference - Community Module

## File Locations

| Component | Path | Lines |
|-----------|------|-------|
| Post Card Widget | `lib/widgets/post_card.dart` | 158 |
| Community Feed | `lib/screens/community/community_feed.dart` | 177 |
| Create Post Screen | `lib/screens/community/create_post.dart` | 130 |
| Post Detail Screen | `lib/screens/community/post_detail.dart` | 325 |
| Home Screen (Nav) | `lib/screens/home_screen.dart` | 72 |
| Profile Screen | `lib/screens/profile_screen.dart` | 89 |
| Data Models | `lib/models/app_models.dart` | Updated |
| Mock API Service | `lib/services/mock_api_service.dart` | Updated |

## Key Class Structure

### Post Card Widget
```dart
PostCard(
  post: post,
  onTap: () => navigate to detail,
  onLike: (postId) => toggle like,
  onComment: (postId) => go to detail,
)
```

### Community Feed Screen
- **Entry Point:** CommunityFeedScreen()
- **State Management:** FutureBuilder with posts from MockApiService
- **Key Methods:**
  - `_refreshPosts()` - Reload posts
  - `_navigateToCreatePost()` - Open creation screen
  - `_navigateToPostDetail()` - View post details
  - `_handleLike()` - Toggle post like
  - `_handleComment()` - Navigate to post comments

### Create Post Screen
- **Entry Point:** CreatePostScreen()
- **Form Fields:** 
  - `title` (5-100 chars)
  - `content` (10-2000 chars)
- **Validation:** Built-in form validation with error messages
- **Submit:** `_submitPost()` calls MockApiService.createPost()

### Post Detail Screen
- **Entry Point:** PostDetailScreen(post: post)
- **Sections:**
  - Post header with author info
  - Full post content
  - Post statistics
  - Comments list
  - Comment input field
- **Comment Input:** Real-time character counter and submit button

### Home Screen
- **Entry Point:** HomeScreen()
- **Bottom Navigation:** 5 tabs (Community, Marketplace, Messaging, Lost&Found, Profile)
- **Screen Array:** `_screens = [CommunityFeedScreen(), ...]`
- **State:** `_selectedIndex` tracks current tab

### Profile Screen
- **Entry Point:** ProfileScreen()
- **Features:**
  - User avatar from Firebase photoURL
  - User email display
  - Menu items (Edit Profile, Settings, Help)
  - **Logout button** - Calls FirebaseAuth.instance.signOut()

## Model Changes

### Post Model
```dart
class Post {
  final String id;
  final String title;           // NEW
  final String content;
  final UniMatesUser author;    // CHANGED from authorName
  final List<String> imageUrls;
  final int likesCount;         // CHANGED from likes
  final int commentsCount;      // CHANGED from comments
  final DateTime createdAt;
  final bool? isLikedByCurrentUser;
}
```

### UniMatesUser Model
```dart
class UniMatesUser {
  final String id;
  final String name;
  final String username;        // NEW
  final String email;
  final String? profileImageUrl; // CHANGED from photoUrl
  final String university;
  final bool isVerified;
  final DateTime joinDate;
  final String? bio;
  final double rating;
  final int reviewsCount;
}
```

## Mock API Service Updates

### New Methods
```dart
// Singleton access
static MockApiService get instance => _instance;

// Create post with title and content
Future<bool> createPost({
  required String title,
  required String content,
})

// Toggle like with just post ID
Future<bool> togglePostLike(String postId)

// Add comment with post ID and content
Future<bool> addComment({
  required String postId,
  required String content,
})
```

## Data Flow

### Viewing Feed
```
CommunityFeedScreen
  ↓
FutureBuilder
  ↓
MockApiService.getPosts()
  ↓
Load from mock_posts.json
  ↓
Build PostCard widgets
  ↓
User taps post → PostDetailScreen
```

### Creating Post
```
FAB on CommunityFeedScreen
  ↓
CreatePostScreen
  ↓
User fills form
  ↓
Validation checks
  ↓
_submitPost()
  ↓
MockApiService.createPost(title, content)
  ↓
Navigate back & refresh feed
```

### Adding Comment
```
PostDetailScreen
  ↓
User types in comment field
  ↓
Tap send button
  ↓
_submitComment()
  ↓
MockApiService.addComment(postId, content)
  ↓
Refresh comments list
```

## UI Features

### Community Feed
- Post cards with author avatar
- Like/Comment/View buttons
- Pull-to-refresh
- Scroll pagination ready
- Empty state message
- Error state with retry

### Create Post
- Title field with validation feedback
- Content field with character counter
- Submit/Cancel buttons
- Loading indicator on submit
- Error dialogs

### Post Detail
- Full author info header
- Complete post content
- Stats showing likes and comments
- Comments list with author avatars
- Comment input with send button
- Timestamps on all content

### Navigation
- 5-tab bottom bar
- Active tab highlighting
- Smooth tab transitions
- Back button handling
- FABs where appropriate

## Testing Scenarios

### Feed Loading
1. App starts
2. Navigate to Community tab
3. Feed loads and displays posts
4. Pull-down to refresh
5. Posts reload with fresh data

### Post Creation
1. Tap FAB on feed
2. Fill in title (5+ chars)
3. Fill in content (10+ chars)
4. Tap Post button
5. Success message appears
6. Navigate back to feed
7. Feed refreshes

### Comments
1. Tap "View" on any post
2. See post details
3. Scroll to comments section
4. Type comment in input field
5. Tap send button
6. Comment appears in list
7. Comment shows author and timestamp

### Navigation
1. Start in Community tab
2. Tap Marketplace tab → shows "Coming Phase 3"
3. Tap Messaging tab → shows "Coming Phase 4"
4. Tap Lost & Found tab → shows "Coming Phase 5"
5. Tap Profile tab → shows user info and logout
6. Tap logout → returns to auth screen

## Dependencies Added

```yaml
intl: ^0.19.0
```

Used for date formatting in:
- Post card date display
- Post detail timestamps
- Comment timestamps

## Error Handling

### Feed Loading Errors
- Show error icon and message
- Provide retry button
- Empty state if no posts

### Post Creation Errors
- Show validation errors in real-time
- Display error dialog on submission failure
- Allow user to retry

### Comment Submission Errors
- Show snackbar with error message
- Allow user to retry
- Don't clear comment text on error

### Navigation Errors
- Null safety checks with `if (mounted)`
- Null-aware operators
- Graceful fallbacks

## Production Readiness

✅ No compilation errors
✅ No linter warnings
✅ Proper error handling
✅ Loading states implemented
✅ Form validation working
✅ Null safety throughout
✅ Proper state management
✅ Clean code structure

## Next Phase Preview

The Marketplace module will follow a similar pattern:
- MarketplaceScreen (main feed)
- MarketplaceItemCard (reusable widget)
- CreateListing screen
- ItemDetail screen
- Same bottom nav integration

---

**Ready to deploy Phase 2 to testing! 🚀**
