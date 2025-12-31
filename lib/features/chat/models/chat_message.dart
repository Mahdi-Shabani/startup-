import 'package:flutter/foundation.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ChatMessage(isUser: $isUser, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.text == text &&
        other.isUser == isUser &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => text.hashCode ^ isUser.hashCode ^ timestamp.hashCode;
}
