# UniMates Implementation Guide - Phase by Phase

## 📖 Overview

This document provides step-by-step implementation instructions for building the UniMates mobile app. It covers all modules with code examples and best practices.

---

## ✅ Completed Phase

### Phase 1: Authentication & Foundation
- ✅ Firebase Authentication setup
- ✅ Email/Password login & signup
- ✅ Google Sign-In integration
- ✅ User verification system
- ✅ Home screen with bottom navigation

**Files:**
- `lib/screens/auth.dart` - Full authentication UI
- `lib/screens/home.dart` - Home screen placeholder
- `lib/main.dart` - App initialization with auth state

---

## 🔄 Phase 2: Community Module (NEXT)

### Objectives
- Create posts with text and images
- View community feed in real-time
- Like and comment on posts
- View event announcements
- Share experiences with other students

### Data Structures Already Created
- `Post` model - represents a community post
- `Comment` model - represents post comments
- Mock data in `assets/data/mock_posts.json`

### Files to Create

#### 1. `lib/screens/community/community_feed.dart`
**Purpose:** Main community feed screen

**Features:**
- Display list of posts from all students
- Pull-to-refresh functionality
- Pagination (load more on scroll)
- Create post button
- Like/comment buttons

**Code Structure:**
```dart
class CommunityFeedScreen extends StatefulWidget {
  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final mockApi = MockApiService();
  List<Post> posts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => isLoading = true);
    final loadedPosts = await mockApi.getPosts();
    setState(() {
      posts = loadedPosts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community')),
      body: // RefreshIndicator with ListView of PostCard widgets
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

#### 2. `lib/widgets/post_card.dart`
**Purpose:** Reusable widget for displaying individual posts

**Shows:**
- Author info (name, avatar)
- Post content
- Images (if any)
- Timestamps
- Like button with count
- Comment button with count

```dart
class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info row
          // Content section
          // Images if any
          // Like and comment buttons
        ],
      ),
    );
  }
}
```

#### 3. `lib/screens/community/create_post.dart`
**Purpose:** Screen for creating new posts

**Features:**
- Text input for post content
- Image picker/upload
- Submit button
- Preview before posting

```dart
class CreatePostScreen extends StatefulWidget {
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  List<String> _selectedImages = [];

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user_id',
        authorName: 'Current User',
        content: _content,
        imageUrls: _selectedImages,
        likes: 0,
        comments: 0,
        createdAt: DateTime.now(),
      );

      // Save to backend
      final success = await MockApiService().createPost(post);
      
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Text field
            // Image picker
            // Submit button
          ],
        ),
      ),
    );
  }
}
```

#### 4. `lib/screens/community/post_detail.dart`
**Purpose:** Show post with all comments

**Features:**
- Full post display
- All comments section
- Add comment input
- Comment list

### Implementation Steps

**Step 1:** Create the community feed screen with mock data
**Step 2:** Create the post card widget (reusable)
**Step 3:** Implement create post functionality
**Step 4:** Add comment system
**Step 5:** Add like/unlike functionality

---

## 🛍️ Phase 3: Marketplace Module

### Objectives
- List items for sale/borrow/exchange
- Search and filter items by category and price
- View item details
- Message seller
- Add items to wishlist

### Data Structures
- `MarketplaceItem` model
- `ListingType` enum (buy, sell, borrow, exchange)
- Mock data in `assets/data/mock_items.json`

### Files to Create

#### 1. `lib/screens/marketplace/marketplace_home.dart`
**Purpose:** Main marketplace home with item listings

#### 2. `lib/screens/marketplace/marketplace_search.dart`
**Purpose:** Search and filter interface

#### 3. `lib/screens/marketplace/item_detail.dart`
**Purpose:** Full item details with seller info

#### 4. `lib/screens/marketplace/create_listing.dart`
**Purpose:** Form to create new marketplace listing

### Key Features
- Grid/list view of items
- Filters (category, price, type)
- Search functionality
- Item details with images
- Seller profile
- Message seller button

---

## 💬 Phase 4: Messaging Module

### Objectives
- One-to-one messaging
- Real-time conversation updates
- Message history
- Notifications for new messages

### Data Structures
- `Conversation` model
- `Message` model

### Files to Create

#### 1. `lib/screens/messaging/messages_list.dart`
**Purpose:** List of all conversations

#### 2. `lib/screens/messaging/chat_screen.dart`
**Purpose:** Individual chat interface

#### 3. `lib/widgets/message_bubble.dart`
**Purpose:** Reusable message display widget

### Key Features
- Conversation list with unread badges
- Real-time message updates
- Timestamps
- Read receipts
- Message input field

---

## 📍 Phase 5: Lost & Found Module

### Objectives
- Report lost items
- Report found items
- Search lost/found items
- Contact finder/reporter

### Data Structures
- `LostFoundItem` model
- `LostFoundType` enum (lost, found)

### Files to Create

#### 1. `lib/screens/lost_found/lost_found_home.dart`
**Purpose:** Lost & found items list

#### 2. `lib/screens/lost_found/report_item.dart`
**Purpose:** Form to report lost/found item

#### 3. `lib/screens/lost_found/item_detail.dart`
**Purpose:** Item details and contact info

---

## 👤 Phase 6: User Profile

### Objectives
- Display user profile info
- Show user's posts and listings
- Edit profile information
- View settings and preferences

### Files to Create

#### 1. `lib/screens/profile/profile_screen.dart`
**Purpose:** User profile display

#### 2. `lib/screens/profile/edit_profile.dart`
**Purpose:** Edit profile information

#### 3. `lib/screens/profile/my_posts.dart`
**Purpose:** Show user's posts

#### 4. `lib/screens/profile/my_listings.dart`
**Purpose:** Show user's marketplace listings

---

## 🎯 Implementation Best Practices

### 1. **State Management**
Use Provider for state management:
```dart
// Create provider for each module
final communityProvider = FutureProvider<List<Post>>((ref) async {
  return await MockApiService().getPosts();
});
```

### 2. **Error Handling**
Always handle errors gracefully:
```dart
try {
  final data = await mockApi.getData();
} on Exception catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

