
abstract class OnDiskSaveAbility<T>{

  String toOnDiskString(T instance);
  T parseOnDiskString(String data);
}
