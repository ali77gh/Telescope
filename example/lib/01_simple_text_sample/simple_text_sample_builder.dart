import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class TextSample extends StatelessWidget {
  final textValue = Telescope("");
  final style = const TextStyle(fontSize: 60);

  TextSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => textValue.value += "a",
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                textValue
                    .liveWidget((context, value) => Text(value, style: style)),
                textValue
                    .liveWidget((context, value) => Text(value, style: style)),
                textValue.liveWidget((context, value) =>
                    Text(value.length.toString(), style: style)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
