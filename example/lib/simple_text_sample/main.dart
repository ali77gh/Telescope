import 'dart:async';

import 'package:app/simple_text_sample/simple_text_sample.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
    SimpleTextSampleViewModel.textValue.value = SimpleTextSampleViewModel.textValue.get(null)! + "a";
  });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(fontFamily: 'IranSans'),
        debugShowCheckedModeBanner: false,
        home: SimpleTextSampleLayout()
    );
  }
}
