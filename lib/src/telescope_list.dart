
import 'dart:math';

import 'package:telescope/telescope.dart';

class TelescopeList<T> extends Telescope<List<T>>{

  TelescopeList() : super([]);

  void add(T row) =>
      apply(change:(list){ list!.add(row); });
  void addAll(Iterable<T> rows) =>
      apply(change:(list){ list!.addAll(rows); });
  void insert(int index, T row) =>
      apply(change:(list){ list!.insert(index, row); });
  void insertAll(int index, Iterable<T> rows) =>
      apply(change:(list){ list!.insertAll(index,rows); });

  // TODO add [] operator setter and getter

  void remove(T row) =>
      apply(change:(list){ list!.remove(row); });
  void removeAt(int index) =>
      apply(change:(list){ list!.removeAt(index); });
  void removeWhere(bool Function(T element) test) =>
      apply(change:(list){ list!.removeWhere(test); });
  void clear() =>
      apply(change:(list){ list!.clear(); });

  void sort([int Function(T a, T b)? compare]) =>
      apply(change:(list){ list!.sort(compare); });
  void shuffle([Random? random]) =>
      apply(change:(list){ list!.shuffle(random); });
}