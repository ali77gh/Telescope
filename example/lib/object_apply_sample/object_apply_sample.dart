import 'package:app/object_apply_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:telescope/src/observable.dart';


class ObjectApplySampleLayout extends StatefulWidget {

  @override
  State<ObjectApplySampleLayout> createState() => ObjectApplySampleLayoutState();
}

class ObjectApplySampleLayoutState extends State<ObjectApplySampleLayout> {

  static var human = Observable<Human>(Human("Ali",23));

  @override
  Widget build(BuildContext context) {

    print("build");
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(children: [
                Text(
                    human.watch(this).toString(),
                    style: const TextStyle(fontSize: 60),
                ),
              ],),
            )
        )
    );
  }
}