### 3. **Loading States**
Show loading indicators:
```dart
if (isLoading) {
  return Center(child: CircularProgressIndicator());
}
```

### 4. **Image Handling**
Optimize image loading:
```dart
// Use cached network image
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 5. **Validation**
Always validate user input:
```dart
validator: (value) {
  if (value?.isEmpty ?? true) {
    return 'This field cannot be empty';
  }
  return null;
}
```

---

## 📊 Database Integration (When Backend Ready)

### API Endpoints Required

```
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/verify-email

GET    /api/posts?page=0&limit=10
POST   /api/posts
POST   /api/posts/{id}/like
POST   /api/posts/{id}/comment

GET    /api/marketplace?category=&type=&minPrice=&maxPrice=
POST   /api/marketplace
GET    /api/marketplace/{id}

GET    /api/conversations
GET    /api/messages/{conversationId}
POST   /api/messages

GET    /api/lost-found?type=lost|found
POST   /api/lost-found
PATCH  /api/lost-found/{id}/resolve
```

### Migration Strategy
1. Replace `MockApiService` calls with real API calls
2. Keep same model structures
3. Update error handling for real API errors
4. Add real authentication tokens

---

## 🧪 Testing Checklist

### Community Module
- [ ] Posts load correctly
- [ ] Can create new post
- [ ] Can like/unlike post
- [ ] Can add comment
- [ ] Can view event posts
- [ ] Pagination works

### Marketplace Module
- [ ] Items load correctly
- [ ] Search works
- [ ] Filters work (category, price, type)
- [ ] Can create listing
- [ ] Can message seller
- [ ] Can add to wishlist

### Messaging Module
- [ ] Conversations load
- [ ] Can send message
- [ ] Messages appear in real-time
- [ ] Unread badges show correctly
- [ ] Can start new conversation

### Lost & Found Module
- [ ] Can report lost item
- [ ] Can report found item
- [ ] Can search items
- [ ] Can contact reporter

---

## 🚀 Development Timeline

**Week 2-3:** Community Module (Feed, Posts, Comments)  
**Week 4-5:** Marketplace Module (Items, Search, Details)  
**Week 6:** Messaging Module (Conversations, Chat)  
**Week 7:** Lost & Found Module  
**Week 8:** Profile & Settings  
**Week 9-10:** Integration & Testing  
**Week 11-12:** Documentation & Backend Integration  

---

## 📱 Testing on Different Devices

Always test on:
- Small phones (3.5" - 4")
- Medium phones (5" - 5.5")
- Large phones (6" - 6.7")
- Tablets (7" - 10")

Use Flutter's built-in device preview:
```bash
flutter run --device-id=chrome  # Web preview
flutter devices                 # List available devices
```

---

## 🔐 Security Reminders

- Never store passwords in local storage
- Use HTTPS for all API calls
- Validate all user inputs
- Use Firebase security rules
- Don't expose API keys
- Implement proper authentication tokens
- Use encrypted storage for sensitive data

---

## 📝 Code Documentation

When writing code, include:
- Class documentation
- Method documentation
- Parameter descriptions
- Return value descriptions
- Example usage

```dart
/// Loads community posts from the backend
/// 
/// [page] - Zero-based page number for pagination
/// [pageSize] - Number of posts per page
/// 
/// Returns a list of [Post] objects, sorted by creation date (newest first)
/// 
/// Throws [Exception] if the API call fails
/// 
/// Example:
/// ```dart
/// final posts = await mockApi.getPosts(page: 0, pageSize: 10);
/// ```
Future<List<Post>> getPosts({int page = 0, int pageSize = 10}) async {
  // Implementation
}
```

---

## ✨ Next Action Items

1. ✅ **Done:** Authentication (Phases 1)
2. **Next:** Create Community Module (Phase 2)
3. Create models and mock data ✅
4. Build UI screens
5. Implement business logic
6. Add state management
7. Test thoroughly

**Ready to start Phase 2? Follow the Community Module section above!**
