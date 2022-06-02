
import 'package:flutter/material.dart';

class Observable<T>{

  T? _value;
  final Set<Function> _callbacks = <Function>{};

  Observable(T? defaultValue){
    _value = defaultValue;
  }

  void subscribe(Function callback){
      _callbacks.add(callback);
  }

  /// ```dart
  /// pass null while you don't need callback
  /// ```
  T? get(State? state){
    if(state!=null) subscribe(state.setState);
    return _value;
  }

  set value(T? value){
    if(_value.hashCode == value.hashCode) return; // prevents recreate view while data is same as old one
    _value = value;
    notifyAll();
  }

  void notifyAll(){
    for(Function callback in _callbacks){
      if(callback is Function(VoidCallback)){
        callback((){});
      }else{
        callback(); // this will make State call build in next frame render
      }
    }
  }
}