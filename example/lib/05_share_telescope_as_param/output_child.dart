import 'package:flutter/material.dart';
import 'package:telescope/src/telescope.dart';

class OutputLayout extends StatefulWidget {

  Telescope<String> text;
  OutputLayout(this.text);

  @override
  State<OutputLayout> createState() => OutputLayoutState();
}

class OutputLayoutState extends State<OutputLayout> {

  @override
  Widget build(BuildContext context) {

    print("output build");
    return Text(widget.text.watch(this));
  }
}
