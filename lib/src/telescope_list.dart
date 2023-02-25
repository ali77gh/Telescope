
import 'dart:math';

import 'depends_on_telescope.dart';
import 'on_disk_savable.dart';
import 'telescope_hash.dart';
import 'telescope.dart';


class TelescopeList<T> extends Telescope<List<T>>{

  // TODO onDiskId and save on disk
  TelescopeList(List<T> items, {DependsOnTelescope<List<T>>? dependsOn})
      : super(items, dependsOn: dependsOn, iWillCallNotifyAll: true);

  void add(T row){ value.add(row); notifyAll(); }
  void addAll(Iterable<T> rows){ value.addAll(rows); notifyAll(); }
  void insert(int index, T row){ value.insert(index, row); notifyAll(); }
  void insertAll(int index, Iterable<T> rows){ value.insertAll(index, rows); notifyAll(); }

  T? operator [](int index) => value[index];

  void operator []=(int index, T val){ value[index] = val; notifyAll(); }

  void remove(T row){ value.remove(row); notifyAll(); }
  void removeAt(int index){ value.removeAt(index); notifyAll(); }
  void removeWhere(bool Function(T element) test){ value.removeWhere(test); notifyAll(); }
  void clear(){ value.clear(); notifyAll(); }

  void sort([int Function(T a, T b)? compare]){ value.sort(compare); notifyAll(); }
  void shuffle([Random? random]){ value.shuffle(random); notifyAll();}
}