import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class InputLayout extends StatelessWidget {
  final Telescope<String> text;
  const InputLayout(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: ""),
      onChanged: (content) => text.value = content,
    );
  }
}
