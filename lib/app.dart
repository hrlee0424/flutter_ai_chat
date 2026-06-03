import 'package:flutter/material.dart';

import 'features/chat/chat_screen.dart';
import 'theme.dart';

class FlutterAiChatApp extends StatelessWidget {
  const FlutterAiChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AI Chat',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const ChatScreen(),
    );
  }
}
