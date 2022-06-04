import 'package:flutter/material.dart';
import 'package:telescope/src/observable.dart';


class DependObservableSampleLayout extends StatefulWidget {
  @override
  State<DependObservableSampleLayout> createState() => DependObservableSampleLayoutState();
}

class DependObservableSampleLayoutState extends State<DependObservableSampleLayout> {

  // observables
  static var height = Observable(187);
  static var weight = Observable(70);

  // BMI = (Weight in Kilograms / (Height in Meters x Height in Meters))
  static var bmi = Observable(0.0).dependOn([height,weight], () {
    return weight.value / ((height.value/100) * (height.value/100));
  });

  static var showingText = Observable("").dependOn([height,weight,bmi], (){
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