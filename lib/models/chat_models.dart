import 'package:flutter/material.dart';

enum MessageType {
  text,
  crisis,
  suggestion,
  quickActions,
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageType messageType;
  final List<String>? quickActions;
  final double? crisisLevel;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.quickActions,
    this.crisisLevel,
  });
}