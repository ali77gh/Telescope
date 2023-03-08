import 'package:flutter/material.dart';
import 'package:telescope/src/fs/save_and_load.dart';
import 'package:telescope/src/type_check.dart';

import 'fs/on_disk_save_ability.dart';

// TODO make other data structures (map, set,...)
// TODO add standard docs to functions

class Telescope<T>{

  late T _value;
  final Set<Function> _callbacks = <Function>{};

  bool iWillCallNotifyAll=false;

  bool isDependent = false;

  String? onDiskId;
  bool get isSavable => onDiskId != null;
  OnDiskSaveAbility<T>? onDiskSaveAbility;

  Telescope.dependsOn(List<Telescope> dependencies, T Function() calculate,{this.iWillCallNotifyAll=false}){
    _value = calculate();
    for(var o in dependencies){
      o.subscribe((){
        _value = calculate();
        notifyAll();
      });
    }
  }

  Telescope.saveOnDiskForBuiltInType(this._value, this.onDiskId){

    if(!TypeCheck.isBuiltIn<T>()) {
      throw "${T.toString()} is not a built-in type(int|string|double|bool)"
          " use saveOnDiskForNonBuiltInType and provide OnDiskSaveAbility";
    }

    SaveAndLoad.load<T>(onDiskSaveAbility, onDiskId!, (T loaded) {
      _value = loaded;
      notifyAll();
    });
  }

  Telescope.saveOnDiskForNonBuiltInType(this._value, this.onDiskId, this.onDiskSaveAbility, { this.iWillCallNotifyAll = false }){

    SaveAndLoad.load<T>(onDiskSaveAbility!, onDiskId!, (T loaded) {
      _value = loaded;
      notifyAll();
    });

  }

  Telescope(this._value, {this.iWillCallNotifyAll=false}){
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
        if(isSavable){
          SaveAndLoad.save(onDiskId!, _value, onDiskSaveAbility);
        }
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
      TypeCheck.checkIsValidType<T>(_value, iWillCallNotifyAll);
    }

    _value = value;

    notifyAll();

    if(isSavable){
      SaveAndLoad.save(onDiskId!, _value, onDiskSaveAbility);
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