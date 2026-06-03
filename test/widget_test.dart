import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ai_chat/app.dart';

void main() {
  testWidgets('sends a message and shows a local AI reply', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlutterAiChatApp());

    expect(find.text('Flutter AI Chat'), findsOneWidget);
    expect(find.text('안녕하세요! 무엇을 도와드릴까요?'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Flutter 알려줘');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(find.text('Flutter 알려줘'), findsOneWidget);
    expect(find.text('AI가 답변을 작성하고 있어요...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 800));

    expect(find.textContaining('Widget으로 구성'), findsOneWidget);
  });
}
