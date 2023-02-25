import 'package:app/06_list/list_sample.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(fontFamily: 'IranSans'),
        debugShowCheckedModeBanner: false,
        home: ListSampleLayout()
    );
  }
}
