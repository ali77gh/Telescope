import 'dart:math';

import 'package:telescope/src/fs/on_disk_save_ability.dart';
import 'package:telescope/src/type_check.dart';

import 'fs/save_and_load.dart';
import 'telescope.dart';

/// Telescope implementation for list
class TelescopeList<T> extends Telescope<List<T>> {
  bool iWillCallNotifyAllForItems = false;
  OnDiskSaveAbility<T>? onDiskSaveAbilityForItems;

  /// main constructor without on disk save or depends on
  /// [T] should be built in type or implements int hashCode getter otherwise you should pass [iWillCallNotifyAllForItems]=true to bypass error and call notifyAll after any changes to take effect
  TelescopeList(List<T> items, {this.iWillCallNotifyAllForItems = false})
      : super(items, iWillCallNotifyAll: true);

  /// depends on is type of telescope object that can depend on other telescope objects
  /// and will update itself when dependencies get changes
  /// [dependencies] are list of telescopes that this telescope is depend on.
  /// [calculate] will call when ever dependencies get change
  TelescopeList.dependsOn(
      List<Telescope> dependencies, List<T> Function() calculate,
      {this.iWillCallNotifyAllForItems = false})
      : super.dependsOn(dependencies, calculate, iWillCallNotifyAll: true);

  /// you can save built in type easily on disk by using this constructor
  /// [onDiskId] should be unique id.
  TelescopeList.saveOnDiskForBuiltInType(
      List<T> items,
      String onDiskId,
      ) : super(items, iWillCallNotifyAll: true) {
    super.onDiskId = onDiskId;
    if (!TypeCheck.isBuiltIn<T>()) {
      throw "List<${T.toString()}> which ${T.toString()} is not a built-in type(int|string|double|bool)"
          " use saveOnDiskForNonBuiltInType and provide OnDiskSaveAbility";
    }

    SaveAndLoad.loadList<T>(onDiskId, null).then((loaded) {
      if (loaded != null) {
        holden = loaded;
        notifyAll();
      }
    });
  }

  /// you can save non built in type on disk by using this constructor
  /// [onDiskId] should be unique id.
  /// [onDiskSaveAbility] used for serialize and deserialize your object to string before saving and after loading.
  /// [T] should be built in type or implements int hashCode getter otherwise you should pass [iWillCallNotifyAllForItems]=true to bypass error and call notifyAll after any changes to take effect
  TelescopeList.saveOnDiskForNonBuiltInType(
      List<T> items, String onDiskId, this.onDiskSaveAbilityForItems,
      {this.iWillCallNotifyAllForItems = false})
      : super(items, iWillCallNotifyAll: true) {
    TypeCheck.checkIsValidTypeForItems(items, iWillCallNotifyAllForItems);
    super.onDiskId = onDiskId;

    SaveAndLoad.loadList<T>(onDiskId, onDiskSaveAbilityForItems).then((loaded) {
      if (loaded != null) {
        holden = loaded;
        notifyAll();
      }
    });
  }

  /// will set value and call [notifyAll]
  @override
  set value(List<T> items) {
    TypeCheck.checkIsValidTypeForItems(items, iWillCallNotifyAllForItems);
    super.holden = items; // set before notifying
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  /// Returns value of telescope
  /// Will call [notifyAll] after change detected by hashcode
  /// You can use holden if you don't need hashCode and change detection
  @override
  List<T> get value {
    if (holden.isEmpty) return holden;
    var beforeChangeHash =
    holden.map((i) => i.hashCode).reduce((v, e) => v * e);

    // push callback to event loop immediately
    Future.delayed(Duration.zero, () {
      var afterChangeHash =
      holden.map((i) => i.hashCode).reduce((v, e) => v * e);
      if (beforeChangeHash != afterChangeHash) {
        notifyAll();
        if (isSavable) {
          SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
        }
      }
    });
    return holden;
  }

  ///same as list but calls [notifyAll]
  void add(T row) {
    if (holden.isEmpty) {
      TypeCheck.checkIsValidType(row, iWillCallNotifyAllForItems);
    }
    holden.add(row);
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void addAll(Iterable<T> rows) {
    if (holden.isEmpty && rows.isNotEmpty) {
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    holden.addAll(rows);
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void insert(int index, T row) {
    if (holden.isEmpty) {
      TypeCheck.checkIsValidType(row, iWillCallNotifyAllForItems);
    }
    holden.insert(index, row);
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void insertAll(int index, Iterable<T> rows) {
    if (holden.isEmpty && rows.isNotEmpty) {
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    holden.insertAll(index, rows);
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  T? operator [](int index) {
    return holden[index];
  }

  ///same as list but calls [notifyAll]
  void operator []=(int index, T val) {
    holden[index] = val;
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
    notifyAll();
  }

  ///same as list but calls [notifyAll]
  void remove(T row) {
    holden.remove(row);
    notifyAll();

    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void removeAt(int index) {
    holden.removeAt(index);
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void removeWhere(bool Function(T element) test) {
    holden.removeWhere(test);
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void clear() {
    holden.clear();
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void sort([int Function(T a, T b)? compare]) {
    holden.sort(compare);
    notifyAll();
    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }

  ///same as list but calls [notifyAll]
  void shuffle([Random? random]) {
    holden.shuffle(random);
    notifyAll();

    if (isSavable) {
      SaveAndLoad.saveList(onDiskId!, onDiskSaveAbilityForItems, holden);
    }
  }
}
