import 'package:flutter/material.dart';
import 'package:telescope/src/observable.dart';

class SimpleTextSampleViewModel{

  static var textValue = Observable("");

}

class SimpleTextSampleLayout extends StatefulWidget {
  @override
  State<SimpleTextSampleLayout> createState() => SimpleTextSampleLayoutState();
}

class SimpleTextSampleLayoutState extends State<SimpleTextSampleLayout> {

  @override
  Widget build(BuildContext context) {

    print("build");
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Text(SimpleTextSampleViewModel.textValue.get(this)!),
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