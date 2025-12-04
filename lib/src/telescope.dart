import 'dart:collection';
import 'dart:math';

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

  // Integer key is for dispose purposes, It used in removeListener to remove callback
  final HashMap<int, Function> _callbacks = HashMap();

  bool iWillCallNotifyAll = false;

  bool isDependent = false;

  String? onDiskId;

  bool get isSavable => onDiskId != null;
  OnDiskSaveAbility<T>? onDiskSaveAbility;

  // Prevent renew random instance every time we need random value
  Random random = Random();

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

  /// Async version of [Telescope.dependsOn]
  /// Use this if you need to use await in calculate function
  /// [isCalculating] will update to true on calculate start and update to false on calculate ends
  /// [enableCaching] = true will enable caching
  /// [cacheExpireTime] will expire cache after Duration. don't forget to pass [enableCaching] = true
  /// [debounceTime] will call your async function only if a given time has passed without any changes on dependencies.
  Telescope.dependsOnAsync(
    this.holden,
    List<Telescope> dependencies,
    Future<T> Function() calculate, {
    this.iWillCallNotifyAll = false,
    Telescope<bool>? isCalculating,
    bool enableCaching = false,
    Duration? cacheExpireTime,
    Duration debounceTime = Duration.zero,
  }) {
    var hashmap = HashMap<int, T>();
    var expireTimeMap = HashMap<int, DateTime>();

    bool isExpired(int key) {
      if (cacheExpireTime == null) return false;
      if (!expireTimeMap.containsKey(key)) return true;
      return expireTimeMap[key]!.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch;
    }

    int getDependenciesHash() {
      return dependencies
          .map((e) => e.value.hashCode)
          .reduce((value, element) => value * element);
    }

    Future<T> cal() async {
      if (!enableCaching) return await calculate();
      var key = getDependenciesHash();
      if (hashmap.containsKey(key) && !isExpired(key)) {
        return hashmap[key] as T;
      }
      return await calculate();
    }

    void calAndUpdate() {
      isCalculating?.value = true;
      int dh = getDependenciesHash();
      void inner() {
        cal().then((value) {
          if (enableCaching) {
            hashmap[dh] = value;
            if (cacheExpireTime != null) {
              var expTime = DateTime.now().add(cacheExpireTime);
              expireTimeMap[dh] = expTime;
              Future.delayed(cacheExpireTime, () {
                expireTimeMap.remove(dh);
              });
            }
          }
          int cdh = getDependenciesHash();
          if (dh != cdh) return;
          holden = value;
          isCalculating?.value = false;
          notifyAll();
        });
      }

      if (debounceTime != Duration.zero) {
        Future.delayed(debounceTime, () {
          int cdh = getDependenciesHash();
          if (dh != cdh) return;
          inner();
        });
      } else {
        inner();
      }
    }

    calAndUpdate();
    for (var o in dependencies) {
      o.subscribe(() {
        calAndUpdate();
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

    SaveAndLoad.load<T>(onDiskId!, onDiskSaveAbility).then((loaded) {
      if (loaded != null) {
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

    SaveAndLoad.load(onDiskId!, onDiskSaveAbility!).then((loaded) {
      if (loaded != null) {
        holden = loaded;
        notifyAll();
      }
    });
  }

  /// [callback] will call when ever value get change
  int subscribe(Function callback) {
    final id = new64BitRandom();
    _callbacks[id] = callback;
    return id;
  }

  /// [state] will rebuild on value change
  /// and this function also returns value to use it on build function.
  @Deprecated("Use TelescopeBuilder instead")
  T watch(State state) {
    subscribe(state.setState);
    return holden;
  }

  /// Add listener without triggering widget rebuild.
  /// Useful when you only want to execute code on value change.
  /// Integer that returned by this function used in remove listener
  /// So widget can call remove listener on dispatch.
  int addListener(Function(T) listener) {
    final id = new64BitRandom();
    _callbacks[id] = () => listener(this.holden);
    return id;
  }

  /// Remove listener added by [addListener]
  /// Id is random integer generated by addListener
  void removeListener(int id) {
    _callbacks.remove(id);
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
    for (Function callback in _callbacks.values) {
      if (callback is Function(VoidCallback)) {
        try {
          callback(() {});
        } catch (e) {
          /*ignore*/
        }
      } else {
        callback();
      }
    }
  }

  int new64BitRandom() {
    final left = this.random.nextInt(1 << 31);
    final right = this.random.nextInt(1 << 32);
    final combined = (left.toUnsigned(32) << 32) | right.toUnsigned(32);
    return combined.toSigned(64);
  }
}
