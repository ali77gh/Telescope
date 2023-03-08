
import 'package:shared_preferences/shared_preferences.dart';

import 'on_disk_save_ability.dart';

class SaveAndLoad{

  static const String PREFIX = "TELESCOPE_";

  static save<T>(String onDiskId, T value, OnDiskSaveAbility<T>? onDiskSaveAbility){

    onDiskId += PREFIX;

    SharedPreferences.getInstance().then((pref){
      switch(T){
        case String: pref.setString(onDiskId, value as String).then((value){}); break;
        case int: pref.setInt(onDiskId, value as int).then((value){}); break;
        case double: pref.setDouble(onDiskId, value as double).then((value){}); break;
        case bool: pref.setBool(onDiskId, value as bool).then((value){}); break;
        default:
          pref.setString(
              onDiskId,
              onDiskSaveAbility!.toOnDiskString(value)
          ).then((value){});
          break;
      }
    });
  }

  static load<T>(OnDiskSaveAbility<T>? onDiskSaveAbility, String onDiskId, void Function(T loaded) callback){

    onDiskId += PREFIX;
    SharedPreferences.getInstance().then((pref){

      // not assign while its not on disk yet (keeps default value)
      if(!pref.containsKey(onDiskId)){ return; }

      switch (T){
        case String: callback(pref.getString(onDiskId) as T); break;
        case int: callback(pref.getInt(onDiskId) as T); break;
        case double: callback(pref.getDouble(onDiskId) as T); break;
        case bool: callback(pref.getBool(onDiskId) as T); break;
        default:
          callback(
              onDiskSaveAbility!.parseOnDiskString(pref.getString(onDiskId)!)
          );
          break;
      }

    });
  }

  // list save and load

  static const String SEP = '~';
  static saveList<T>(String onDiskId, List<T> items, OnDiskSaveAbility<T>? onDiskSaveAbility){

    onDiskId += PREFIX;

    var stringifies = items.map((i){
      var itemString = "";
      if(onDiskSaveAbility != null){
        itemString = onDiskSaveAbility.toOnDiskString(i);
      }else{
        itemString = i.toString();
      }
      return itemString.replaceAll(SEP, "\\$SEP");
    }).join("-$SEP");
    SharedPreferences.getInstance().then((pref){
      pref.setString(onDiskId, stringifies).then((value){});
    });
  }

  static loadList<T>(String onDiskId, OnDiskSaveAbility<T>? onDiskSaveAbility, void Function(List<T> loaded) callback){

    onDiskId += PREFIX;

    SharedPreferences.getInstance().then((pref){
      if(!pref.containsKey(onDiskId)){ return; }
      callback(
          pref.getString(onDiskId)!.split("-$SEP").map((i){
            switch(T){
              case bool: return (i == "true") as T;
              case int: return (int.parse(i)) as T;
              case double: return (double.parse(i)) as T;
              case String: return (i) as T;
              default: return onDiskSaveAbility!.parseOnDiskString(i);
            }
          }).toList()
      );
    });
  }
}