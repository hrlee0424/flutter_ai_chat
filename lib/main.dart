import 'package:flutter/material.dart';

void main() {
  runApp(const FlutterAiChatApp());
}

class FlutterAiChatApp extends StatelessWidget {
  const FlutterAiChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF1E88E5);

    return MaterialApp(
      title: 'Flutter AI Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatMessage {
  const ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<ChatMessage> _messages = const [
    ChatMessage(text: '안녕하세요! 무엇을 도와드릴까요?', isUser: false),
  ].toList();

  bool _isThinking = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isThinking) {
      return;
    }

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isThinking = true;
      _messageController.clear();
    });
    _scrollToBottom();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) {
      return;
    }

    setState(() {
      _messages.add(ChatMessage(text: _buildLocalReply(text), isUser: false));
      _isThinking = false;
    });
    _scrollToBottom();
  }

  String _buildLocalReply(String prompt) {
    if (prompt.contains('flutter') || prompt.contains('Flutter')) {
      return 'Flutter 앱에서는 화면은 Widget으로 구성하고, 상태는 setState나 상태관리 도구로 업데이트할 수 있어요.';
    }

    if (prompt.contains('안녕')) {
      return '반가워요. 지금은 로컬 데모 응답이지만, API 연결 지점을 추가하면 실제 AI 챗봇으로 확장할 수 있어요.';
    }

    return '"$prompt"에 대해 조금 더 알려주시면, 핵심부터 차근차근 정리해볼게요.';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter AI Chat'),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: '새 대화',
            onPressed: () {
              setState(() {
                _messages
                  ..clear()
                  ..add(
                    const ChatMessage(
                      text: '새 대화를 시작했어요. 무엇이든 물어보세요.',
                      isUser: false,
                    ),
                  );
                _isThinking = false;
              });
            },
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
                itemCount: _messages.length + (_isThinking ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isThinking && index == _messages.length) {
                    return const _ThinkingBubble();
                  }

                  return _MessageBubble(message: _messages[index]);
                },
              ),
            ),
            _MessageComposer(
              controller: _messageController,
              isSending: _isThinking,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

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
          message.text,
          style: TextStyle(color: foregroundColor, fontSize: 15, height: 1.35),
        ),
      ),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text('AI가 답변을 작성하고 있어요...'),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isSending,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            tooltip: '전송',
            onPressed: isSending ? null : onSend,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.surfaceContainerHighest,
            ),
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
