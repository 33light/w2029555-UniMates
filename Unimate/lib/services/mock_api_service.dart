import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:unimates/models/app_models.dart';

/// Mock API Service
/// Provides temporary mock data from JSON files
/// Will be replaced with real API calls once backend is ready

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();

  factory MockApiService() {
    return _instance;
  }

  MockApiService._internal();

  static MockApiService get instance => _instance;

  // In-memory cache for posts created during the session
  final List<Post> _cachedPosts = [];
  bool _postsLoaded = false;

  // =====================
  // Community API Methods
  // =====================

  /// Get all posts (with pagination)
  Future<List<Post>> getPosts({int page = 0, int pageSize = 10}) async {
    try {
      // Load from JSON only once, then use cached data
      if (!_postsLoaded) {
        final String jsonString =
            await rootBundle.loadString('assets/data/mock_posts.json');
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        final List<dynamic> postsList = jsonData['posts'] ?? [];

        _cachedPosts.addAll(postsList.map((p) => Post.fromJson(p)));
        _postsLoaded = true;
      }

      // Sort by creation date (newest first)
      _cachedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Simulate pagination
      final startIndex = page * pageSize;
      final endIndex = (page + 1) * pageSize;
      if (startIndex >= _cachedPosts.length) return [];

      return _cachedPosts.sublist(startIndex,
          endIndex > _cachedPosts.length ? _cachedPosts.length : endIndex);
    } catch (e) {
      debugPrint('Error loading posts: $e');
      return [];
    }
  }

  /// Get single post with comments
  Future<Post?> getPost(String postId) async {
    try {
      final posts = await getPosts(pageSize: 100);
      try {
        return posts.firstWhere((post) => post.id == postId);
      } on StateError {
        return null;
      }
    } catch (e) {
      debugPrint('Error loading post: $e');
      return null;
    }
  }

  /// Get comments for a post
  Future<List<Comment>> getComments(String postId) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/mock_posts.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final List<dynamic> commentsList = jsonData['comments'] ?? [];

      final comments = commentsList
          .where((c) => c['postId'] == postId)
          .map((c) => Comment.fromJson(c))
          .toList();

      return comments;
    } catch (e) {
      debugPrint('Error loading comments: $e');
      return [];
    }
  }

  /// Create a new post
  Future<bool> createPost({
    required String title,
    required String content,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Create new post object
      final newPost = Post(
        id: 'post_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        content: content,
        author: UniMatesUser(
          id: 'current_user',
          name: 'You',
          username: 'your_username',
          email: 'user@example.com',
          university: 'Your University',
          isVerified: false,
          joinDate: DateTime.now(),
        ),
        createdAt: DateTime.now(),
        likesCount: 0,
        commentsCount: 0,
        isLikedByCurrentUser: false,
      );

      // Add to cached posts
      _cachedPosts.insert(0, newPost);

      debugPrint('Post created: title=$title, id=${newPost.id}');
      return true;
    } catch (e) {
      debugPrint('Error creating post: $e');
      return false;
    }
  }

  /// Like/Unlike a post
  Future<bool> togglePostLike(String postId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      debugPrint('Post like toggled: $postId');
      return true;
    } catch (e) {
      debugPrint('Error toggling like: $e');
      return false;
    }
  }

  /// Add comment to post
  Future<bool> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      debugPrint('Comment added to post: $postId');
      return true;
    } catch (e) {
      debugPrint('Error adding comment: $e');
      return false;
    }
  }

  // =====================
  // Marketplace API Methods
  // =====================

  /// Get all marketplace items (with filtering)
  Future<List<MarketplaceItem>> getMarketplaceItems({
    String? category,
    ListingType? type,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
    int page = 0,
    int pageSize = 10,
  }) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/mock_items.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final List<dynamic> itemsList = jsonData['items'] ?? [];

      var items =
          itemsList.map((i) => MarketplaceItem.fromJson(i)).toList();

      // Apply filters
      if (category != null && category.isNotEmpty) {
        items = items.where((item) => item.category == category).toList();
      }

      if (type != null) {
        items = items.where((item) => item.type == type).toList();
      }

      if (minPrice != null) {
        items = items.where((item) => item.price == null || item.price! >= minPrice).toList();
      }

      if (maxPrice != null) {
        items = items.where((item) => item.price == null || item.price! <= maxPrice).toList();
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        items = items
            .where((item) =>
                item.title.toLowerCase().contains(query) ||
                item.description.toLowerCase().contains(query))
            .toList();
      }

      // Sort by creation date (newest first)
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Simulate pagination
      final startIndex = page * pageSize;
      final endIndex = (page + 1) * pageSize;
      if (startIndex >= items.length) return [];

      return items.sublist(startIndex,
          endIndex > items.length ? items.length : endIndex);
    } catch (e) {
      debugPrint('Error loading marketplace items: $e');
      return [];
    }
  }

  /// Get single marketplace item
  Future<MarketplaceItem?> getMarketplaceItem(String itemId) async {
    try {
      final items = await getMarketplaceItems(pageSize: 100);
      return items.firstWhere(
        (item) => item.id == itemId,
        orElse: () => MarketplaceItem(
          id: '',
          userId: '',
          sellerName: '',
          title: '',
          description: '',
          imageUrls: [],
          category: '',
          type: ListingType.sell,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      debugPrint('Error loading item: $e');
      return null;
    }
  }

  /// Create marketplace listing
  Future<bool> createMarketplaceItem(MarketplaceItem item) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      debugPrint('Item created: ${item.id}');
      return true;
    } catch (e) {
      debugPrint('Error creating item: $e');
      return false;
    }
  }

  /// Mark item as sold
  Future<bool> markItemAsSold(String itemId) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      debugPrint('Item marked as sold: $itemId');
      return true;
    } catch (e) {
      debugPrint('Error marking item as sold: $e');
      return false;
    }
  }

  // =====================
  // Messaging API Methods
  // =====================

  /// Get all conversations for user
  Future<List<Conversation>> getConversations(String userId) async {
    try {
      // Mock data
      await Future.delayed(Duration(milliseconds: 300));
      return [
        Conversation(
          id: 'conv_1',
          userId1: userId,
          userId2: 'user_2',
          user1Name: 'Me',
          user2Name: 'Ali Ahmed',
          user2Image: 'https://i.pravatar.cc/150?img=1',
          lastMessage: 'Are you interested in the laptop?',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
          unreadCount: 0,
        ),
        Conversation(
          id: 'conv_2',
          userId1: userId,
          userId2: 'user_3',
          user1Name: 'Me',
          user2Name: 'Fatima Khan',
          user2Image: 'https://i.pravatar.cc/150?img=2',
          lastMessage: 'Great! Let me know when you can meet',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 5)),
          unreadCount: 1,
        ),
      ];
    } catch (e) {
      debugPrint('Error loading conversations: $e');
      return [];
    }
  }

  /// Get messages in conversation
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      // Mock data
      await Future.delayed(Duration(milliseconds: 400));
      return [
        Message(
          id: 'msg_1',
          conversationId: conversationId,
          senderId: 'user_2',
          senderName: 'Ali Ahmed',
          content: 'Hi, is the laptop still available?',
          timestamp: DateTime.now().subtract(Duration(hours: 3)),
          isRead: true,
        ),
        Message(
          id: 'msg_2',
          conversationId: conversationId,
          senderId: 'current_user',
          senderName: 'You',
          content: 'Yes, it is! Interested?',
          timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 50)),
          isRead: true,
        ),
        Message(
          id: 'msg_3',
          conversationId: conversationId,
          senderId: 'user_2',
          senderName: 'Ali Ahmed',
          content: 'Are you interested in the laptop?',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          isRead: true,
        ),
      ];
    } catch (e) {
      debugPrint('Error loading messages: $e');
      return [];
    }
  }

  /// Send message
  Future<bool> sendMessage(Message message) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      debugPrint('Message sent: ${message.id}');
      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  // =====================
  // Lost & Found API Methods
  // =====================

  /// Get all lost & found items
  Future<List<LostFoundItem>> getLostFoundItems({
    LostFoundType? type,
    bool? showResolved,
    int page = 0,
    int pageSize = 10,
  }) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/mock_lost_found.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final List<dynamic> itemsList = jsonData['items'] ?? [];

      var items =
          itemsList.map((i) => LostFoundItem.fromJson(i)).toList();

      // Apply filters
      if (type != null) {
        items = items.where((item) => item.type == type).toList();
      }

      if (showResolved == false) {
        items = items.where((item) => !item.isResolved).toList();
      }

      // Sort by date (newest first)
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Simulate pagination
      final startIndex = page * pageSize;
      final endIndex = (page + 1) * pageSize;
      if (startIndex >= items.length) return [];

      return items.sublist(startIndex,
          endIndex > items.length ? items.length : endIndex);
    } catch (e) {
      debugPrint('Error loading lost & found items: $e');
      return [];
    }
  }

  /// Report lost/found item
  Future<bool> reportLostFoundItem(LostFoundItem item) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      debugPrint('Item reported: ${item.id}');
      return true;
    } catch (e) {
      debugPrint('Error reporting item: $e');
      return false;
    }
  }

  /// Mark item as resolved
  Future<bool> markLostFoundAsResolved(String itemId, String? resolvedById) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      debugPrint('Item marked as resolved: $itemId');
      return true;
    } catch (e) {
      debugPrint('Error marking as resolved: $e');
      return false;
    }
  }

  // =====================
  // Utility Methods
  // =====================

  /// Get categories for marketplace
  Future<List<String>> getCategories() async {
    return [
      'Electronics',
      'Books',
      'Furniture',
      'Clothing',
      'Sports',
      'Stationery',
      'Other',
    ];
  }

  /// Search across all modules
  Future<Map<String, dynamic>> globalSearch(String query) async {
    try {
      await Future.delayed(Duration(milliseconds: 600));

      final posts = await getPosts(pageSize: 5);
      final filteredPosts = posts
          .where((p) =>
              p.content.toLowerCase().contains(query.toLowerCase()) ||
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.author.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      final items =
          await getMarketplaceItems(searchQuery: query, pageSize: 5);

      final lostFound = await getLostFoundItems(pageSize: 5);
      final filteredLostFound = lostFound
          .where((item) =>
              item.title.toLowerCase().contains(query.toLowerCase()) ||
              item.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return {
        'posts': filteredPosts,
        'items': items,
        'lostFound': filteredLostFound,
      };
    } catch (e) {
      debugPrint('Error in global search: $e');
      return {};
    }
  }
}
