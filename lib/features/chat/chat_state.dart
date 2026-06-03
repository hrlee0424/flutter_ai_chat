import 'chat_message.dart';

class ChatState {
  const ChatState({
    required this.messages,
    this.isSending = false,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final String? errorMessage;

  List<ChatMessage> get displayMessages =>
      messages.where((message) => !message.isSystem).toList();

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
