import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class TextSample extends StatefulWidget {
  const TextSample({Key? key}) : super(key: key);

  @override
  State<TextSample> createState() => TextSampleState();
}

class TextSampleState extends State<TextSample> {
  var textValue = Telescope("");

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontSize: 60);
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: GestureDetector(
          onTap: () {
            textValue.value += "a";
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(textValue.watch(this), style: style),
                Text(textValue.watch(this), style: style),
                Text(textValue.watch(this).length.toString(), style: style),
              ],
            ),
          ),
        )));
  }
}
