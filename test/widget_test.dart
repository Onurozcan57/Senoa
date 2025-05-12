import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senoa/main.dart'; // 'senoa' projenizin ismi olmalı

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget); // Başlangıç değeri 0
    expect(find.text('1'), findsNothing); // 1 değeri bulunmamalı

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add)); // '+' butonuna tıklama
    await tester.pump(); // Yeniden render et

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing); // Artık 0'ı görmemeliyiz
    expect(find.text('1'), findsOneWidget); // 1'i görmeliyiz
  });
}
