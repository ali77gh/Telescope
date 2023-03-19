/// [OnDiskSaveAbility] used for serialize and deserialize your object to string before saving and after loading.
abstract class OnDiskSaveAbility<T> {
  /// will call before saving on disk
  String toOnDiskString(T instance);

  /// will call after loading from disk
  T parseOnDiskString(String data);
}
