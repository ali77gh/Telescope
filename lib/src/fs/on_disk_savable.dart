
mixin OnDiskSavable{

  String toOnDiskString();
  void parseOnDiskString(String data);

  @override
  int get hashCode => toOnDiskString().hashCode;

  @override
  bool operator ==(Object other) =>
      (hashCode==other.hashCode) &&
          (runtimeType==other.runtimeType);
}