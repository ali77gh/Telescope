import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class ObjectApplySampleLayout extends StatefulWidget {
  const ObjectApplySampleLayout({Key? key}) : super(key: key);

  @override
  State<ObjectApplySampleLayout> createState() =>
      ObjectApplySampleLayoutState();
}

class ObjectApplySampleLayoutState extends State<ObjectApplySampleLayout> {
  var human = Telescope<Human>(Human("Ali", 24));

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: GestureDetector(
          onTap: () {
            human.value.age++;
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  human.watch(this).toString(),
                  style: const TextStyle(fontSize: 60),
                ),
              ],
            ),
          ),
        )));
  }
}

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
