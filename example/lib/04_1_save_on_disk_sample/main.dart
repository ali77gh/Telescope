import 'package:flutter/material.dart';
import './save_on_disk_sample.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(fontFamily: 'IranSans'),
        debugShowCheckedModeBanner: false,
        home: SaveOnDiskSampleLayout()
    );
  }
}
