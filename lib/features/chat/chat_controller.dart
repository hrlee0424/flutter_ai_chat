import 'package:flutter/foundation.dart';

import 'chat_message.dart';
import 'chat_service.dart';
import 'chat_state.dart';

class ChatController extends ChangeNotifier {
  ChatController({ChatService chatService = const MockChatService()})
    : _chatService = chatService,
      _state = ChatState(messages: [_welcomeMessage()]);

  final ChatService _chatService;
  ChatState _state;
  int _messageSequence = 0;

  ChatState get state => _state;

  Future<void> sendMessage(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty || _state.isSending) {
      return;
    }

    final userMessage = _createMessage(ChatRole.user, text);
    _state = _state.copyWith(
      messages: [..._state.messages, userMessage],
      isSending: true,
      clearErrorMessage: true,
    );
    notifyListeners();

    try {
      final reply = await _chatService.sendMessage(_state.messages);
      _state = _state.copyWith(
        messages: [
          ..._state.messages,
          _createMessage(ChatRole.assistant, reply),
        ],
        isSending: false,
      );
    } catch (_) {
      _state = _state.copyWith(
        isSending: false,
        errorMessage: 'AI 답변을 가져오지 못했어요. 잠시 후 다시 시도해주세요.',
      );
    }

    notifyListeners();
  }

  void clearChat() {
    _state = ChatState(
      messages: [
        _createMessage(ChatRole.assistant, '새 대화를 시작했어요. 무엇이든 물어보세요.'),
      ],
    );
    notifyListeners();
  }

  ChatMessage _createMessage(ChatRole role, String content) {
    _messageSequence += 1;

    return ChatMessage(
      id: 'message-$_messageSequence',
      role: role,
      content: content,
      createdAt: DateTime.now(),
    );
  }

  static ChatMessage _welcomeMessage() {
    return ChatMessage(
      id: 'message-0',
      role: ChatRole.assistant,
      content: '안녕하세요! 무엇을 도와드릴까요?',
      createdAt: DateTime.now(),
    );
  }
}
