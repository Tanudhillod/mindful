class CommunityMessage {
  final String id;
  final String userId;
  final String userNickname;
  final String userAvatar;
  final String content;
  final DateTime timestamp;
  final String? replyToId; // ID of message being replied to
  final bool isAnonymous;
  final List<String> reactions; // User IDs who reacted
  final bool isReported;
  final bool isModerated;

  CommunityMessage({
    required this.id,
    required this.userId,
    required this.userNickname,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
    this.replyToId,
    this.isAnonymous = true,
    this.reactions = const [],
    this.isReported = false,
    this.isModerated = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userNickname': userNickname,
      'userAvatar': userAvatar,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'replyToId': replyToId,
      'isAnonymous': isAnonymous,
      'reactions': reactions,
      'isReported': isReported,
      'isModerated': isModerated,
    };
  }

  factory CommunityMessage.fromMap(Map<String, dynamic> map) {
    return CommunityMessage(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userNickname: map['userNickname'] ?? 'Anonymous',
      userAvatar: map['userAvatar'] ?? '👤',
      content: map['content'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      replyToId: map['replyToId'],
      isAnonymous: map['isAnonymous'] ?? true,
      reactions: List<String>.from(map['reactions'] ?? []),
      isReported: map['isReported'] ?? false,
      isModerated: map['isModerated'] ?? false,
    );
  }

  CommunityMessage copyWith({
    String? id,
    String? userId,
    String? userNickname,
    String? userAvatar,
    String? content,
    DateTime? timestamp,
    String? replyToId,
    bool? isAnonymous,
    List<String>? reactions,
    bool? isReported,
    bool? isModerated,
  }) {
    return CommunityMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userNickname: userNickname ?? this.userNickname,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      replyToId: replyToId ?? this.replyToId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      reactions: reactions ?? this.reactions,
      isReported: isReported ?? this.isReported,
      isModerated: isModerated ?? this.isModerated,
    );
  }
}

class CommunityUser {
  final String id;
  final String nickname;
  final String avatar;
  final DateTime joinedAt;
  final DateTime lastSeen;
  final bool isOnline;
  final bool isMuted;
  final bool isBanned;
  final int messageCount;
  final int helpfulCount; // Count of helpful reactions received

  CommunityUser({
    required this.id,
    required this.nickname,
    required this.avatar,
    required this.joinedAt,
    required this.lastSeen,
    this.isOnline = false,
    this.isMuted = false,
    this.isBanned = false,
    this.messageCount = 0,
    this.helpfulCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar': avatar,
      'joinedAt': joinedAt.toIso8601String(),
      'lastSeen': lastSeen.toIso8601String(),
      'isOnline': isOnline,
      'isMuted': isMuted,
      'isBanned': isBanned,
      'messageCount': messageCount,
      'helpfulCount': helpfulCount,
    };
  }

  factory CommunityUser.fromMap(Map<String, dynamic> map) {
    return CommunityUser(
      id: map['id'] ?? '',
      nickname: map['nickname'] ?? 'Anonymous',
      avatar: map['avatar'] ?? '👤',
      joinedAt: DateTime.parse(map['joinedAt']),
      lastSeen: DateTime.parse(map['lastSeen']),
      isOnline: map['isOnline'] ?? false,
      isMuted: map['isMuted'] ?? false,
      isBanned: map['isBanned'] ?? false,
      messageCount: map['messageCount'] ?? 0,
      helpfulCount: map['helpfulCount'] ?? 0,
    );
  }
}

class MessageReaction {
  final String id;
  final String messageId;
  final String userId;
  final String type; // 'helpful', 'heart', 'thumbs_up'
  final DateTime timestamp;

  MessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messageId': messageId,
      'userId': userId,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageReaction.fromMap(Map<String, dynamic> map) {
    return MessageReaction(
      id: map['id'] ?? '',
      messageId: map['messageId'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'helpful',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}