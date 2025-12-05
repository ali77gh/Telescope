import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class DisposeTest extends StatelessWidget {
  final visible = Telescope(false);
  final counter = Telescope(0);

  final style = const TextStyle(fontSize: 60);

  DisposeTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // type: MaterialType.transparency,
      home: SafeArea(
        child: GestureDetector(
          onTap: () {
            counter.value += 1;
            visible.value = !visible.holden;
          },
          child: Container(
            color: Colors.white,
            child: visible.liveWidget(
              (context, visibility_) {
                if (visibility_) {
                  return counter.liveWidget((context, counter_) =>
                      Text(counter_.toString(), style: style));
                } else {
                  return const Text("click to see");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(DisposeTest());
}
