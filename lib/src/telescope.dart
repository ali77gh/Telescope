import 'package:flutter/material.dart';
import 'package:telescope/src/fs/save_and_load.dart';
import 'package:telescope/src/type_check.dart';

import 'fs/on_disk_save_ability.dart';

// TODO make other data structures (map, set,...)
// TODO add standard docs to functions

class Telescope<T>{

  @protected
  late T holden;
  final Set<Function> _callbacks = <Function>{};

  bool iWillCallNotifyAll=false;

  bool isDependent = false;

  String? onDiskId;
  bool get isSavable => onDiskId != null;
  OnDiskSaveAbility<T>? onDiskSaveAbility;

  Telescope.dependsOn(List<Telescope> dependencies, T Function() calculate,{this.iWillCallNotifyAll=false}){
    holden = calculate();
    for(var o in dependencies){
      o.subscribe((){
        holden = calculate();
        notifyAll();
      });
    }
  }

  Telescope.saveOnDiskForBuiltInType(this.holden, this.onDiskId){

    if(!TypeCheck.isBuiltIn<T>()) {
      throw "${T.toString()} is not a built-in type(int|string|double|bool)"
          " use saveOnDiskForNonBuiltInType and provide OnDiskSaveAbility";
    }

    SaveAndLoad.load<T>(onDiskSaveAbility, onDiskId!, (T loaded) {
      holden = loaded;
      notifyAll();
    });
  }

  Telescope.saveOnDiskForNonBuiltInType(this.holden, this.onDiskId, this.onDiskSaveAbility, { this.iWillCallNotifyAll = false }){

    SaveAndLoad.load<T>(onDiskSaveAbility!, onDiskId!, (T loaded) {
      holden = loaded;
      notifyAll();
    });

  }

  Telescope(this.holden, {this.iWillCallNotifyAll=false}){
    TypeCheck.checkIsValidType<T>(holden, iWillCallNotifyAll);
  }

  void subscribe(Function callback){
    _callbacks.add(callback);
  }

  T watch(State state){
    subscribe(state.setState);
    return holden;
  }

  T get value {
    var beforeChangeHash = holden.hashCode;
    // push callback to event loop immediately
    Future.delayed(Duration.zero, (){
      var afterChangeHash = holden.hashCode;
      if(beforeChangeHash != afterChangeHash){
        notifyAll();
        if(isSavable){
          SaveAndLoad.save(onDiskId!, holden, onDiskSaveAbility);
        }
      }
    });
    return holden;
  }

  set value(T value){
    if(isDependent) {
      throw "this telescope is dependent on "
          "other telescopes and the value can't be set";
    }

    if(holden==null){
      TypeCheck.checkIsValidType<T>(holden, iWillCallNotifyAll);
    }

    holden = value;

    notifyAll();

    if(isSavable){
      SaveAndLoad.save(onDiskId!, holden, onDiskSaveAbility);
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