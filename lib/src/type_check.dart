class TypeCheck {
  // type that shared preferences supports
  static bool isBuiltIn<T>() {
    return (T == String) || (T == bool) || (T == double) || (T == int);
  }

  static bool implementsHashCodeProperty<T>(T value) {
    if (value == null) {
      return true;
    } // can't check it so we will wait until next value set
    return value.hashCode != identityHashCode(value);
  }

  static checkIsValidType<T>(T value, bool iWillCallNotifyAll) {
    if (!iWillCallNotifyAll) {
      if (!isBuiltIn<T>() && !implementsHashCodeProperty<T>(value)) {
        throw "Telescope Error: ${T.toString()} is not implementing hashCode and is not a built-in type(int|string|double|bool)"
            " so there is no way to detect object changes "
            "you have two options: "
            "1. implement hashCode on ${T.toString()} if you can (recommended) "
            "2. pass iWillCallNotifyAll=true to bypass error and call yourTelescopeObject.notifyAll() everytime you change something on it's value";
      }
    }
  }

  static checkIsValidTypeForItems<T>(
      List<T> items, bool iWillCallNotifyAllForItems) {
    if (items.isEmpty) return;
    checkIsValidType<T>(items[0], iWillCallNotifyAllForItems);
  }
}
