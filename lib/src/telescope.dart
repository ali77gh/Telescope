
import 'package:flutter/material.dart';

class Telescope<T>{

  T _value;
  final Set<Function> _callbacks = <Function>{};

  Telescope(this._value);

  void subscribe(Function callback){
      _callbacks.add(callback);
  }

  /// ```dart
  /// pass null while you don't need callback
  /// ```
  T watch(State state){
    subscribe(state.setState);
    return _value;
  }

  T get value {
    return _value;
  }

  set value(T value){
    if(_value.hashCode == value.hashCode) return; // prevents recreate view while data is same as old one
    _value = value;
    _notifyAll();
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

  Telescope<T> dependOn(List<Telescope> observables, T Function() calculate){
    for(var o in observables){
      o.subscribe((){
        _value = calculate();
        _notifyAll();
      });
    }
    return this;
  }
}