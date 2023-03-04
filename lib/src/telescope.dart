import 'package:flutter/material.dart';
import 'package:telescope/src/fs/save_and_load.dart';

import 'fs/on_disk_savable.dart';

// TODO make other data structures (map, set,...)
// TODO add standard docs to functions
// TODO move type validation to other file as static method to be usable from Telescope list

class Telescope<T>{

  late T _value;
  final Set<Function> _callbacks = <Function>{};

  String? _onDiskId;
  bool get isSavable => _onDiskId != null;
  bool isDependent = false;
  bool iWillCallNotifyAll;

  Telescope.dependsOn(List<Telescope> dependencies, T Function() calculate,{this.iWillCallNotifyAll=false}){
    _value = calculate();
    for(var o in dependencies){
      o.subscribe((){
        _value = calculate();
        notifyAll();
      });
    }
  }

  Telescope.saveOnDisk(this._value, String onDiskId,{this.iWillCallNotifyAll=false}){

    if(_value is! OnDiskSavable && !_isBuiltIn()) {
      throw "${T.toString()} is not implementing OnDiskSavable and is not a built-in type(int|string|double|bool)";
    }

    _onDiskId = onDiskId;

    if( _value==null && !_isBuiltIn() ){
      throw "please pass a non null value to Telescope.saveOnDisk (telescope needs it for deserialization)";
    }
    SaveAndLoad.load<T>(_value, onDiskId, (T loaded) {
      _value = loaded;
      notifyAll();
    });
  }

  Telescope(this._value,{this.iWillCallNotifyAll=false}){
    _checkIsValidType();
  }

  void subscribe(Function callback){
    _callbacks.add(callback);
  }

  T watch(State state){
    subscribe(state.setState);
    return _value;
  }


  T get value {
    var beforeChangeHash = _value.hashCode;
    // push callback to event loop immediately
    Future.delayed(Duration.zero, (){
      var afterChangeHash = _value.hashCode;
      if(beforeChangeHash != afterChangeHash){
        notifyAll();
      }
    });
    return _value;
  }

  set value(T value){
    if(isDependent) {
      throw "this telescope is dependent on "
          "other telescopes and the value can't be set";
    }

    if(_value==null){
      _checkIsValidType();
    }

    _value = value;

    notifyAll();

    if(isSavable){
      SaveAndLoad.save(_onDiskId!,_value);
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

  // type that shared preferences supports
  bool _isBuiltIn(){
    return (T == String) ||
        (T == bool) ||
        (T == double) ||
        (T == int);
  }

  bool _implementsHashCodeProperty(){
    if(_value == null) return true; // can't check it so we will wait until next value set
    return _value.hashCode != identityHashCode(_value);
  }

  bool _checkIsValidType(){
    if(!iWillCallNotifyAll){
      if(!_isBuiltIn() && !_implementsHashCodeProperty()){
        throw "Telescope Error: ${T.toString()} is not implementing OnDiskSavable or hashCode and is not a built-in type(int|string|double|bool)"
            " so there is no way to detect object changes "
            "you have two options: "
            "1. implement hashCode on ${T.toString()} if you can (recommended) "
            "2. pass iWillCallNotifyAll to bypass error and call yourTelescopeObject.notifyAll() everytime you change something on it's value";
      }
    }
    return true;
  }

}