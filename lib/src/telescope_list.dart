
import 'dart:math';

import 'package:telescope/src/fs/on_disk_save_ability.dart';
import 'package:telescope/src/type_check.dart';

import 'fs/save_and_load.dart';
import 'telescope.dart';


class TelescopeList<T> extends Telescope<List<T>>{

  bool iWillCallNotifyAllForItems = false;

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
      OnDiskSaveAbility<T>? onDiskSaveAbility,
      { this.iWillCallNotifyAllForItems = false }
  ) : super(items, iWillCallNotifyAll: true){

    super.onDiskId = onDiskId;
    SaveAndLoad.loadList<T>(onDiskId, onDiskSaveAbility!, (List<T> loaded) {
      holden = loaded;
      notifyAll();
    });
  }

  @override
  set value(List<T> items){
    if(value.isEmpty && items.isNotEmpty){
      TypeCheck.checkIsValidType(items[0], iWillCallNotifyAllForItems);
    }
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }

    super.value = items;
  }

  @override
  List<T> get value {
    var beforeChangeHash = holden.map((i)=>i.hashCode).reduce((v, e)=>v*e);
    // push callback to event loop immediately
    Future.delayed(Duration.zero, (){
      var afterChangeHash = holden.map((i)=>i.hashCode).reduce((v, e)=>v*e);
      if(beforeChangeHash != afterChangeHash){
        notifyAll();
        if(isSavable){
          SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
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
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void addAll(Iterable<T> rows){
    if(holden.isEmpty && rows.isNotEmpty){
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    holden.addAll(rows);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void insert(int index, T row){
    if(holden.isEmpty){
      TypeCheck.checkIsValidType(row, iWillCallNotifyAllForItems);
    }
    holden.insert(index, row);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void insertAll(int index, Iterable<T> rows){
    if(holden.isEmpty && rows.isNotEmpty){
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    holden.insertAll(index, rows);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  T? operator [](int index) {
    var beforeChangeHash = holden[index].hashCode;
    // push callback to event loop immediately
    Future.delayed(Duration.zero, (){
      var afterChangeHash = holden[index].hashCode;
      if(beforeChangeHash != afterChangeHash){
        notifyAll();
        if(isSavable){
          SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
        }
      }
    });
    return holden[index];
  }

  void operator []=(int index, T val){
    holden[index] = val;
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
    notifyAll();
  }

  void remove(T row){
    holden.remove(row);
    notifyAll();

    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void removeAt(int index){
    holden.removeAt(index);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void removeWhere(bool Function(T element) test){
    holden.removeWhere(test);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void clear(){
    holden.clear();
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void sort([int Function(T a, T b)? compare]){
    holden.sort(compare);
    notifyAll();
    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }

  void shuffle([Random? random]){
    holden.shuffle(random);
    notifyAll();

    if(isSavable){
      SaveAndLoad.saveList(onDiskId!, holden, onDiskSaveAbility);
    }
  }
}