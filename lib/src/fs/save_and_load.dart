import 'package:shared_preferences/shared_preferences.dart';

import 'on_disk_save_ability.dart';

class SaveAndLoad {
  static const String prefix = "TELESCOPE_";

  static save<T>(
      String onDiskId, OnDiskSaveAbility<T>? onDiskSaveAbility, T value) async {
    onDiskId += prefix;

    var pref = await SharedPreferences.getInstance();
    switch (T) {
      case const (String):
        await pref.setString(onDiskId, value as String);
        break;
      case const (int):
        await pref.setInt(onDiskId, value as int);
        break;
      case const (double):
        await pref.setDouble(onDiskId, value as double);
        break;
      case const (bool):
        await pref.setBool(onDiskId, value as bool);
        break;
      default:
        await pref.setString(
            onDiskId, onDiskSaveAbility!.toOnDiskString(value));
        break;
    }
  }

  static Future<T?> load<T>(
      String onDiskId, OnDiskSaveAbility<T>? onDiskSaveAbility) async {
    onDiskId += prefix;
    var pref = await SharedPreferences.getInstance();
    // not assign while its not on disk yet (keeps default value)
    if (!pref.containsKey(onDiskId)) {
      return null;
    }

    switch (T) {
      case const (String):
        return pref.getString(onDiskId) as T;
      case const (int):
        return pref.getInt(onDiskId) as T;
      case const (double):
        return pref.getDouble(onDiskId) as T;
      case const (bool):
        return pref.getBool(onDiskId) as T;
      default:
        return onDiskSaveAbility!.parseOnDiskString(pref.getString(onDiskId)!);
    }
  }

  // list save and load

  static const String sep = '~';
  static saveList<T>(String onDiskId, OnDiskSaveAbility<T>? onDiskSaveAbility,
      List<T> items) async {
    onDiskId += prefix;

    var stringifies = items.map((i) {
      var itemString = "";
      if (onDiskSaveAbility != null) {
        itemString = onDiskSaveAbility.toOnDiskString(i);
      } else {
        itemString = i.toString();
      }
      return itemString.replaceAll(sep, "\\$sep");
    }).join("-$sep");

    var pref = await SharedPreferences.getInstance();
    await pref.setString(onDiskId, stringifies);
  }

  static Future<List<T>?> loadList<T>(
      String onDiskId, OnDiskSaveAbility<T>? onDiskSaveAbility) async {
    onDiskId += prefix;

    var pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(onDiskId)) {
      return null;
    }
    return pref.getString(onDiskId)!.split("-$sep").map((i) {
      i = i.replaceAll("\\$sep", sep);
      switch (T) {
        case const (bool):
          return (i == "true") as T;
        case const (int):
          return (int.parse(i)) as T;
        case const (double):
          return (double.parse(i)) as T;
        case const (String):
          return (i) as T;
        default:
          return onDiskSaveAbility!.parseOnDiskString(i);
      }
    }).toList();
  }
}
