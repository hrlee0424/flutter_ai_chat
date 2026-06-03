import 'package:flutter/material.dart';

import 'chat_controller.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.controller});

  final ChatController? controller;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final ChatController _chatController;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _chatController = widget.controller ?? ChatController();
    _ownsController = widget.controller == null;
    _chatController.addListener(_handleChatStateChanged);
  }

  @override
  void dispose() {
    _chatController.removeListener(_handleChatStateChanged);
    if (_ownsController) {
      _chatController.dispose();
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleChatStateChanged() {
    setState(() {});
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text;
    _messageController.clear();
    await _chatController.sendMessage(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _chatController.state;
    final displayMessages = state.displayMessages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter AI Chat'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: '새 대화',
            onPressed: _chatController.clearChat,
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                itemCount: displayMessages.length + (state.isSending ? 1 : 0),
                itemBuilder: (context, index) {
                  if (state.isSending && index == displayMessages.length) {
                    return const TypingIndicator();
                  }

                  return ChatBubble(message: displayMessages[index]);
                },
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ChatInputBar(
              controller: _messageController,
              isSending: state.isSending,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
