import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/community_models.dart';
import 'moderation_service.dart';

class CommunityService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _messagesCollection = 'community_messages';
  static const String _usersCollection = 'community_users';
  static const String _reactionsCollection = 'message_reactions';

  // Initialize community user if not exists
  static Future<CommunityUser?> initializeCommunityUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final prefs = await SharedPreferences.getInstance();
      final nickname = prefs.getString('user_nickname') ?? 'Anonymous';
      final avatar = prefs.getString('user_avatar') ?? '👤';

      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        // Create new community user
        final communityUser = CommunityUser(
          id: currentUser.uid,
          nickname: nickname,
          avatar: avatar,
          joinedAt: DateTime.now(),
          lastSeen: DateTime.now(),
          isOnline: true,
        );

        await _firestore
            .collection(_usersCollection)
            .doc(currentUser.uid)
            .set(communityUser.toMap());

        return communityUser;
      } else {
        // Update last seen and online status
        final communityUser = CommunityUser.fromMap(userDoc.data()!);
        await updateUserOnlineStatus(true);
        return communityUser;
      }
    } catch (e) {
      print('Error initializing community user: $e');
      return null;
    }
  }

  // Update user online status
  static Future<void> updateUserOnlineStatus(bool isOnline) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      await _firestore.collection(_usersCollection).doc(currentUser.uid).update({
        'isOnline': isOnline,
        'lastSeen': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

  // Send a message to the community
  static Future<bool> sendMessage(String content, {String? replyToId}) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Check user moderation status
      final userStatus = await ModerationService.getUserModerationStatus(currentUser.uid);
      if (userStatus == UserModerationStatus.banned) {
        throw Exception('User is banned from posting');
      }
      if (userStatus == UserModerationStatus.muted) {
        throw Exception('User is temporarily muted');
      }

      // Check user posting behavior
      final canPost = await ModerationService.checkUserBehavior(currentUser.uid);
      if (!canPost) {
        throw Exception('Too many messages sent recently. Please wait before posting again.');
      }

      // Moderate message content
      final moderationResult = ModerationService.moderateMessage(content, currentUser.uid);
      if (!moderationResult.isAllowed) {
        throw Exception('Message violates community guidelines: ${moderationResult.reason}');
      }

      // Check for emergency keywords
      if (ModerationService.detectEmergencyKeywords(content)) {
        // Log emergency detection
        await ModerationService.logModerationAction(
          'emergency_detected',
          currentUser.uid,
          details: {'content': content, 'type': 'community_message'},
        );
        // Still allow the message but flag for immediate review
      }

      final prefs = await SharedPreferences.getInstance();
      final nickname = prefs.getString('user_nickname') ?? 'Anonymous';
      final avatar = prefs.getString('user_avatar') ?? '👤';

      final messageId = const Uuid().v4();
      final message = CommunityMessage(
        id: messageId,
        userId: currentUser.uid,
        userNickname: nickname,
        userAvatar: avatar,
        content: content,
        timestamp: DateTime.now(),
        replyToId: replyToId,
        isModerated: moderationResult.requiresReview,
      );

      await _firestore
          .collection(_messagesCollection)
          .doc(messageId)
          .set(message.toMap());

      // Update user message count
      await _firestore.collection(_usersCollection).doc(currentUser.uid).update({
        'messageCount': FieldValue.increment(1),
        'lastSeen': DateTime.now().toIso8601String(),
      });

      // Log moderation action if flagged
      if (moderationResult.requiresReview) {
        await ModerationService.logModerationAction(
          'message_flagged_for_review',
          currentUser.uid,
          details: {
            'messageId': messageId,
            'reason': moderationResult.reason,
            'flaggedWords': moderationResult.flaggedWords,
          },
        );
      }

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  // Get real-time stream of community messages
  static Stream<List<CommunityMessage>> getMessagesStream() {
    return _firestore
        .collection(_messagesCollection)
        .where('isModerated', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CommunityMessage.fromMap(doc.data()))
          .toList();
    });
  }

  // Get paginated messages for infinite scroll
  static Future<List<CommunityMessage>> getMessages({
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection(_messagesCollection)
          .where('isModerated', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => CommunityMessage.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }

  // Get a specific message by ID (for reply context)
  static Future<CommunityMessage?> getMessageById(String messageId) async {
    try {
      final doc = await _firestore
          .collection(_messagesCollection)
          .doc(messageId)
          .get();

      if (doc.exists) {
        return CommunityMessage.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting message by ID: $e');
      return null;
    }
  }

  // React to a message
  static Future<bool> reactToMessage(String messageId, String reactionType) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final reactionId = '${messageId}_${currentUser.uid}_$reactionType';
      
      // Check if reaction already exists
      final existingReaction = await _firestore
          .collection(_reactionsCollection)
          .doc(reactionId)
          .get();

      if (existingReaction.exists) {
        // Remove reaction if it exists
        await _firestore.collection(_reactionsCollection).doc(reactionId).delete();
        
        // Update message reactions count
        await _firestore.collection(_messagesCollection).doc(messageId).update({
          'reactions': FieldValue.arrayRemove([currentUser.uid])
        });
      } else {
        // Add new reaction
        final reaction = MessageReaction(
          id: reactionId,
          messageId: messageId,
          userId: currentUser.uid,
          type: reactionType,
          timestamp: DateTime.now(),
        );

        await _firestore
            .collection(_reactionsCollection)
            .doc(reactionId)
            .set(reaction.toMap());

        // Update message reactions count
        await _firestore.collection(_messagesCollection).doc(messageId).update({
          'reactions': FieldValue.arrayUnion([currentUser.uid])
        });

        // If it's a helpful reaction, increment user's helpful count
        if (reactionType == 'helpful') {
          final messageDoc = await _firestore
              .collection(_messagesCollection)
              .doc(messageId)
              .get();
          
          if (messageDoc.exists) {
            final message = CommunityMessage.fromMap(messageDoc.data()!);
            await _firestore.collection(_usersCollection).doc(message.userId).update({
              'helpfulCount': FieldValue.increment(1),
            });
          }
        }
      }

      return true;
    } catch (e) {
      print('Error reacting to message: $e');
      return false;
    }
  }

  // Report a message
  static Future<bool> reportMessage(String messageId, String reason) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Mark message as reported
      await _firestore.collection(_messagesCollection).doc(messageId).update({
        'isReported': true,
      });

      // Create report document
      final reportId = const Uuid().v4();
      await _firestore.collection('message_reports').doc(reportId).set({
        'id': reportId,
        'messageId': messageId,
        'reportedBy': currentUser.uid,
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'pending',
      });

      return true;
    } catch (e) {
      print('Error reporting message: $e');
      return false;
    }
  }

  // Get online users count
  static Stream<int> getOnlineUsersCount() {
    return _firestore
        .collection(_usersCollection)
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Get user reactions for a message
  static Future<List<MessageReaction>> getMessageReactions(String messageId) async {
    try {
      final snapshot = await _firestore
          .collection(_reactionsCollection)
          .where('messageId', isEqualTo: messageId)
          .get();

      return snapshot.docs
          .map((doc) => MessageReaction.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting message reactions: $e');
      return [];
    }
  }

  // Delete user's own message
  static Future<bool> deleteMessage(String messageId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final messageDoc = await _firestore
          .collection(_messagesCollection)
          .doc(messageId)
          .get();

      if (messageDoc.exists) {
        final message = CommunityMessage.fromMap(messageDoc.data()!);
        
        // Only allow user to delete their own messages
        if (message.userId == currentUser.uid) {
          await _firestore.collection(_messagesCollection).doc(messageId).delete();
          
          // Also delete associated reactions
          final reactions = await _firestore
              .collection(_reactionsCollection)
              .where('messageId', isEqualTo: messageId)
              .get();
          
          final batch = _firestore.batch();
          for (var doc in reactions.docs) {
            batch.delete(doc.reference);
          }
          await batch.commit();
          
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Error deleting message: $e');
      return false;
    }
  }

  // Get community guidelines
  static Map<String, String> getCommunityGuidelines() {
    final guidelines = ModerationService.getCommunityGuidelines();
    return Map.fromEntries(
      guidelines.map((guideline) => MapEntry(guideline.title, guideline.description))
    );
  }

  // Search messages by content
  static Future<List<CommunityMessage>> searchMessages(String query) async {
    try {
      // Note: Firestore doesn't support full-text search directly
      // This is a basic implementation. For production, consider using Algolia or similar
      final snapshot = await _firestore
          .collection(_messagesCollection)
          .where('isModerated', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .limit(100)
          .get();

      final allMessages = snapshot.docs
          .map((doc) => CommunityMessage.fromMap(doc.data()))
          .toList();

      // Filter messages that contain the query (case-insensitive)
      return allMessages
          .where((message) => 
              message.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching messages: $e');
      return [];
    }
  }
}