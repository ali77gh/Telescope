import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class InputLayout extends StatefulWidget {

  final Telescope<String> text;
  const InputLayout(this.text, {Key? key}) : super(key: key);

  @override
  State<InputLayout> createState() => InputLayoutState();
}

class InputLayoutState extends State<InputLayout> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: ""),
      onChanged: (content){
        widget.text.value = content;
      },
    );
  }
}
