
import 'package:flutter/material.dart';

class Observable<T>{

  T? _value;
  final Set<State> _states = <State>{};

  Observable(T? defaultValue){
    _value = defaultValue;
  }

  /// ```dart
  /// pass null while you don't need callback
  /// ```
  T? get(State? state){
    if(state!=null) _states.add(state);
    return _value;
  }

  set value(T? value){
    if(_value.hashCode == value.hashCode) return; // prevents recreate view while data is same as old one
    _value = value;
    notifyAll();
  }

  void notifyAll(){
    for(State state in _states){
      state.setState(() {}); // this will make State call build in next frame render
    }
  }
}