import 'dart:async';

import 'package:app/depend_observable_sample/object_apply_sample.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

  // Wrong Way
  // Timer.periodic(const Duration(milliseconds: 1000), (timer) {
  //   DependObservableSampleLayout.weight.value = DependObservableSampleLayout.weight.get(null)! + 1;
  // });

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(fontFamily: 'IranSans'),
        debugShowCheckedModeBanner: false,
        home: DependObservableSampleLayout()
    );
  }
}
