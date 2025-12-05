import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class OutputLayout extends StatelessWidget {
  final Telescope<String> text;
  const OutputLayout(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text.liveWidget((context, value) => Text(value));
  }
}
