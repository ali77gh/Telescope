import 'package:app/07_multi_language_and_theme/i18n.dart';
import 'package:app/07_multi_language_and_theme/theme.dart';
import 'package:flutter/material.dart';

class MultiLanguageAndThemeSample extends StatefulWidget {
  const MultiLanguageAndThemeSample({Key? key}) : super(key: key);

  @override
  State<MultiLanguageAndThemeSample > createState() => MultiLanguageAndThemeSampleState();
}

class MultiLanguageAndThemeSampleState extends State<MultiLanguageAndThemeSample> {

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
              color: AppTheme.background.watch(this),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(I18n.hello.watch(this), style: TextStyle(color: AppTheme.text.watch(this))),
                  TextButton(onPressed: (){
                    I18n.toggleLanguage();
                  }, child: const Text("switch language")),
                  TextButton(onPressed: (){
                    AppTheme.toggleTheme();
                  }, child: const Text("switch theme")),
                ],
              )
            )
        )
    );

  }
}