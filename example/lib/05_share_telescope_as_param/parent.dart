import 'package:app/05_share_telescope_as_param/input_child.dart';
import 'package:app/05_share_telescope_as_param/output_child.dart';
import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class ParentLayout extends StatelessWidget {
  final text = Telescope<String>("");

  ParentLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              InputLayout(text),
              OutputLayout(text),
            ],
          ),
        ),
      ),
    );
  }
}
