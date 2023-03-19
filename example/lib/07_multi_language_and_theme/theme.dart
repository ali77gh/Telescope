import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class AppTheme {
  static var theme = Telescope.saveOnDiskForBuiltInType("light", "app_theme");

  static toggleTheme() {
    theme.value = theme.value == "light" ? "dark" : "light";
  }

  static var background = Telescope.dependsOn(
      [theme],
      () => theme.value == "light"
          ? const Color.fromARGB(255, 230, 230, 230)
          : // light
          const Color.fromARGB(255, 25, 25, 25) // dark
      );

  static var text = Telescope.dependsOn(
      [theme],
      () => theme.value == "light"
          ? const Color.fromARGB(255, 25, 25, 25)
          : // light
          const Color.fromARGB(255, 230, 230, 230) // dark
      );
}
