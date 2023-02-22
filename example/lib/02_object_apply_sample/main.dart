
import 'package:app/02_object_apply_sample/object_apply_sample.dart';
import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class Human implements TelescopeHash{
  String name;
  int age;
  Human(this.name, this.age);

  @override
  String toString(){
    return "$name is $age years old.";
  }

  @override
  String toTelescopeHash() { return "$name$age"; }
}

void main() {
  runApp(MyApp());
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
