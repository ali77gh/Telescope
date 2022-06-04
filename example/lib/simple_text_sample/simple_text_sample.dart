import 'package:flutter/material.dart';
import 'package:telescope/src/observable.dart';


class TextSample extends StatefulWidget {
  @override
  State<TextSample> createState() => TextSampleState();
}

class TextSampleState extends State<TextSample> {

  static var textValue = Observable("");

  @override
  Widget build(BuildContext context) {

    var style = const TextStyle(fontSize: 60);
    print("build");
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(children: [
                Text(textValue.watch(this),style: style),
                Text(textValue.watch(this),style: style),
                Text(textValue.watch(this).length.toString(),style: style),
              ],),
            )
        )
    );
  }
}