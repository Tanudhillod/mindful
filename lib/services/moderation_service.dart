import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModerationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Prohibited words and phrases for basic content filtering
  static const List<String> _prohibitedWords = [
    // Self-harm and violence
    'kill yourself', 'kys', 'end your life', 'jump off', 'overdose',
    // Inappropriate content
    'spam', 'advertisement', 'buy now', 'click here',
    // Harassment
    'stupid', 'idiot', 'loser', 'pathetic', 'worthless',
    // Add more based on community needs
  ];

  // Suspicious patterns that might need manual review
  static const List<String> _suspiciousPatterns = [
    // Multiple consecutive messages
    // External links
    'http://', 'https://', 'www.', '.com', '.org',
    // Personal information sharing
    'phone number', 'address', 'email', 'whatsapp',
    // Meeting requests
    'meet me', 'let\'s meet', 'where do you live',
  ];

  // Check if message violates community guidelines
  static ModerationResult moderateMessage(String content, String userId) {
    final lowercaseContent = content.toLowerCase();
    
    // Check for prohibited content
    for (final word in _prohibitedWords) {
      if (lowercaseContent.contains(word)) {
        return ModerationResult(
          isAllowed: false,
          reason: 'Contains prohibited content',
          severity: ModerationSeverity.high,
          flaggedWords: [word],
        );
      }
    }
    
    // Check for suspicious patterns
    final flaggedPatterns = <String>[];
    for (final pattern in _suspiciousPatterns) {
      if (lowercaseContent.contains(pattern)) {
        flaggedPatterns.add(pattern);
      }
    }
    
    if (flaggedPatterns.isNotEmpty) {
      return ModerationResult(
        isAllowed: true, // Allow but flag for review
        reason: 'Contains suspicious patterns',
        severity: ModerationSeverity.medium,
        flaggedWords: flaggedPatterns,
        requiresReview: true,
      );
    }
    
    // Check message length
    if (content.length > 500) {
      return ModerationResult(
        isAllowed: false,
        reason: 'Message too long (max 500 characters)',
        severity: ModerationSeverity.low,
      );
    }
    
    // Check for excessive caps
    final capsCount = content.split('').where((char) => char == char.toUpperCase() && char != char.toLowerCase()).length;
    if (capsCount > content.length * 0.7 && content.length > 10) {
      return ModerationResult(
        isAllowed: true,
        reason: 'Excessive capital letters',
        severity: ModerationSeverity.low,
        requiresReview: true,
      );
    }
    
    return ModerationResult(isAllowed: true);
  }

  // Check user posting behavior for spam detection
  static Future<bool> checkUserBehavior(String userId) async {
    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      
      // Check message frequency in last hour
      final recentMessages = await _firestore
          .collection('community_messages')
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThan: oneHourAgo.toIso8601String())
          .get();
      
      // Limit: 20 messages per hour
      if (recentMessages.docs.length >= 20) {
        await _flagUserForSpam(userId, 'Too many messages in short time');
        return false;
      }
      
      // Check for duplicate messages
      if (recentMessages.docs.length >= 3) {
        final contents = recentMessages.docs
            .map((doc) => doc.data()['content'] as String)
            .toList();
        
        // Check if last 3 messages are identical
        if (contents.length >= 3 &&
            contents.sublist(contents.length - 3).every((msg) => msg == contents.last)) {
          await _flagUserForSpam(userId, 'Repeated identical messages');
          return false;
        }
      }
      
      return true;
    } catch (e) {
      print('Error checking user behavior: $e');
      return true; // Allow on error to avoid blocking legitimate users
    }
  }

  // Flag user for spam behavior
  static Future<void> _flagUserForSpam(String userId, String reason) async {
    try {
      await _firestore.collection('user_flags').add({
        'userId': userId,
        'reason': reason,
        'timestamp': DateTime.now().toIso8601String(),
        'type': 'spam',
        'status': 'pending_review',
      });
    } catch (e) {
      print('Error flagging user for spam: $e');
    }
  }

  // Report user action for analytics
  static Future<void> logModerationAction(String action, String userId, {Map<String, dynamic>? details}) async {
    try {
      await _firestore.collection('moderation_logs').add({
        'action': action,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
        'details': details ?? {},
      });
    } catch (e) {
      print('Error logging moderation action: $e');
    }
  }

  // Get user's moderation status
  static Future<UserModerationStatus> getUserModerationStatus(String userId) async {
    try {
      // Check if user is banned
      final userDoc = await _firestore
          .collection('community_users')
          .doc(userId)
          .get();
      
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final isBanned = userData['isBanned'] ?? false;
        final isMuted = userData['isMuted'] ?? false;
        
        if (isBanned) {
          return UserModerationStatus.banned;
        } else if (isMuted) {
          return UserModerationStatus.muted;
        }
      }
      
      // Check recent flags
      final recentFlags = await _firestore
          .collection('user_flags')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending_review')
          .limit(1)
          .get();
      
      if (recentFlags.docs.isNotEmpty) {
        return UserModerationStatus.flagged;
      }
      
      return UserModerationStatus.good;
    } catch (e) {
      print('Error getting user moderation status: $e');
      return UserModerationStatus.good;
    }
  }

  // Community guidelines
  static List<CommunityGuideline> getCommunityGuidelines() {
    return [
      CommunityGuideline(
        title: 'Be Respectful',
        description: 'Treat everyone with kindness and respect. No harassment, bullying, or hate speech.',
        examples: ['Use encouraging language', 'Support others\' journeys', 'Respect different perspectives'],
      ),
      CommunityGuideline(
        title: 'Stay Anonymous',
        description: 'Protect your privacy and others\'. Don\'t share personal information.',
        examples: ['No real names or locations', 'No contact information', 'No photo sharing'],
      ),
      CommunityGuideline(
        title: 'Focus on Mental Health',
        description: 'Keep discussions related to mental wellness and support.',
        examples: ['Share coping strategies', 'Discuss feelings and experiences', 'Ask for support'],
      ),
      CommunityGuideline(
        title: 'No Self-Harm Content',
        description: 'Don\'t share graphic details about self-harm or methods.',
        examples: ['Seek help instead of sharing harmful methods', 'Use crisis resources', 'Support recovery'],
      ),
      CommunityGuideline(
        title: 'Report Issues',
        description: 'Help keep our community safe by reporting inappropriate content.',
        examples: ['Use the report button', 'Contact moderators', 'Look out for others'],
      ),
    ];
  }

  // Emergency keywords detection (more comprehensive)
  static bool detectEmergencyKeywords(String content) {
    final emergencyKeywords = [
      // Direct self-harm
      'kill myself', 'end my life', 'suicide', 'want to die',
      'hurt myself', 'cut myself', 'self harm', 'overdose',
      // Indirect indicators
      'can\'t go on', 'no point living', 'everyone better without me',
      'permanent solution', 'end the pain', 'tired of living',
      // Crisis situations
      'emergency', 'crisis', 'help me please', 'desperate',
    ];
    
    final lowerContent = content.toLowerCase();
    return emergencyKeywords.any((keyword) => lowerContent.contains(keyword));
  }
}

class ModerationResult {
  final bool isAllowed;
  final String? reason;
  final ModerationSeverity severity;
  final List<String> flaggedWords;
  final bool requiresReview;

  ModerationResult({
    required this.isAllowed,
    this.reason,
    this.severity = ModerationSeverity.low,
    this.flaggedWords = const [],
    this.requiresReview = false,
  });
}

enum ModerationSeverity {
  low,
  medium,
  high,
}

enum UserModerationStatus {
  good,
  flagged,
  muted,
  banned,
}

class CommunityGuideline {
  final String title;
  final String description;
  final List<String> examples;

  CommunityGuideline({
    required this.title,
    required this.description,
    required this.examples,
  });
}