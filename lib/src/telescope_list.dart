
import 'dart:math';

import 'package:telescope/src/fs/on_disk_save_ability.dart';
import 'package:telescope/src/type_check.dart';

import 'fs/save_and_load.dart';
import 'telescope.dart';


class TelescopeList<T> extends Telescope<List<T>>{

  bool iWillCallNotifyAllForItems = false;
  OnDiskSaveAbility<T>? onDiskSaveAbilityForItems;

  TelescopeList(List<T> items, { this.iWillCallNotifyAllForItems = false })
      : super(items, iWillCallNotifyAll: true);

  TelescopeList.dependsOn(
      List<Telescope> dependencies,
      List<T> Function() calculate,
      { this.iWillCallNotifyAllForItems = false }
  ) : super.dependsOn(dependencies, calculate, iWillCallNotifyAll: true);

  TelescopeList.saveOnDiskForBuiltInType(
      List<T> items,
      String onDiskId,
  ) : super(items, iWillCallNotifyAll: true){
    super.onDiskId = onDiskId;
    if(!TypeCheck.isBuiltIn<T>()) {
      throw "List<${T.toString()}> which ${T.toString()} is not a built-in type(int|string|double|bool)"
          " use saveOnDiskForNonBuiltInType and provide OnDiskSaveAbility";
    }

    SaveAndLoad.loadList<T>(onDiskId, null, (List<T> loaded) {
      holden = loaded;
      notifyAll();
    });
  }

  TelescopeList.saveOnDiskForNonBuiltInType(
      List<T> items,
      String onDiskId,
      this.onDiskSaveAbilityForItems,
      { this.iWillCallNotifyAllForItems = false }
  ) : super(items, iWillCallNotifyAll: true){

    TypeCheck.checkIsValidTypeForItems(items, iWillCallNotifyAllForItems);
    super.onDiskId = onDiskId;
    SaveAndLoad.loadList<T>(onDiskId, onDiskSaveAbilityForItems, (List<T> loaded) {
      holden = loaded;
      notifyAll();
    });
  }

  @override
  set value(List<T> items){
    TypeCheck.checkIsValidTypeForItems(items, iWillCallNotifyAllForItems);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }

    super.holden = items;
  }

  @override
  List<T> get value {
    var beforeChangeHash = holden.map((i)=>i.hashCode).reduce((v, e)=>v*e);
    var empty = holden.isEmpty;
    // push callback to event loop immediately
    Future.delayed(Duration.zero, (){
      var afterChangeHash = holden.map((i)=>i.hashCode).reduce((v, e)=>v*e);
      if(beforeChangeHash != afterChangeHash){
        if(empty){
          TypeCheck.checkIsValidTypeForItems(holden, iWillCallNotifyAllForItems);
        }
        notifyAll();
        if(isSavable){
          SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
        }
      }
    });
    return holden;
  }

  void add(T row){
    if(holden.isEmpty){
      TypeCheck.checkIsValidType(row, iWillCallNotifyAllForItems);
    }
    holden.add(row);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void addAll(Iterable<T> rows){
    if(holden.isEmpty && rows.isNotEmpty){
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    holden.addAll(rows);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void insert(int index, T row){
    if(holden.isEmpty){
      TypeCheck.checkIsValidType(row, iWillCallNotifyAllForItems);
    }
    holden.insert(index, row);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void insertAll(int index, Iterable<T> rows){
    if(holden.isEmpty && rows.isNotEmpty){
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    holden.insertAll(index, rows);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  T? operator [](int index) {
    var beforeChangeHash = holden[index].hashCode;
    var empty = holden.isEmpty;
    // push callback to event loop immediately
    Future.delayed(Duration.zero, (){
      var afterChangeHash = holden[index].hashCode;
      if(beforeChangeHash != afterChangeHash){
        if(empty){
          TypeCheck.checkIsValidTypeForItems(holden, iWillCallNotifyAllForItems);
        }
        notifyAll();
        if(isSavable){
          SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
        }
      }
    });
    return holden[index];
  }

  void operator []=(int index, T val){
    //no need to check type because if list[0]=2 is happening then list[0] is already checked
    holden[index] = val;
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
    notifyAll();
  }

  void remove(T row){
    holden.remove(row);
    notifyAll();

    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void removeAt(int index){
    holden.removeAt(index);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void removeWhere(bool Function(T element) test){
    holden.removeWhere(test);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void clear(){
    holden.clear();
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void sort([int Function(T a, T b)? compare]){
    holden.sort(compare);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }

  void shuffle([Random? random]){
    holden.shuffle(random);
    notifyAll();

    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbilityForItems);
    }
  }
}