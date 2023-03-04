
import 'package:shared_preferences/shared_preferences.dart';

import 'on_disk_savable.dart';

class SaveAndLoad{

  static const String PREFIX = "TELESCOPE_";

  static save<T>(String onDiskId, T value){

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
              (value as OnDiskSavable).toOnDiskString()
          ).then((value){});
          break;
      }
    });
  }

  static load<T>(T valueAsDeserializer, String onDiskId, void Function(T loaded) callback){

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
          // onDiskSavable
          (valueAsDeserializer as OnDiskSavable).parseOnDiskString(pref.getString(onDiskId)!);
          callback(valueAsDeserializer);
          break;
      }

    });
  }
}