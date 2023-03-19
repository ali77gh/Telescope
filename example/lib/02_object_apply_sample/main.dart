import 'package:app/02_object_apply_sample/object_apply_sample.dart';
import 'package:flutter/material.dart';

class Human {
  String name;
  int age;
  Human(this.name, this.age);

  @override
  String toString() {
    return "$name is $age years old.";
  }

  @override
  int get hashCode => (name.hashCode) * age.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'IranSans'),
        debugShowCheckedModeBanner: false,
        home: const ObjectApplySampleLayout());
  }
}
