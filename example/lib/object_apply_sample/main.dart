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

  var human = ObjectApplySampleLayoutState.human;
  Timer.periodic(const Duration(milliseconds: 1000), (timer) {

    // Wrong way to update object
    human.value.age++;

    // Correct way to update object
    // human.apply(change: (human){
    //   human!.age++;
    // });

    // Also works (reassign)
    // human.value = Human(human.value.name, human.value.age + 1);

  });
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
