import 'chat_message.dart';

abstract class ChatService {
  Future<String> sendMessage(List<ChatMessage> messages);
}

class MockChatService implements ChatService {
  const MockChatService({
    this.responseDelay = const Duration(milliseconds: 700),
  });

  final Duration responseDelay;

  @override
  Future<String> sendMessage(List<ChatMessage> messages) async {
    await Future<void>.delayed(responseDelay);

    final prompt = _lastUserMessage(messages)?.content.trim();
    if (prompt == null || prompt.isEmpty) {
      return '메시지를 입력하면 답변을 준비해볼게요.';
    }

    return _buildReply(prompt);
  }

  ChatMessage? _lastUserMessage(List<ChatMessage> messages) {
    for (final message in messages.reversed) {
      if (message.isUser) {
        return message;
      }
    }

    return null;
  }

  String _buildReply(String prompt) {
    final normalizedPrompt = prompt.toLowerCase();

    if (normalizedPrompt.contains('flutter')) {
      return 'Flutter 앱에서는 화면은 Widget으로 구성하고, 상태는 ChangeNotifier 같은 도구로 업데이트할 수 있어요.';
    }

    if (prompt.contains('안녕')) {
      return '반가워요. 지금은 Mock 응답이지만, 나중에 실제 AI API로 교체할 수 있어요.';
    }

    return '"$prompt"에 대해 조금 더 알려주시면, 핵심부터 차근차근 정리해볼게요.';
  }
}
