import 'dart:async';

import 'package:app/object_apply_sample/object_apply_sample.dart';
import 'package:flutter/material.dart';

class Human{
  String name;
  int age;
  Human(this.name,this.age);

  @override
  String toString(){
    return "$name is $age years old.";
  }
}

void main() {
  runApp(MyApp());

  // Wrong Way
  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
    ObjectApplySampleLayout.human.get(null)!.age++;
  });

  // Correct Way
  // Timer.periodic(const Duration(milliseconds: 1000), (timer) {
  //   ObjectApplySampleLayout.human.apply(change: (human){
  //     human!.age++;
  //   });
  // });
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(fontFamily: 'IranSans'),
        debugShowCheckedModeBanner: false,
        home: ObjectApplySampleLayout()
    );
  }
}
