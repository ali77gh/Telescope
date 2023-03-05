
import 'dart:math';

import 'package:telescope/src/type_check.dart';

import 'telescope.dart';


class TelescopeList<T> extends Telescope<List<T>>{

  bool iWillCallNotifyAllForItems = false;

  TelescopeList(List<T> items, {this.iWillCallNotifyAllForItems = false})
      : super(items, iWillCallNotifyAll: true);

  TelescopeList.dependsOn(
      List<Telescope> dependencies,
      List<T> Function() calculate,
      {this.iWillCallNotifyAllForItems=false}
  ) : super.dependsOn(dependencies, calculate, iWillCallNotifyAll: true);

  //TODO add support of on disk to telescope list
  // TelescopeList.saveOnDisk(
  //     List<T> items,
  //     String onDiskId,
  //     {iWillCallNotifyAll=false}
  // ) : super.saveOnDisk(items, onDiskId, iWillCallNotifyAll: iWillCallNotifyAll);

  // TODO add iterator
  // TODO check items change on item get with hashCode technic

  @override
  set value(List<T> items){
    if(value.isEmpty && items.isNotEmpty){
      TypeCheck.checkIsValidType(items[0], iWillCallNotifyAllForItems);
    }
    super.value = items;
  }

  void add(T row){
    if(value.isEmpty){
      TypeCheck.checkIsValidType(row, iWillCallNotifyAllForItems);
    }
    value.add(row);
    notifyAll();
  }
  void addAll(Iterable<T> rows){
    if(value.isEmpty && rows.isNotEmpty){
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    value.addAll(rows);
    notifyAll();
  }
  void insert(int index, T row){
    if(value.isEmpty){
      TypeCheck.checkIsValidType(row, iWillCallNotifyAllForItems);
    }
    value.insert(index, row);
    notifyAll();
  }
  void insertAll(int index, Iterable<T> rows){
    if(value.isEmpty && rows.isNotEmpty){
      TypeCheck.checkIsValidType(rows.first, iWillCallNotifyAllForItems);
    }
    value.insertAll(index, rows);
    notifyAll();
  }

  T? operator [](int index) => value[index];

  void operator []=(int index, T val){ value[index] = val; notifyAll(); }

  void remove(T row){ value.remove(row); notifyAll(); }
  void removeAt(int index){ value.removeAt(index); notifyAll(); }
  void removeWhere(bool Function(T element) test){ value.removeWhere(test); notifyAll(); }
  void clear(){ value.clear(); notifyAll(); }

  void sort([int Function(T a, T b)? compare]){ value.sort(compare); notifyAll(); }
  void shuffle([Random? random]){ value.shuffle(random); notifyAll();}
}