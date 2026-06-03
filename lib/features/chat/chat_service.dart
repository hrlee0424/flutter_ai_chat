import 'chat_message.dart';

abstract class ChatService {
  Future<String> sendMessage(List<ChatMessage> messages);
}

class MockChatService implements ChatService {
  const MockChatService();

  @override
  Future<String> sendMessage(List<ChatMessage> messages) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final prompt = messages.last.content;

    if (prompt.contains('flutter') || prompt.contains('Flutter')) {
      return 'Flutter 앱에서는 화면은 Widget으로 구성하고, 상태는 setState나 상태관리 도구로 업데이트할 수 있어요.';
    }

    if (prompt.contains('안녕')) {
      return '반가워요. 지금은 로컬 데모 응답이지만, API 연결 지점을 추가하면 실제 AI 챗봇으로 확장할 수 있어요.';
    }

    return '"$prompt"에 대해 조금 더 알려주시면, 핵심부터 차근차근 정리해볼게요.';
  }
}
