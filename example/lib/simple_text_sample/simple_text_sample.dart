import 'package:flutter/material.dart';
import 'package:telescope/src/observable.dart';


class SimpleTextSampleLayout extends StatefulWidget {

  static var textValue = Observable("");

  @override
  State<SimpleTextSampleLayout> createState() => SimpleTextSampleLayoutState();
}

class SimpleTextSampleLayoutState extends State<SimpleTextSampleLayout> {

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
                Text(SimpleTextSampleLayout.textValue.get(this)!,style: style),
                // Text(SimpleTextSampleLayout.textValue.get(this)!,style: style),
                // Text(SimpleTextSampleLayout.textValue.get(this)!.length.toString(),style: style),
              ],),
            )
        )
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}