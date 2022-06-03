import 'package:app/object_apply_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:telescope/src/observable.dart';


class DependObservableSampleLayout extends StatefulWidget {

  static var height = Observable(187);
  static var weight = Observable(70);

  // BMI = (Weight in Kilograms / (Height in Meters x Height in Meters))
  static var bmi = Observable(0.0).dependOn([height,weight], () {
    return weight.get(null)! / ((height.get(null)!/100) * (height.get(null)!/100));
  });

  static var showingText = Observable("").dependOn([height,weight,bmi], (){
    return "weight is ${weight.get(null)} and height is ${height.get(null)} so bmi will be ${bmi.get(null).toString().substring(0,5)}";
  });

  @override
  State<DependObservableSampleLayout> createState() => DependObservableSampleLayoutState();
}

class DependObservableSampleLayoutState extends State<DependObservableSampleLayout> {

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
                    value: DependObservableSampleLayout.weight.get(this)!.toDouble(),
                    min: 1,
                    max: 200,
                    label: DependObservableSampleLayout.weight.get(this)!.round().toString(),
                    onChanged: (double value) {
                        DependObservableSampleLayout.weight.value = value.toInt();
                    }
                ),

                Text("Height(cm):",style: style,),
                Slider(
                    value: DependObservableSampleLayout.height.get(this)!.toDouble(),
                    min: 1,
                    max: 200,
                    label: DependObservableSampleLayout.height.get(this)!.round().toString(),
                    onChanged: (double value) {
                      DependObservableSampleLayout.height.value = value.toInt();
                    }
                ),
                Text("Result:",style: style,),
                Text(
                    DependObservableSampleLayout.showingText.get(this)!,
                  style: style,
                ),
              ],),
            )
        )
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}