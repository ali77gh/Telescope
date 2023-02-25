import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'depends_on_telescope.dart';
import 'on_disk_savable.dart';
import 'telescope_hash.dart';

// TODO make other data structures (map, set,...)
// TODO add standard docs to functions

class Telescope<T>{

  T _value;
  final Set<Function> _callbacks = <Function>{};

  String? _onDiskId;
  bool get isSavable => _onDiskId != null;
  bool isDependent = false;

  Telescope(this._value, {String? onDiskId, DependsOnTelescope<T>? dependsOn, iWillCallNotifyAll=false}){

    if(!iWillCallNotifyAll){
      if(!_isBuiltIn() && _value is! OnDiskSavable && _value is! TelescopeHash){
        try {
          throw "${T.toString()} is not implementing OnDiskSavable or TelescopeHash and is not a built-in type(int|string|double|bool)"
              " so there is no way to detect object changes"
              "you have two options:"
              "   1. implement TelescopeHash on ${T.toString()} if you can (recommended)"
              "   2. pass iWillCallNotifyAll to bypass error and call yourTelescopeObject.notifyAll() everytime you change something on it's value";
        } catch (e, s) {
          print(s);
        }
      }
    }

    if(onDiskId!=null && dependsOn!=null){
      throw "An on disk telescope can't be dependent (does not makes any sense)";
    }

    if(onDiskId!=null){
      _saveOnDisk(onDiskId);
    }
    if(dependsOn!=null){
      _dependOn(dependsOn.observables, dependsOn.calculate);
    }
  }

  void subscribe(Function callback){
    _callbacks.add(callback);
  }

  T watch(State state){
    subscribe(state.setState);
    return _value;
  }


  T get value {
    if(_value is OnDiskSavable || _value is TelescopeHash){
      var beforeChangeHash = getValueHash<T>(_value);
      // push callback to event loop immediately
      Future.delayed(Duration.zero, (){
        var afterChangeHash = getValueHash<T>(_value);
        if(beforeChangeHash != afterChangeHash){
          notifyAll();
        }
      });
    }
    return _value;
  }

  set value(T value){
    if(isDependent) {
      throw "this telescope is dependent on "
          "other telescopes and the value can't be set";
    }

    _value = value;

    // prevents recreate view while data is same as old one
    // if(getValueHash(_value) == getValueHash(value)) return;

    notifyAll();

    if(isSavable){
      SharedPreferences.getInstance().then((pref){
        if(_value is OnDiskSavable){
          pref.setString(
              _onDiskId!, (value as OnDiskSavable).toOnDiskString()
          ).then((value){});
        } else if(T == String){
          pref.setString(_onDiskId!, value as String).then((value){});
        }else if(T == int){
          pref.setInt(_onDiskId!, value as int).then((value){});
        }else if(T == double){
          pref.setDouble(_onDiskId!, value as double).then((value){});
        }else if(T == bool){
          pref.setBool(_onDiskId!, value as bool).then((value){});
        }
      });
    }
  }

  void notifyAll(){
    for(Function callback in _callbacks){
      if(callback is Function(VoidCallback)){
        try{
          // it may crash while widget is not mounted
          callback((){});
        } catch(e) {
          print(e);
        }
      }else{
        callback(); // this will make State call build in next frame render
      }
    }
  }

  Telescope<T> _dependOn(List<Telescope> observables, T Function() calculate){
    _value = calculate();
    for(var o in observables){
      o.subscribe((){
        _value = calculate();
        notifyAll();
      });
    }
    return this;
  }

  Telescope<T> _saveOnDisk(String onDiskId){

    if(_value is! OnDiskSavable && !_isBuiltIn()) {
      throw "${T.toString()} is not implementing OnDiskSavable and is not a built-in type(int|string|double|bool)";
    }

    this._onDiskId = onDiskId;
    SharedPreferences.getInstance().then((pref){
      if(_value is OnDiskSavable){

        // not assign while its not on disk yet (keeps default value)
        String? str = pref.getString(onDiskId);
        if(str != null) {
          (_value as OnDiskSavable).parseOnDiskString(str);
        }
      }else{ // built-in types

        // not assign while its not on disk yet (keeps default value)
        if(T == String){
          String? temp = pref.getString(onDiskId);
          if(temp!=null) _value = temp as T;
        }else if (T == int){
          int? temp = pref.getInt(onDiskId);
          if(temp!=null) _value = temp as T;
        }else if (T == double){
          double? temp = pref.getDouble(onDiskId);
          if(temp!=null) _value = temp as T;
        }else if (T == bool){
          bool? temp = pref.getBool(onDiskId);
          if(temp!=null) _value = temp as T;
        }

      }
      notifyAll();
    });
    return this;
  }

  // type that shared preferences supports
  bool _isBuiltIn(){
    return (T == String) ||
        (T == bool) ||
        (T == double) ||
        (T == int);
  }

  static String getValueHash<T>(T value){
    if(value is OnDiskSavable){
      return (value).toOnDiskString();
    }else if(value is TelescopeHash){
      return (value).toTelescopeHash();
    }
    return value.toString();
  }
}
