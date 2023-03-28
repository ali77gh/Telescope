import 'package:telescope/src/fs/on_disk_save_ability.dart';
import 'package:telescope/src/fs/save_and_load.dart';
import 'package:test/test.dart';

// Unit tests are here
// Integration tests are in /examples

void main() {
  saveAndLoad();
  saveAndLoadList();
}

class Human {
  String name = "";
  @override
  int get hashCode => name.hashCode;
}

class HumanSerializer extends OnDiskSaveAbility<Human> {
  @override
  Human parseOnDiskString(String data) => Human()..name = data;
  @override
  String toOnDiskString(Human instance) => instance.name;
}

void saveAndLoad() {
  group("save and load", () {
    test("string", () async {
      await SaveAndLoad.save("save-me", null, "value");
      var loaded = await SaveAndLoad.load<String>("save-me", null);
      expect(loaded, "value");
    });

    test("non built-in", () async {
      var human = Human()..name = "ali";

      await SaveAndLoad.save("save-human", HumanSerializer(), human);
      var loaded =
          await SaveAndLoad.load<Human>("save-human", HumanSerializer());
      expect(loaded.hashCode, human.hashCode);
    });
  });
}

void saveAndLoadList() {
  group("save and load list", () {
    test("string", () async {
      await SaveAndLoad.saveList("save-list", null, ["ali", "sohrab"]);
      var loaded = await SaveAndLoad.loadList<String>("save-list", null);
      expect(loaded![0], "ali");
      expect(loaded[1], "sohrab");
    });

    test("non built-in", () async {
      var human = Human()..name = "ali";
      var human2 = Human()..name = "ali2";

      await SaveAndLoad.saveList(
          "save-humans", HumanSerializer(), [human, human2]);
      var loaded =
          await SaveAndLoad.loadList<Human>("save-humans", HumanSerializer());
      expect(loaded![0].name, "ali");
      expect(loaded[1].name, "ali2");
    });
  });
}
