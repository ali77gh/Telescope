import 'package:flutter_test/flutter_test.dart';

import 'package:app/02_object_apply_sample/main.dart' as example02;

void test() {
  testWidgets('object apply', (tester) async {
    example02.main();
    await tester.pumpAndSettle();

    expect(find.text('Ali is 24 years old.'), findsOneWidget);

    await tester.tap(find.text('Ali is 24 years old.'));
    await tester.pumpAndSettle(); // Trigger a frame.

    expect(find.text('Ali is 25 years old.'), findsOneWidget);
  });
}
