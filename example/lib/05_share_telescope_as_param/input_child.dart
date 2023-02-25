import 'package:flutter/material.dart';
import 'package:telescope/src/telescope.dart';

class InputLayout extends StatefulWidget {

  Telescope<String> text;
  InputLayout(this.text);

  @override
  State<InputLayout> createState() => InputLayoutState();
}

class InputLayoutState extends State<InputLayout> {

  @override
  Widget build(BuildContext context) {

    print("input build");
    return TextField(
      controller: TextEditingController(text: ""),
      onChanged: (content){
        widget.text.value = content;
      },
    );
  }
}
