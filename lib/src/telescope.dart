import 'package:flutter/material.dart';
import 'package:telescope/src/fs/save_and_load.dart';
import 'package:telescope/src/type_check.dart';

import 'fs/on_disk_save_ability.dart';

/// Observable pattern witch can call setState of your States
///   and also have on disk save and depends on
///   [T] should be built in type or implements int hashCode getter
class Telescope<T> {
  /// don't touch [holden] use [value] instead
  @protected
  late T holden;
  final Set<Function> _callbacks = <Function>{};

  bool iWillCallNotifyAll = false;

  bool isDependent = false;

  String? onDiskId;
  bool get isSavable => onDiskId != null;
  OnDiskSaveAbility<T>? onDiskSaveAbility;

  /// main constructor without on disk save or depends on
  /// [T] should be built in type or implements int hashCode getter otherwise you should pass [iWillCallNotifyAll]=true to bypass error and call notifyAll after any changes to take effect
  Telescope(this.holden, {this.iWillCallNotifyAll = false}) {
    TypeCheck.checkIsValidType<T>(holden, iWillCallNotifyAll);
  }

  /// depends on is type of telescope object that can depend on other telescope objects
  /// and will update itself when dependencies get changes
  /// [dependencies] are list of telescopes that this telescope is depend on.
  /// [calculate] will call when ever dependencies get change
  Telescope.dependsOn(List<Telescope> dependencies, T Function() calculate,
      {this.iWillCallNotifyAll = false}) {
    holden = calculate();
    for (var o in dependencies) {
      o.subscribe(() {
        holden = calculate();
        notifyAll();
      });
    }
  }

  /// you can save built in type easily on disk by using this constructor
  /// [onDiskId] should be unique id.
  Telescope.saveOnDiskForBuiltInType(this.holden, this.onDiskId) {
    if (!TypeCheck.isBuiltIn<T>()) {
      throw "${T.toString()} is not a built-in type(int|string|double|bool)"
          " use saveOnDiskForNonBuiltInType and provide OnDiskSaveAbility";
    }

    SaveAndLoad.load<T>(onDiskId!, onDiskSaveAbility).then((loaded){
      if(loaded!=null){
        holden = loaded;
        notifyAll();
      }
    });
  }

  /// you can save non built in type on disk by using this constructor
  /// [onDiskId] should be unique id.
  /// [onDiskSaveAbility] used for serialize and deserialize your object to string before saving and after loading.
  /// [T] should be built in type or implements int hashCode getter otherwise you should pass [iWillCallNotifyAll]=true to bypass error and call notifyAll after any changes to take effect
  Telescope.saveOnDiskForNonBuiltInType(
      this.holden, this.onDiskId, this.onDiskSaveAbility,
      {this.iWillCallNotifyAll = false}) {
    TypeCheck.checkIsValidType(holden, iWillCallNotifyAll);

    SaveAndLoad.load(onDiskId!, onDiskSaveAbility!).then((loaded){
      if(loaded != null){
        holden = loaded;
        notifyAll();
      }
    });

  }

  /// [callback] will call when ever value get change
  void subscribe(Function callback) {
    _callbacks.add(callback);
  }

  /// [state] will rebuild on value change
  /// and this function also returns value to use it on build function.
  T watch(State state) {
    // ignore: invalid_use_of_protected_member
    subscribe(state.setState);
    return holden;
  }

  /// Returns value of telescope
  /// Will call [notifyAll] after change detected by hashcode
  /// You can use holden if you don't need hashCode and change detection
  T get value {
    var beforeChangeHash = holden.hashCode;
    // push callback to event loop immediately
    Future.delayed(Duration.zero, () {
      var afterChangeHash = holden.hashCode;
      if (beforeChangeHash != afterChangeHash) {
        notifyAll();
        if (isSavable) {
          SaveAndLoad.save(onDiskId!, onDiskSaveAbility, holden);
        }
      }
    });
    return holden;
  }

  /// will set value and call [notifyAll]
  set value(T value) {
    if (isDependent) {
      throw "this telescope is dependent on "
          "other telescopes and the value can't be set";
    }

    if (holden == null) {
      TypeCheck.checkIsValidType<T>(holden, iWillCallNotifyAll);
    }

    holden = value;

    notifyAll();

    if (isSavable) {
      SaveAndLoad.save(onDiskId!, onDiskSaveAbility, holden);
    }
  }

  /// this will call build on every watchers and call all callback functions.
  void notifyAll() {
    for (Function callback in _callbacks) {
      if (callback is Function(VoidCallback)) {
        try {
          // it may crash while widget is not mounted
          callback(() {});
        } catch (e) {/*ignore*/}
      } else {
        callback(); // this will make State call build in next frame render
      }
    }
  }
}
