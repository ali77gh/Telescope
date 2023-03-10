

import 'package:telescope/telescope.dart';

// I18 is actually short form of "Internationalization"
class I18n{
  static const english = "en";
  static const persian = "pe";

  static var language = Telescope.saveOnDiskForBuiltInType(english, "app_language");

  static toggleLanguage(){
    language.value = language.value==english ? persian : english;
  }

  static var hello = Telescope.dependsOn([language],()=>language.value==english ? "hello" : "سلام");
  static var bye = Telescope.dependsOn([language],()=>language.value==english ? "bye" : "خدانگهدار");
}