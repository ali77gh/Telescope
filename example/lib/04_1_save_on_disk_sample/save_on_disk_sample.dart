import 'package:flutter/material.dart';
import 'package:telescope/src/telescope.dart';


class SaveOnDiskSampleLayout extends StatefulWidget {
  @override
  State<SaveOnDiskSampleLayout> createState() => SaveOnDiskSampleLayoutState();
}

class SaveOnDiskSampleLayoutState extends State<SaveOnDiskSampleLayout> {

  // observables
  static var height = Telescope.saveOnDiskForBuiltInType(187, "bmi_height_input");
  static var weight = Telescope.saveOnDiskForBuiltInType(70, "bmi_weight_input");

  // BMI = (Weight in Kilograms / (Height in Meters x Height in Meters))
  static var bmi = Telescope.dependsOn([height,weight], () {
    return weight.value / ((height.value/100) * (height.value/100));
  });

  static var showingText  = Telescope.dependsOn([bmi], () {
    return "weight is ${weight.value} and height is ${height.value} so bmi will be ${bmi.value.toString().substring(0,5)}";
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
                    value: weight.watch(this).toDouble(),
                    min: 1,
                    max: 200,
                    label: weight.watch(this).round().toString(),
                    onChanged: (double value) {
                        weight.value = value.toInt();
                    }
                ),

                Text("Height(cm):",style: style,),
                Slider(
                    value: height.watch(this).toDouble(),
                    min: 1,
                    max: 200,
                    label: height.watch(this).round().toString(),
                    onChanged: (double value) {
                      height.value = value.toInt();
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