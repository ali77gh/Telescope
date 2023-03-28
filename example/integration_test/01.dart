import 'package:flutter_test/flutter_test.dart';

import 'package:app/01_simple_text_sample/main.dart' as example01;

void test(){

  testWidgets('simple text', (tester) async {
    example01.main();
    await tester.pumpAndSettle();

    expect(find.text(''), findsNWidgets(2));
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('0'));
    await tester.pumpAndSettle(); // Trigger a frame.

    expect(find.text('a'), findsNWidgets(2));
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('1'));
    await tester.pumpAndSettle(); // Trigger a frame.

    expect(find.text('aa'), findsNWidgets(2));
    expect(find.text('2'), findsOneWidget);
  });
}