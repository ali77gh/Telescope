import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class OutputLayout extends StatefulWidget {
  final Telescope<String> text;
  const OutputLayout(this.text, {Key? key}) : super(key: key);

  @override
  State<OutputLayout> createState() => OutputLayoutState();
}

class OutputLayoutState extends State<OutputLayout> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text.watch(this));
  }
}
