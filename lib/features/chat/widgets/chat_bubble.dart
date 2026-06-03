import 'package:flutter/material.dart';

import '../chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final alignment = message.isUser
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final backgroundColor = message.isUser ? colorScheme.primary : Colors.white;
    final foregroundColor = message.isUser
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.content,
          style: TextStyle(color: foregroundColor, fontSize: 15, height: 1.35),
        ),
      ),
    );
  }
}
