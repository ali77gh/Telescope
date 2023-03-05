import 'package:flutter/material.dart';
import 'package:telescope/src/fs/save_and_load.dart';
import 'package:telescope/src/type_check.dart';

import 'fs/on_disk_savable.dart';

// TODO make other data structures (map, set,...)
// TODO add standard docs to functions

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

    if(_value is! OnDiskSavable && !TypeCheck.isBuiltIn<T>()) {
      throw "${T.toString()} is not implementing OnDiskSavable and is not a built-in type(int|string|double|bool)";
    }

    _onDiskId = onDiskId;

    if( _value==null && !TypeCheck.isBuiltIn<T>() ){
      throw "please pass a non null value to Telescope.saveOnDisk (telescope needs it for deserialization)";
    }
    SaveAndLoad.load<T>(_value, onDiskId, (T loaded) {
      _value = loaded;
      notifyAll();
    });
  }

  Telescope(this._value,{this.iWillCallNotifyAll=false}){
    TypeCheck.checkIsValidType<T>(_value, iWillCallNotifyAll);
  }

  void subscribe(Function callback){
    _callbacks.add(callback);
  }

  T watch(State state){
    subscribe(state.setState);
    return _value;
  }

  T get value {
    var beforeChangeHash = hash(_value);
    // push callback to event loop immediately
    Future.delayed(Duration.zero, (){
      var afterChangeHash = hash(_value);
      if(beforeChangeHash != afterChangeHash){
        notifyAll();
      }
    });
    return _value;
  }

  int hash(T v){
    if(v is List){
        return v.map((i) => i.hashCode)
            .reduce((value, element) => value * element);
    } else {
      return v.hashCode;
    }
  }

  set value(T value){
    if(isDependent) {
      throw "this telescope is dependent on "
          "other telescopes and the value can't be set";
    }

    if(_value==null){
      TypeCheck.checkIsValidType<T>(_value,iWillCallNotifyAll);
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

}