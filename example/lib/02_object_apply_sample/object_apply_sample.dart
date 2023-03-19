import 'package:app/02_object_apply_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class ObjectApplySampleLayout extends StatefulWidget {
  const ObjectApplySampleLayout({Key? key}) : super(key: key);

  @override
  State<ObjectApplySampleLayout> createState() =>
      ObjectApplySampleLayoutState();
}

class ObjectApplySampleLayoutState extends State<ObjectApplySampleLayout> {
  var human = Telescope<Human>(Human("Ali", 23));

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
