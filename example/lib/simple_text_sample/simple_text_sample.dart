import 'package:flutter/material.dart';

class SimpleTextSampleLayout extends StatefulWidget {
  @override
  State<SimpleTextSampleLayout> createState() => SimpleTextSampleLayoutState();
}

class SimpleTextSampleLayoutState extends State<SimpleTextSampleLayout> {

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
              color: Colors.white,
              child: const Text("hello world"),
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