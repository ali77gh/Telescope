import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/03_1_depend_observable_sample/main.dart' as example03;

void test() {
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

    var bmi = weight / ((height / 100) * (height / 100));

    expect(result.contains("$bmi"), true);
    expect(initResult != result, true);
  });
}
