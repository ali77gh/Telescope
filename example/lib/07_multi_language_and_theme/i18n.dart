

import 'package:telescope/telescope.dart';

// I18 is actually short form of "Internationalization"
class I18n{
  static const ENGLISH = "en";
  static const PERSIAN = "pe";

  static var language = Telescope.saveOnDiskForBuiltInType(ENGLISH, "app_language");

  static toggleLanguage(){
    language.value = language.value==ENGLISH ? PERSIAN : ENGLISH;
  }

  static var hello = Telescope.dependsOn([language],()=>language.value==ENGLISH ? "hello" : "سلام");
  static var bye = Telescope.dependsOn([language],()=>language.value==ENGLISH ? "bye" : "خدانگهدار");
}