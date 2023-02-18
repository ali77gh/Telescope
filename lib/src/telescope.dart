
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:telescope/src/on_disk_savable.dart';

// TODO make apply automatic for non-built-in types
// TODO make other data structures (map, set,...)

class Telescope<T>{

  T _value;
  final Set<Function> _callbacks = <Function>{};

  String? _onDiskId;
  bool get isSavable => _onDiskId != null;
  bool isDependent = false;

  // TODO T should not be list or map or set ,... show the guide
  Telescope(this._value);

  void subscribe(Function callback){
      _callbacks.add(callback);
  }

  // TODO updateIf -> bool Function(T oldValue, T newValue) updateIf
  T watch(State state){

    subscribe(state.setState);
    return _value;
  }

  T get value {
    return _value;
  }

  set value(T value){
    if(isDependent) {
      throw "this telescope is dependent on "
          "other telescopes and the value can't be set";
    }

    if(_value.hashCode == value.hashCode) return; // prevents recreate view while data is same as old one
    _value = value;
    _notifyAll();

    if(isSavable){
      SharedPreferences.getInstance().then((pref){
        if(T is OnDiskSavable){
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

  void _notifyAll(){
    for(Function callback in _callbacks){
      if(callback is Function(VoidCallback)){
        try{
          // it may crash while widget is not mounted
          // TODO check this and remove print
          callback((){});
        } catch(e) {
          print(e);
        }
      }else{
        callback(); // this will make State call build in next frame render
      }
    }
  }

  void apply({ Function(T? value)? change }){
    if(change != null) change(_value);
    _notifyAll();
  }

  // TODO move this to constructor as optional param (then it will not shows up everywhere on auto-complete and cant be call twice)
  Telescope<T> dependOn(List<Telescope> observables, T Function() calculate){
    if(isSavable){
      throw "${T.toString()} is a onDiskSavable object and cant be depend on something!";
    }
    for(var o in observables){
      o.subscribe((){
        _value = calculate();
        _notifyAll();
      });
    }
    return this;
  }

  // TODO move this to constructor as optional param (then it will not shows up everywhere on auto-complete and cant be call twice)
  Telescope<T> saveOnDisk(String onDiskId){
    if(isDependent){
      throw "${T.toString()} is a dependent object and save on disk seems to be wrong!";
    }

    if(T is! OnDiskSavable && !_isBuiltIn()) {
      throw "${T.toString()} is not implementing OnDiskSavable and is not a built-in type(int|string|double|bool)";
    }

    this._onDiskId = onDiskId;
    SharedPreferences.getInstance().then((pref){
      if(T is OnDiskSavable){

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
      _notifyAll();
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

}