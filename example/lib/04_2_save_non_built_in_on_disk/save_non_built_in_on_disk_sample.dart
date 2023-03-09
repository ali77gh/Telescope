import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class Human{
  int height;
  int weight;
  Human(this.height,this.weight);

  @override
  int get hashCode => height*weight;
}
class HumanOnDiskAbility implements OnDiskSaveAbility<Human>{
  @override
  Human parseOnDiskString(String data) {
    var sp = data.split(":");
    return Human(int.parse(sp[0]), int.parse(sp[1]));
  }

  @override
  String toOnDiskString(Human instance) => "${instance.height}:${instance.weight}";
}


class SaveNonBuiltInOnDiskSampleLayout extends StatefulWidget {
  @override
  State<SaveNonBuiltInOnDiskSampleLayout> createState() => SaveNonBuiltInOnDiskSampleLayoutState();
}

class SaveNonBuiltInOnDiskSampleLayoutState extends State<SaveNonBuiltInOnDiskSampleLayout> {


  static var human = Telescope.saveOnDiskForNonBuiltInType(Human(187, 72), "human_for_bmi", HumanOnDiskAbility());

  // BMI = (Weight in Kilograms / (Height in Meters x Height in Meters))
  static var bmi = Telescope.dependsOn([human], () {
    return human.value.weight / ((human.value.height/100) * (human.value.height/100));
  });

  static var showingText  = Telescope.dependsOn([bmi], () {
    return "weight is ${human.value.weight} and height is ${human.value.height} so bmi will be ${bmi.value.toString().substring(0,5)}";
  });

  @override
  Widget build(BuildContext context) {

    var style = const TextStyle(fontSize: 40);
    print("build");
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(children: [
                const SizedBox(height: 20),
                Text("Weight(kg):",style: style,),
                Slider(
                    value: human.watch(this).weight.toDouble(),
                    min: 1,
                    max: 200,
                    label: human.watch(this).weight.round().toString(),
                    onChanged: (double value) {
                        human.value.weight = value.toInt();
                    }
                ),

                Text("Height(cm):", style: style,),
                Slider(
                    value: human.watch(this).height.toDouble(),
                    min: 1,
                    max: 200,
                    label: human.watch(this).height.round().toString(),
                    onChanged: (double value) {
                      human.value.height = value.toInt();
                    }
                ),
                Text("Result:",style: style,),
                Text(
                    showingText.watch(this),
                  style: style,
                ),
              ],),
            )
        )
    );
  }
}