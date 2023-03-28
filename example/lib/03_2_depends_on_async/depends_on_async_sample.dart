import 'package:flutter/material.dart';
import 'package:telescope/telescope.dart';

class DependObservableAsyncSampleLayout extends StatefulWidget {
  const DependObservableAsyncSampleLayout({Key? key}) : super(key: key);

  @override
  State<DependObservableAsyncSampleLayout> createState() =>
      DependObservableAsyncSampleLayoutState();
}

class DependObservableAsyncSampleLayoutState
    extends State<DependObservableAsyncSampleLayout> {
  // observables
  late Telescope<int> height;
  late Telescope<int> weight;
  late Telescope<double> bmi;
  late Telescope<String> showingText;

  @override
  void initState() {
    super.initState();

    height = Telescope(186);
    weight = Telescope(72);

    bmi = Telescope.dependsOnAsync(0, [height, weight], () async {
      return await calculateBMI(height.value, weight.value);
    });

    showingText = Telescope.dependsOn([height, weight, bmi], () {
      var bmis = bmi.value.toString();
      bmis = bmis.length > 5 ? bmis.substring(0, 5) : bmis;
      return "weight is ${weight.value} and height is ${height.value} so bmi will be $bmis";
    });
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(fontSize: 40);
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Weight(kg):",
                style: style,
              ),
              Slider(
                  value: weight.watch(this).toDouble(),
                  min: 1,
                  max: 200,
                  label: weight.watch(this).round().toString(),
                  onChanged: (double value) {
                    weight.value = value.toInt();
                  }),
              Text(
                "Height(cm):",
                style: style,
              ),
              Slider(
                  value: height.watch(this).toDouble(),
                  min: 1,
                  max: 200,
                  label: height.watch(this).round().toString(),
                  onChanged: (double value) {
                    height.value = value.toInt();
                  }),
              Text(
                "Result:",
                style: style,
              ),
              Text(
                showingText.watch(this),
                style: style,
              ),
            ],
          ),
        )));
  }
}

Future<double> calculateBMI(int w, int h) async {
  await Future.delayed(const Duration(seconds: 2));
  return w / ((h / 100) * (h / 100));
}
