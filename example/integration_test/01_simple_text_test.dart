import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app/01_simple_text_sample/main.dart' as example01;
import 'package:app/02_object_apply_sample/main.dart' as example02;
import 'package:app/03_depend_observable_sample/main.dart' as example03;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  testWidgets('object apply', (tester) async {
    example02.main();
    await tester.pumpAndSettle();

    expect(find.text('Ali is 24 years old.'), findsOneWidget);

    await tester.tap(find.text('Ali is 24 years old.'));
    await tester.pumpAndSettle(); // Trigger a frame.

    expect(find.text('Ali is 25 years old.'), findsOneWidget);
  });


  testWidgets('bmi', (tester) async {
    example03.main();
    await tester.pumpAndSettle();
    var initResult = tester.allWidgets.whereType<Text>().last.data!;

    await tester.tap(find.byType(Slider).first);
    await tester.pumpAndSettle(); // Trigger a frame.

    await tester.tap(find.byType(Slider).last);
    await tester.pumpAndSettle(); // Trigger a frame.

    var weight = tester.allWidgets.whereType<Slider>().first.value;
    var height = tester.allWidgets.whereType<Slider>().last.value;
    var result = tester.allWidgets.whereType<Text>().last.data!;

    var bmi = weight/ ((height/ 100) * (height / 100));

    expect(result.contains("$bmi"), true);
    expect(initResult != result, true);
  });
}