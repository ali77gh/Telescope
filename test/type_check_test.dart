import 'package:flutter/material.dart';
import 'package:telescope/src/telescope.dart';
import 'package:telescope/src/type_check.dart';
import 'package:test/test.dart';


void main(){
  typeCheckBuiltIn();
  typeCheckNonBuiltIn();
  implementsHashCodeTest();
  checkValidTypeTest();
  checkValidTypeItemsTest();
}

void typeCheckBuiltIn(){
  group("TypeCheck built-in", (){

    test("string", () {
      expect(TypeCheck.isBuiltIn<String>(), true);
    });

    test("bool", () {
      expect(TypeCheck.isBuiltIn<bool>(), true);
    });

    test("double", () {
      expect(TypeCheck.isBuiltIn<double>(), true);
    });

    test("int", () {
      expect(TypeCheck.isBuiltIn<int>(), true);
    });
  });
}

void typeCheckNonBuiltIn(){
  group("TypeCheck not built-in", (){

    test("Widget", () {
      expect(TypeCheck.isBuiltIn<Widget>(), false);
    });

    test("Telescope", () {
      expect(TypeCheck.isBuiltIn<Telescope>(), false);
    });

    test("StatefulWidget", () {
      expect(TypeCheck.isBuiltIn<StatefulWidget>(), false);
    });

    test("StatelessWidget", () {
      expect(TypeCheck.isBuiltIn<StatelessWidget>(), false);
    });
  });
}


class Human{
  int age=18;
}
class HashCodeHuman{
  int age=18;
  @override
  int get hashCode=>age.hashCode;
}
void implementsHashCodeTest(){
  group("implements hash code", (){

    test("null", (){
      expect(TypeCheck.implementsHashCodeProperty<String?>(null), true);
    });

    test("human", (){
      expect(TypeCheck.implementsHashCodeProperty(Human()), false);
    });

    test("hash code human", (){
      expect(TypeCheck.implementsHashCodeProperty(HashCodeHuman()), true);
    });

  });
}

void checkValidTypeTest(){
  group("check valid type test", (){

    test("supported String", (){
      expect(TypeCheck.checkIsValidType<String>("string", false), null);
    });

    test("supported Human", (){
      expect(TypeCheck.checkIsValidType<HashCodeHuman>(HashCodeHuman(), false), null);
    });

    test("not supported Human", (){
      expect((){
        TypeCheck.checkIsValidType<Human>(Human(), false);
      }, throwsA(TypeMatcher()));
    });

    test("not supported Human iWillCallNotifyAll", (){
      expect(TypeCheck.checkIsValidType<Human>(Human(), true), null);
    });

  });
}

void checkValidTypeItemsTest(){

  group("check valid type items test", (){

    test("supported empty list", (){
      expect(TypeCheck.checkIsValidTypeForItems([], false), null);
    });

    test("supported String list", (){
      expect(TypeCheck.checkIsValidTypeForItems(["1","2"], false), null);
    });

    test("supported Human list", (){
      expect(TypeCheck.checkIsValidTypeForItems([HashCodeHuman(),HashCodeHuman()], false), null);
    });

    test("not supported Human", (){
      expect((){
        TypeCheck.checkIsValidTypeForItems([Human(),Human()], false);
      }, throwsA(TypeMatcher()));
    });

    test("not supported Human list iWillCallNotifyAll", (){
      expect(TypeCheck.checkIsValidTypeForItems([Human(),Human()], true), null);
    });
  });
}
